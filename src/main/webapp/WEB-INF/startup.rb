require 'gems/jruby/1.8/environment'

module org::springframework::beans::factory::BeanFactory
  def [](key)
    getBean(key)
  end

  def include?(key)
    containsBean(key)
  end
end

module Spring
  import org.springframework.web.context.support.WebApplicationContextUtils
  CONTEXT = WebApplicationContextUtils.getWebApplicationContext($servlet_context)
  def self.context
    CONTEXT
  end
end

require 'drbirb/loader'
