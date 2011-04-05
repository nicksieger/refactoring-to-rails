package org.jruby.rack;

import com.strobecorp.kirk.RewindableInputStream;
import org.jruby.rack.servlet.ServletRackEnvironment;
import org.jruby.rack.servlet.ServletRackResponseEnvironment;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import java.io.*;
import java.net.URLDecoder;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * This filter implementation is nearly the same as
 * org.jruby.rack.RackFilter, except the order of execution is flipped.
 * Instead of invoking servlets first and falling back to Ruby, in this
 * filter Ruby is given a chance to handle the request first, and only if an
 * error is returned does the filter continue to the rest of the
 * application. This allows us to incrementally implement the application in
 * Ruby while still taking advantage of existing servlets and JSPs.
 *
 * A version of this filter will probably appear in a future version of
 * JRuby-Rack.
 *
 * @author nicksieger
 */
public class RubyFirstRackFilter implements Filter {
    private RackContext context;
    private RackDispatcher dispatcher;

    public RubyFirstRackFilter() {
    }

    /** Construct a new dispatcher with the servlet context */
    public void init(FilterConfig config) throws ServletException {
        this.context = (RackContext) config.getServletContext().getAttribute(RackApplicationFactory.RACK_CONTEXT);
        this.dispatcher = new DefaultRackDispatcher(this.context);
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
        throws IOException, ServletException {
        RequestCapture          reqCapture   = new RequestCapture((HttpServletRequest) request);
        ResponseCapture         respCapture  = new ResponseCapture((HttpServletResponse) response);
        RackEnvironment         env          = new ServletRackEnvironment(reqCapture, context);
        RackResponseEnvironment responseEnv  = new ServletRackResponseEnvironment(respCapture);

        request.setAttribute(RackEnvironment.DYNAMIC_REQS_ONLY, Boolean.TRUE);
        dispatcher.process(env, responseEnv);

        if (respCapture.isError()) {
            reqCapture.reset();
            response.reset();
            chain.doFilter(reqCapture, response);
        }
    }

    public void destroy() {
    }

    private static class RequestCapture extends HttpServletRequestWrapper {
        private RewindableInputStream inputStream;
        private Map<String,String[]> requestParams;
        public RequestCapture(HttpServletRequest request) {
            super(request);
        }

        @Override public BufferedReader getReader() throws IOException {
            if (inputStream != null) {
                String enc = getCharacterEncoding();
                if (enc == null) {
                    enc = "UTF-8";
                }
                return new BufferedReader(new InputStreamReader(inputStream, enc));
            } else {
                return super.getReader();
            }
        }

        @Override public ServletInputStream getInputStream() throws IOException {
            if (inputStream == null) {
                inputStream = new RewindableInputStream(super.getInputStream());
            }
            return new ServletInputStream() {
                @Override
                public long skip(long l) throws IOException {
                    return inputStream.skip(l);
                }

                @Override
                public int available() throws IOException {
                    return inputStream.available();
                }

                @Override
                public void close() throws IOException {
                    inputStream.close();
                }

                @Override
                public void mark(int i) {
                    inputStream.mark(i);
                }

                @Override
                public void reset() throws IOException {
                    inputStream.reset();
                }

                @Override
                public boolean markSupported() {
                    return inputStream.markSupported();
                }

                @Override
                public int read(byte[] bytes) throws IOException {
                    return inputStream.read(bytes);
                }

                @Override
                public int read(byte[] bytes, int i, int i1) throws IOException {
                    return inputStream.read(bytes, i, i1);
                }

                @Override
                public int read() throws IOException {
                    return inputStream.read();
                }
            };
        }

        @Override
        public String getParameter(String name) {
            if (getReParsedParameterMap() != null) {
                String[] values = requestParams.get(name);
                if (values != null) {
                    return values[0];
                }
                return null;
            } else {
                return super.getParameter(name);
            }
        }

        @Override
        public Map getParameterMap() {
            if (getReParsedParameterMap() != null) {
                return requestParams;
            } else {
                return super.getParameterMap();
            }
        }

        @Override
        public Enumeration getParameterNames() {
            if (getReParsedParameterMap() != null) {
                return new Enumeration() {
                    Iterator keys = requestParams.keySet().iterator();
                    public boolean hasMoreElements() {
                        return keys.hasNext();
                    }

                    public Object nextElement() {
                        return keys.next();
                    }
                };
            } else {
                return super.getParameterNames();
            }
        }

        @Override
        public String[] getParameterValues(String name) {
            if (getReParsedParameterMap() != null) {
                return requestParams.get(name);
            } else {
                return super.getParameterValues(name);
            }
        }

        private Map getReParsedParameterMap() {
            if (requestParams != null) {
                return requestParams;
            }
            if (inputStream == null || getContentType() == null ||
                    !getContentType().equals("application/x-www-form-urlencoded")) {
                return null;
            }
            // Need to re-parse form params from the request
            // All this because you can't mix use of request#getParameter
            // and request#getInputStream in the Servlet API.
            requestParams = new HashMap<String,String[]>();
            String line = "";
            try {
                line = getReader().readLine();
            } catch (IOException e) {
            }
            String[] pairs = line.split("\\&");
            for (int i = 0; i < pairs.length; i++) {
                try {
                    String[] fields = pairs[i].split("=", 2);
                    String key = URLDecoder.decode(fields[0], "UTF-8");
                    String value = null;
                    if (fields.length == 2) {
                        value = URLDecoder.decode(fields[1], "UTF-8");
                    }
                    if (value != null) {
                        String[] newValues;
                        if (requestParams.containsKey(key)) {
                            String[] values = requestParams.get(key);
                            newValues = new String[values.length + 1];
                            System.arraycopy(values, 0, newValues, 0, values.length);
                            newValues[values.length] = value;
                        } else {
                            newValues = new String[1];
                            newValues[0] = value;
                        }
                        requestParams.put(key, newValues);
                    }
                } catch (UnsupportedEncodingException e) {
                }
            }
            return requestParams;
        }

        public void reset() throws IOException {
            if (inputStream != null) {
                inputStream.rewind();
            }
        }
    }

    private static class ResponseCapture extends HttpServletResponseWrapper {
        private int status = 200;

        public ResponseCapture(HttpServletResponse response) {
            super(response);
        }

        @Override public void sendError(int status, String message) throws IOException {
            this.status = status;
        }

        @Override public void sendError(int status) throws IOException {
            this.status = status;
        }

        @Override public void sendRedirect(String path) throws IOException {
            this.status = 302;
            super.sendRedirect(path);
        }

        @Override public void setStatus(int status) {
            this.status = status;
            if (!isError()) {
                super.setStatus(status);
            }
        }

        @Override public void setStatus(int status, String message) {
            this.status = status;
            if (!isError()) {
                super.setStatus(status, message);
            }
        }

        @Override public void flushBuffer() throws IOException {
            if (!isError()) {
                super.flushBuffer();
            }
        }

        @Override public ServletOutputStream getOutputStream() throws IOException {
            if (isError()) {
                // swallow output, because we're going to discard it
                return new ServletOutputStream() {
                    @Override public void write(int b) throws IOException {
                    }
                };
            } else {
                return super.getOutputStream();
            }
        }

        @Override
        public PrintWriter getWriter() throws IOException {
            if (isError()) {
                // swallow output, because we're going to discard it
                return new PrintWriter(new OutputStream() {
                    @Override public void write(int i) throws IOException {
                    }
                });
            } else {
                return super.getWriter();
            }
        }

        private boolean isError() {
            return status >= 400;
        }
    }
}
