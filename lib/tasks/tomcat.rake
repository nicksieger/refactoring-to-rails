namespace :tomcat do
  desc "Start the application using Tomcat"
  task :run do
    output = ""
    output = " > #{ENV['TOMCAT_OUTPUT']} 2>&1" if ENV['TOMCAT_OUTPUT']
    sh "mvn org.codehaus.mojo:tomcat-maven-plugin:run -Dmaven.tomcat.path=/ -Dmaven.tomcat.port=3000#{output}"
  end

  task :background do
    require 'open-uri'
    begin
      open('http://localhost:3000/')
    rescue
      # Start Tomcat if not already running, and stop it when we're done
      @thread ||= begin
          at_exit do
            Rake::Task['tomcat:kill'].invoke
          end
          Thread.new do
            ENV['TOMCAT_OUTPUT'] = "app.log"
            Rake::Task['tomcat:run'].invoke
          end
        end
      sleep 2
      @waiting ||= begin; puts "Stand by while Tomcat finishes booting..."; true; end
      retry
    end
  end

  task :kill do
    tomcat_pid = `jps -m`.detect{|l| l =~ /tomcat-maven/}.to_i
    if tomcat_pid > 0
      puts "Killing Tomcat with PID #{tomcat_pid}"
      sh "kill #{tomcat_pid}"
    end
  end
end

task 'cucumber:ok' => 'tomcat:background'
task 'cucumber:wip' => 'tomcat:background'
task 'cucumber:rerun' => 'tomcat:background'
task 'cucumber:extended' => 'tomcat:background'
