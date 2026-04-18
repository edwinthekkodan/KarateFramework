Feature: Get Posts API Tests

  Background:
    * url baseUrl

  Scenario: Get all posts
    Given path '/posts'
    When method get
    Then status 200
    And match response == '#[100]'
    And match each response contains { userId: '#number', id: '#number', title: '#string', body: '#string' }

  @mainScenario
  Scenario: Get post by ID
    Given path '/posts/1'
    When method get
    Then status 200
    And match response.userId == 1
    And match response.id == 1
    And match response.title == '#string'

  Scenario: Get posts by userId (query parameter)
    Given path '/posts'
    And param userId = 1
    When method get
    Then status 200
    And match each response contains { userId: 1 }

  Scenario: Get comments for a post
    Given path '/posts/1/comments'
    When method get
    Then status 200
    And match response == '#[5]'
    And match each response contains { postId: 1, email: '#string', body: '#string' }
