desc "Setup up the CLASSPATH for the Java libraries"
task :maven_classpath do
  sh "mvn org.jruby.plugins:jruby-rake-plugin:classpath -Djruby.classpath.rb=config/initializers/classpath.rb"
end
