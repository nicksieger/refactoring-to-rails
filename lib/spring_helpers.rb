require 'java'

module org::springframework::beans::factory::BeanFactory
  def [](key)
    getBean(key)
  end

  def include?(key)
    containsBean(key)
  end
end

module org::hibernate::SessionFactory
  def with_session
    begin
      session = openSession
      yield session
    ensure
      session.close
    end
  end

  def transaction(&block)
    with_session do |session|
      session.with_transaction(&block)
    end
  end
end

module org::hibernate::Session
  def with_transaction
    begin
      tx = beginTransaction
      yield self
      tx.commit
    rescue
      tx.rollback
    end
  end
end

class org::springframework::samples::petclinic::BaseEntity
  def self.name
    super.split('::')[-1]
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

  def persisted?
    !new?
  end

  def update_attributes(attrs)
    attrs.each do |k,v|
      send("#{k}=", v) if respond_to?("#{k}=")
    end
  end
end
