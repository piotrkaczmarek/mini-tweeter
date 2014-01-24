Feature: accepting invitations
  As a user who was invited by organization
  So that I can join organization
  I want to view and accept invitations

Background: users and organizations in database
  Given the following users exist:
  | id | name | email            | organization_id |
  | 0  | John | john@example.com | 0               |
  | 1  | Bob  | bob@example.com  | 1               |
  | 2  | Paul | p@example.com    | nil             |

  Given the following organizations exist:
  | id  | name | homesite_url | admin_id |
  | 0   | Org1 | org1.com     | 0        |
  | 1   | Org2 | org2.com     | 1        |



  Scenario: view invitations
    Given the following invitations exist:
    | invited_user | inviting_organization |
    | Paul         | Org1                  |
    | Paul         | Org2                  | 
    And I am logged in as Paul
    And I am on the home page
    Then I should see "2 invitations"
    And I follow "2 invitations"
    Then I should see "Org1"
    And I should see "Org2"
    And I should see "Accept" button
    And I should see "Reject" button

  Scenario: accept invitation
    Given the following invitations exist:
    | invited_user | inviting_organization |
    | Paul         | Org1                  |
    And I am logged in as Paul
    And I follow "1 invitation"
    And I press "Accept"
    Then I should be a member of Org1

  Scenario: reject invitation
    Given the following invitations exist:
    | invited_user | inviting_organization |
    | Paul         | Org1                  |
    And I am logged in as Paul
    And I follow "1 invitation"
    And I press "Reject"
    Then there should be no invitation to Org1 for Paul
    And I should not be in any organization
