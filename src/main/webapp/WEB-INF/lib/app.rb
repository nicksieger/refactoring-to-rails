require 'builder'
require 'erb'
require 'spring_helpers'

helpers do
  include Spring
end

get '/rack/' do
  '<h1>Sinatra</h1>'
end

get '/rack/vets.xml' do
  content_type 'application/vnd.petclinic+xml'
  builder do |xml|
    xml.instruct!
    xml.vets do
      clinic.vets.each do |vet|
        xml.vetList do
          xml.id vet.id
          xml.firstName vet.firstName
          xml.lastName vet.lastName
          vet.specialties.each do |spec|
            xml.specialties do
              xml.id spec.id
              xml.name spec.name
            end
          end
        end
      end
    end
  end
end
