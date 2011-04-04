begin
  require 'rubygems'
  require 'bundler/setup'
rescue LoadError
  fail "Please 'gem install bundler' and 'bundle install' first."
end

FileList['lib/tasks/*.rake'].each {|f| import f }
