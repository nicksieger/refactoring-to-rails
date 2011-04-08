require 'spring_helpers'

module Spring
  $CLASSPATH << File.join(Rails.root, 'config') unless defined?($servlet_context)
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
end
