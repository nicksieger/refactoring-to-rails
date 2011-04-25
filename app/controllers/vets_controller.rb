class VetsController < ApplicationController
  def index
    @vets = Vet.all
    respond_to do |format|
      format.html
      format.xml do
        render :xml => @vets.to_a.to_xml
      end
      format.json do
        render :json => @vets.to_a.to_json
      end
    end
  end
end
