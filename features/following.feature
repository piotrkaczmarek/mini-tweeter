Feature: following users and organizations
  As fan of some organizations and people
  So that I can read what they tweeted
  I want to be able to follow people and organizations

Background: microposts, users and organizations in database
  Given the following users exist:
  | id | name | email            | organization_id |
  | 0  | John | john@example.com | 0               |
  | 1  | Bob  | bob@example.com  | 1               |
  | 2  | Paul | p@example.com    | 1               |
  | 3  | Ian  | i@example.com    | 0               |
  | 4  | Ann  | a@exasgf.sfst    | nil             |

  Given the following microposts exist:
  | id | content      | rated_by | rating | user | organization_id |
  | 0  | mine         | 0        | 0.0    | John | nil             |
  | 1  | "bobs_text"  | 2        | 4.0    | Bob  | nil             |
  | 2  | pauls_post   | 0        | 0.0    | Paul | nil             |
  | 3  | orgs2_post   | 0        | 0.0    | Paul | 1               |
  | 4  | anns         | 5        | 3.0    | Ann  | nil             |         

  Given the following organizations exist:
  | id  | name | homesite_url | admin_id |
  | 0   | Org1 | org1.com     | 0        |
  | 1   | Org2 | org2.com     | 1        |

  Given I am logged in as John

  


Scenario: following user
  Given I am on Bob's user page
  And I press "Follow"
  And I am on the home page
  Then I should see "bobs_text"
  And I should see "mine"
  And I should not see "pauls_post"


Scenario: unfollowing user
  Given I follow Bob
  And I am on Bob's user page
  And I press "Unfollow"
  And I am on the home page
  Then I should not see "bobs_text"
  And I should see "mine"
  And I should not see "pauls_post"
  
  
Scenario: following organization
  Given I am on Org2's organization page
  And I press "Follow"
  And I am on the home page
  Then I should see "orgs2_post"
  And I should not see "pauls_post"

Scenario: unfollowing organization
  Given I follow organization Org2
  And I am on the home page
  Then I should see "orgs2_post"
  Then I am on Org2's organization page
  And I press "Unfollow"
  And I am on the home page
  Then I should not see "orgs2_post"


Scenario: following organizations and users
  Given I follow Ann
  And I follow organization Org2
  And I am on the home page
  Then I should see "orgs2_post"
  And I should see "anns"
  And I should see "mine"
