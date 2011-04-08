class ApplicationController < ActionController::Base
  protect_from_forgery

  require 'java_ext'
  require 'spring_helpers'
  include Spring
end
