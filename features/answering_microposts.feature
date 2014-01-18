Feature: Answering microposts
  As a someone's follower
  So that I can answer directly to someone's tweet
  I want to post my tweets as an answer to someone's tweet

Background: microposts and users in database
  Given the following users exist:
  | id | name | email            |
  | 0  | John | john@example.com |
  | 1  | Bob  | bob@example.com  |

  Given I am logged in as John

  Given the following microposts exist:
  | id | content      | rated_by | rating | user |
  | 0  | "text"       | 0        | 0.0    | John |
  | 1  | "bobs_text"  | 2        | 4.0    | Bob  |

  Scenario: answer to micropost from home page
    Given I follow Bob
    And I am on the home page
    When I answer Bob's latest micropost
    Then I should see "@Bob: " within ".new_micropost"
    And I should see "Bob wrote " within ".new_micropost"
    And I press "Post"
    And I should see "Answer to"
    And I should see "Posted by Bob"
    And I should see "bobs_text"
  
  Scenario: deleting not answered post
    Given I am on the home page
    And I press "delete" within "div#micropost_0"
    Then I should not see "text"

  Scenario: deleting answered post
    Given I am on the home page
    And I answer John's latest micropost
    And I should see "delete" button within "div#micropost_0"
    And I press "Post"
    Then I should not see "delete" button within "div#micropost_0"
