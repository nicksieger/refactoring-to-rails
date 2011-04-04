Feature: Browsing around

  Scenario: The home page
    Given I am on the home page
    Then I should see "Welcome"

  Scenario: Vets
    Given I am on the home page
    And I follow "Display all veterinarians"
    Then I should be on the vets page
    And I should see "Veterinarians" within "h2"

  Scenario: Owners
    Given I am on the home page
    And I follow "Find owner"
    Then I should see "Last name"
    When I fill in "lastName" with "Franklin"
    And I press "Find Owners"
    Then I should see "George"
    And I should see "Franklin"

