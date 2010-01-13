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
  import WebApplicationContextUtils
  CONTEXT = WebApplicationContextUtils.getWebApplicationContext(servletContext)
  def self.context
    CONTEXT
  end
end
