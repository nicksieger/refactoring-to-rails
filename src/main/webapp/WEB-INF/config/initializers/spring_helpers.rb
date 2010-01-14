Rails.public_path = Rails.public_path + "/static"
if defined?($servlet_context)
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
    import org.springframework.web.context.support.WebApplicationContextUtils
    CONTEXT = WebApplicationContextUtils.getWebApplicationContext($servlet_context)
    def self.context
      CONTEXT
    end

    def self.included(base)
      base.extend self
    end

    def session_factory
      CONTEXT['sessionFactory']
    end

    def clinic
      CONTEXT['clinic']
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

end
