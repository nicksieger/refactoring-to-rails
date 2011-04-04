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
  content_type 'application/atom+xml'
  visits = clinic.loadPet(pet_id.to_i).visits
  builder do |xml|
    xml.feed :xmlns => "http://www.w3.org/2005/Atom" do
      xml.title "Pet Clinic Visits"
      xml.id "tag:springsource.com"
      xml.updated visits.max {|a,b| a.date <=> b.date }.date.to_time.xmlschema
      visits.each do |visit|
        xml.entry do
          date = visit.date.to_date.strftime('%Y-%m-%d')
          xml.title "#{visit.pet.name} visit on #{date}"
          xml.id "tag:springsource.com,#{date}:#{visit.id}"
          xml.updated visit.date.to_time.xmlschema
          xml.summary visit.description
        end
      end
    end
  end
end
