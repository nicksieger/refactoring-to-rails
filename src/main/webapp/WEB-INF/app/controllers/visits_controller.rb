class VisitsController < ApplicationController
  def index
    @visits = clinic.loadPet(params[:id].to_i).visits
  end
end
