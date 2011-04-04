require 'builder'
require 'erb'
require 'json'
require 'spring_helpers'
require 'java_ext'

helpers do
  include Spring
end

get '/rack/' do
  '<h1>Sinatra</h1>'
end

get '/rack/vets.xml' do
  builder(:vets, { :content_type => 'application/vnd.petclinic+xml' },
          :vets => clinic.vets)
end

get '/rack/vets.json' do
  content_type 'application/json'
  JSON.pretty_generate(clinic.vets.map do |vet|
    { "id" => vet.id,
      "firstName" => vet.firstName,
      "lastName" => vet.lastName
    }.tap do |h|
      unless vet.specialties.empty?
        h["specialties"] = vet.specialties.map {|s| { "id" => s.id, "name" => s.name } }
      end
    end
  end)
end

get '/rack/owners/:owner/pets/:pet/visits.atom' do |owner_id, pet_id|
  builder(:visits, { :content_type => 'application/atom+xml' },
          :visits => clinic.loadPet(pet_id.to_i).visits)
end
