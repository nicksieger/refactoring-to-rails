class ApplicationController < ActionController::Base
  protect_from_forgery

  require 'spring_helpers'
  include Spring
end
