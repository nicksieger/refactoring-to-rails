atom_feed :id => "tag:springsource.com" do |feed|
  feed.title("Pet Clinic Visits")
  feed.updated(@visits.max(&:date).date)

  for visit in @visits
    feed.entry(visit,
               :id => "tag:springsource.com,#{visit.date}:#{visit.id}",
               :url => owner_pet_url(@pet.owner, @pet)) do |entry|
      entry.title("#{@pet.name} visit on #{visit.date}")
      entry.content(visit.description, :type => 'text')
      entry.updated(visit.date)
    end
  end
end
