When /^(?:|I )fill in "([^\"]*)" with "([^\"]*)"(?: within "([^\"]*)")? if present$/ do |field, value, selector|
  with_scope(selector) do
    begin
      fill_in(field, :with => value)
    rescue Capybara::ElementNotFound
    end
  end
end
