Feature: Rating microposts

  Scenario: Rating micropost for the first time
    Given a user visits the home page
    When he clicks 'rate 3' button
    Then he should see rated_by equal 1
    And he should see rating equal 3

  Scenario: Rating the same micropost for the second time
    Given a user visits the home page
    When he clicks 'rate 3' button
    And he clicks 'rate 4' button
    Then he should see rated_by equal 1
    And he should see rating equal 4
