Feature: changing organization admin
  As a organization admin
  So that I can give admin rights to someone else
  I want to change admin of my organization

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

