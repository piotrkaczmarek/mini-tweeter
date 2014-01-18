Feature: posting as organization
  As a organization member and tweeter user
  So that I can tweet as a organization
  I want to post as organization

Background: microposts, users and organizations in database
  Given the following users exist:
  | id | name | email            | organization_id |
  | 0  | John | john@example.com | 0               |
  | 1  | Bob  | bob@example.com  | 1               |
  | 2  | Ian  | ian@example.com  | 1               |
  | 3  | Ann  | ann@example.com  | nil             |

  Given the following microposts exist:
  | id | content      | rated_by | rating | user | organization_id |
  | 0  | mine         | 0        | 0.0    | John | nil             |
  | 1  | "bobs_text"  | 2        | 4.0    | Bob  | nil             |
  
  Given the following organizations exist:
  | id  | name | homesite_url | admin_id |
  | 0   | Org1 | org1.com     | 0        |
  | 1   | Org2 | org2.com     | 1        |


Scenario: post as organization
  Given I am logged in as John
  And I am on the home page
  Then I fill post content with "Johns org post"
  Then I should see "Post as organization"
  And I check "micropost_organization_id"
  And I press "Post"
  Then I sign out
  And I log in as Bob
  Then I follow organization Org1
  And I am on the home page
  Then I should see "Johns org post"
  And I should not see "mine"

Scenario: organization post is marked as one
  Given I am logged in as John
  Given the following microposts exist:
  | id | content      | rated_by | rating | user | organization_id |
  | 3  | org2_post    | 0        | 0.0    | Bob  | 1               |
  And I follow organization Org2
  And I am on the home page
  Then I should see "Org2"

Scenario: not being a member of organization
  Given I am logged in as Ann
  And I am on the home page
  Then I should not see "Post as organization"

Scenario: being a member of organization
  Given I am logged in as Ian
  And I am on the home page
  Then I should see "Post as organization"
