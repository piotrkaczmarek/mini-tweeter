Feature: managing organizations
  As a organization member and tweeter user
  So that I can tweet as a organization
  I want to manage organization

Background: microposts, users and organizations in database
  Given the following users exist:
  | id | name | email            | organization_id |
  | 0  | John | john@example.com | 0               |
  | 1  | Bob  | bob@example.com  | 1               |
  | 2  | Paul | p@example.com    | 1               |
  | 3  | Ian  | i@example.com    | 0               |
  | 4  | Ann  | a@exasgf.sfst    | nil             |

  Given the following microposts exist:
  | id | content      | rated_by | rating | user |
  | 0  | "text"       | 0        | 0.0    | John | 
  | 1  | "bobs_text"  | 2        | 4.0    | Bob  |

  Given the following organizations exist:
  | id  | name | homesite_url | admin_id |
  | 0   | Org1 | org1.com     | 0        |
  | 1   | Org2 | org2.com     | 1        |

  Given I am logged in as John

  Scenario: create organization (explicit gui test)
    Given I am on the home page
    And I follow "Organizations"
    Then I should be on the organizations page
    And I follow "Create new organization"
    And I create organization named "Corpo" with homesite "corpo.com"
    Then I should be on the organizations page
    And I should see "Corpo"
    And I follow "Corpo"
    And I follow "members"
    Then I should see "John"
    And I should be following organization Corpo
 

  Scenario: viewing organizations list
    Given I am on the organizations page
    Then I should see "Org1"
    And I should see "Org2"

  Scenario: viewing members list
    Given I am on the organizations page
    And I follow "Org2"
    And I follow "members"
    Then I should see "Bob"
    And I should see "Paul"
    And I should not see "John"

  Scenario: removing member from members list
    Given I am on the organizations page
    And I follow "Org1"
    And I follow "members"
    Then I follow "remove" within "li#member_3"
    Then I should see "Ian removed from Org1"
    And I should be on the Org1's members page

  Scenario: removing member from user page
    Given I am on Ian's user page
    And I press "Uninvite from Org1"
    Then I should see "Ian removed from Org1"
    And I go to the Org1's members page
    Then I should not see "Ian"

  Scenario: trying to add member of another organization
    Given I am on Paul's user page
    Then I should not see "Invite " button
    And I should not see "Uninvite" button
    
