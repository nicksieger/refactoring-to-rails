task :maven_classpath do
  sh "mvn org.jruby.plugins:jruby-rake-plugin:classpath -Djruby.classpath.rb=config/initializers/classpath.rb"
end
