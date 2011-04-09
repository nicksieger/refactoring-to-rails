# This requires that the generated classpath.rb in this directory was
# already loaded.
require 'java'
$CLASSPATH << File.join(Rails.root, 'config') unless defined?($servlet_context)
Maven.set_classpath unless defined?($servlet_context)
