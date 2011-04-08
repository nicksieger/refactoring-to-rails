xml.feed :xmlns => "http://www.w3.org/2005/Atom" do
  xml.title "Pet Clinic Visits"
  xml.id "tag:springsource.com"
  xml.updated @visits.max {|a,b| a.date <=> b.date }.date.to_time.xmlschema
  @visits.each do |visit|
    xml.entry do
      date = visit.date.to_date.strftime('%Y-%m-%d')
      xml.title "#{visit.pet.name} visit on #{date}"
      xml.id "tag:springsource.com,#{date}:#{visit.id}"
      xml.updated visit.date.to_time.xmlschema
      xml.summary visit.description
    end
  end
end
