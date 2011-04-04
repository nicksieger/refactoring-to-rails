xml.instruct!
xml.vets do
  vets.each do |vet|
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
