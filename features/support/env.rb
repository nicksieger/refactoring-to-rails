# Hat tip to http://stackoverflow.com/questions/3164593/is-it-possible-to-test-java-application-with-capybara/3607791#3607791
require 'capybara'
require 'capybara/cucumber'
require 'capybara/session'

require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
require 'cucumber/web/tableish'

require 'celerity'

Capybara.default_driver = :celerity
Capybara.use_default_driver
Capybara.run_server = false
Capybara.app_host = ENV["TESTURL"] || 'http://localhost:3000'
