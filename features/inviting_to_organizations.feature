Feature: inviting to organizations
  As a organization admin
  So that I can have members in my organization
  I want to invite other user to my organization

Background: users and organizations in database
  Given the following users exist:
  | id | name | email            | organization_id |
  | 0  | John | john@example.com | 0               |
  | 1  | Bob  | bob@example.com  | 1               |
  | 2  | Paul | p@example.com    | nil             |

  Given the following organizations exist:
  | id  | name | homesite_url | admin_id |
  | 0   | Org1 | org1.com     | 0        |
  | 1   | Org2 | org2.pl      | 2        |

  
  Scenario: invite user who is not a member of any organization
    Given I am logged in as John
    And I am on Paul's user page
    And I press "Invite to Org1"
    Then there should be invitation to Org1 for Paul
    And I should be on Paul's user page
    And I should see "Uninvite" button

  Scenario: invite user who is a member of another organization
    Given I am logged in as John
    And I am on Bob's user page
    And I press "Invite to Org1"
    Then there should be invitation to Org1 for Bob
    And I should be on Bob's user page
    And I should see "Uninvite" button

  Scenario: cancel invitation before acceptance
    Given I am logged in as John
    And I invite Paul
    And I press "Uninvite from Org1"
    Then there should be no invitation to Org1 for Paul
    And I should see "Invite" button
