When /^(?:|I )download "([^\"]*)"(?: within "([^\"]*)")?$/ do |link, selector|
  with_scope(selector) do
    begin
      click_link(link)
    rescue Celerity::Exception::UnexpectedPageException
      # This is ok
    end
  end
end

Then /^I should see an XML document$/ do
  page.response_headers["Content-Type"].should =~ /xml/
  @document = Nokogiri::XML(source)
end

Then /^I should see an element containing "([^\"]*)"$/ do |text|
  @document.xpath("//.").detect {|n| n.text =~ /#{text}/ }.should_not be_nil
end

Then /^I should see a JSON document$/ do
  page.response_headers["Content-Type"].should =~ /json/
  @document = JSON.parse(source)
end

Then /^I should see a JSON structure containing "([^\"]*)"$/ do |arg|
  traverse(@document) do |elem|
    elem.to_s =~ /#{arg}/
  end.should be_true
end
