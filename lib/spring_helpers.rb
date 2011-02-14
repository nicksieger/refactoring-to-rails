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
      session.transaction(&block)
    end
  end
end

module org::hibernate::Session
  def transaction
    begin
      tx = beginTransaction
      yield self
      tx.commit
    rescue
      tx.rollback
    end
  end
end
