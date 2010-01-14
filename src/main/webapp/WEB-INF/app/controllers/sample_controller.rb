class SampleController < ApplicationController
  def index
    render :text => "hello from #{self.class}"
  end
end
