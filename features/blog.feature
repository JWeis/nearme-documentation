Feature: Blog with administration
Blog admin (usually instance admin) can CRUD blog posts and manage blog settings.
Regular visitor can see recent blog posts, paginate to history and check blog posts detail.

  Background:
    Given an instance exists
    And a blog instance exists for this instance

  Scenario: Blog admin can manage blog instance
    Given I am logged in as blog admin for this blog instance
    Then I can manage blog posts
    And I can manage tags for posts
    And I can manage settings for a blog

  Scenario: Visitor can click through blog
    Given I am at blog mainpage
    Then I can visit post page
    And I can go to another post page

  Scenario: Blog admin can promote user blog post
    Given I am logged in as blog admin for this blog instance
    And user blogging is enabled for this instance
    And we have some user blog posts
    Then I can promote one user blog post
    Then a visitor should see promoted blog post in main blog
