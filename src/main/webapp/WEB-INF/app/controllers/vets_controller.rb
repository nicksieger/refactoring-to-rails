class VetsController < ApplicationController
  def index
    @vets = clinic.vets
  end
end
