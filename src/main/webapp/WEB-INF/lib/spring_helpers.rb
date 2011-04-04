require 'java'

module org::springframework::beans::factory::BeanFactory
  def [](key)
    getBean(key)
  end

  def include?(key)
    containsBean(key)
  end
end

module Spring
  CONTEXT = $servlet_context.getAttribute(org.springframework.web.context.WebApplicationContext::ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE)

  def context
    CONTEXT
  end

  def clinic
    context['clinic']
  end
end
