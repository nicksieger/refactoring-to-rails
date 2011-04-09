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
  def self.included(base)
    base.extend self
  end

  def context
    CONTEXT
  end

  def clinic
    context['clinic']
  end
end

class org::springframework::samples::petclinic::BaseEntity
  def self.name
    super.split('::')[-1]
  end

  def persisted?
    !new?
  end
end
