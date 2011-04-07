class VetsController < ApplicationController
  def index
    @vets = clinic.vets
    respond_to do |format|
      format.html
      format.xml
      format.json do
        vets_hash = @vets.map do |vet|
          { "id" => vet.id,
            "firstName" => vet.firstName,
            "lastName" => vet.lastName
          }.tap do |h|
            unless vet.specialties.empty?
              h["specialties"] = vet.specialties.map {|s| { "id" => s.id, "name" => s.name } }
            end
          end
        end
        render :json => vets_hash
      end
    end
  end
end
