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

  # Since the Hibernate model classes are technically not fully
  # unloaded every request (even though the constants are), we need to
  # reset validations here.
  def self.before_remove_const
    if respond_to?(:_validators)
      _validators.clear
      reset_callbacks(:validate)
    end
  end

  def update_attributes(attrs)
    date_values = {}
    attrs.each do |k,v|
      if k =~ /\(/
        md = /(.*)\((.*)\)/.match(k)
        date_values[md[1]] ||= []
        date_values[md[1]][md[2].to_i - 1] = v.to_i
      else
        send("#{k}=", v) if respond_to?("#{k}=")
      end
    end
    date_values.each do |k,v|
      if v.length > 3
        send("#{k}=", Time.zone.local(*v))
      else
        send("#{k}=", Date.new(*v))
      end
    end
  end
end
