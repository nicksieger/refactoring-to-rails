require 'rubygems'
require 'sinatra'

if development?
  require 'sinatra/reloader'
  use Rack::ShowExceptions
end

$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'app'

set :run, false
run Sinatra::Application
