Feature: Vets

  Scenario: View vets as XML
    Given I am on the vets page
    When I download "View as XML"
    Then I should see an XML document
    And I should see an element containing "Carter"

  @extended
  Scenario: View vets as JSON
    Given I am on the vets page
    When I download "View as JSON"
    Then I should see a JSON document
    And I should see a JSON structure containing "Carter"
