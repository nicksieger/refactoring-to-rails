require 'spring_helpers'

module Spring
  $CLASSPATH << File.join(Rails.root, 'src/main/webapp/WEB-INF/spring') unless defined?($servlet_context)
  SPRING_XML_CONFIG_FILES = %w(
       applicationContext-dataSource
       applicationContext-hibernate
     ).map { |c|
    "classpath:#{c}.xml"
  }.to_java :string

  CONTEXT = org.springframework.context.support.ClassPathXmlApplicationContext.new SPRING_XML_CONFIG_FILES
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
