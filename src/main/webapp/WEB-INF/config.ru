require 'rubygems'
require 'sinatra'

if development?
  require 'sinatra/reloader'
  use Rack::ShowExceptions
end

base = File.expand_path('..', __FILE__)
$LOAD_PATH << File.join(base, 'lib')
require 'app'

set :run, false
set :views, File.join(base, 'views')
run Sinatra::Application
