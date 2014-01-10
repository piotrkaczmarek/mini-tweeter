Feature: Rating microposts
  As a tweet follower and reader
  So that I can give my opinion
  I want to rate tweets

Background: microposts and users in database
  Given the following users exist:
  | id | name | email            |
  | 0  | John | john@example.com |
  | 1  | Bob  | bob@example.com  |

  Given I am logged in as John

  Given the following microposts exist:
  | id | content | rated_by | rating | user |
  | 1  | "text"  | 0        | 0.0    | John |
  | 2  | "bobs"  | 2        | 4.0    | Bob  |

#  Given the following relationships exist:
#  | follower_id | followed_id |
#  | John        | Bob         | 


  Scenario: rate micropost for the first time
    Given I am on the home page
    When I give micropost 1 a rate of 4
    Then I should see "by 1 user"
    And I should see "Rated 4.0 "
    And I should be on the home page

  Scenario: rate micropost for the second time
    Given I am on the home page
    When I give micropost 1 a rate of 4
    And I give micropost 1 a rate of 3
    Then I should see "by 1 user"
    And I should see "Rated 3.0 "
    And I should be on the home page

  Scenario: rate micropost several times
   Given I am on the home page
   When I give micropost 1 a rate of 1
   Then I should see "Rated 1.0 "
   And I give micropost 1 a rate of 2
   Then I should see "Rated 2.0 "
   And I give micropost 1 a rate of 3
   Then I should see "Rated 3.0 "
   And I give micropost 1 a rate of 4
   Then I should see "Rated 4.0 "
   And I give micropost 1 a rate of 5
   Then I should see "Rated 5.0 "
   And I give micropost 1 a rate of 4
   Then I should see "Rated 4.0 "
   And I give micropost 1 a rate of 3
   Then I should see "Rated 3.0 "
   And I give micropost 1 a rate of 2
   Then I should see "Rated 2.0 "
   And I give micropost 1 a rate of 1
   Then I should see "Rated 1.0 "
    And I should be on the home page

  Scenario: rate micopost of other user
    Given I follow Bob
    And I am on the home page
    When I give micropost 2 a rate of 5
    Then I should see "by 3 users"
    And I should see "Rated 4.3 "
    And I should be on the home page

  Scenario: rating on users page
    Given I am on Bob's user page
    And I follow Bob
    And I give micropost 2 a rate of 2
    Then I should see "by 3 users"
    And I should see "Rated 3.3"
    #And I should be on Bob's user page
  
    
