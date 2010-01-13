package net.caldersphere.webdemos;

import java.util.Arrays;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import org.jruby.embed.ScriptingContainer;

/**
 * Launch a Ruby script at web application startup. To wire up this
 * listener, add
 * <listener-class>net.caldersphere.webdemos.StartupScriptLauncher</listener-class> to your
 * application's web.xml file.
 *
 * @author nicksieger
 */
public class StartupScriptLauncher implements ServletContextListener {
    private ScriptingContainer container;

    public void contextInitialized(ServletContextEvent event) {
        ServletContext servletContext = event.getServletContext();
        try {
            container = new ScriptingContainer();
            // setup any global variables
            container.put("$servlet_context", servletContext);

            // Setup load path
            // (Note: JRuby 1.5 API has #setLoadPaths(List))
            container.put("path1", servletContext.getRealPath("/WEB-INF"));
            container.put("path2", servletContext.getRealPath("/WEB-INF/lib"));
            container.runScriptlet("$LOAD_PATH << path1 << path2");

            // require e.g., WEB-INF/startup.rb
            container.runScriptlet("require 'startup'");
        } catch (Exception ex) {
            ex.printStackTrace();
            servletContext.log(ex.getMessage());
        }
    }

    public void contextDestroyed(ServletContextEvent event) {
        // require e.g., WEB-INF/shutdown.rb
        container.runScriptlet("require 'shutdown'");
        container = null;
    }
}
