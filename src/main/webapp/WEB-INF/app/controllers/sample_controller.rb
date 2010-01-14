class SampleController < ApplicationController
  def index
    render :text => "Hello from #{self.class.name}"
  end

  def routes
    render :text => ActionController::Routing::Routes.routes.to_s
  end
end
