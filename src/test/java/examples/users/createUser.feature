Feature: Create User API Tests

  Background:
    * url baseUrl
    * def newUser =
      """
      {
        "name": "John Doe",
        "username": "johndoe",
        "email": "johndoe@example.com",
        "phone": "1-234-567-8901",
        "website": "johndoe.com",
        "company": {
          "name": "Doe Industries",
          "catchPhrase": "Quality first",
          "bs": "leverage agile frameworks"
        }
      }
      """

  @runnerTest
  Scenario: Create a new user
    Given path '/users'
    And request newUser
    When method post
    Then status 201
    And match response contains { name: 'John Doe', username: 'johndoe', email: 'johndoe@example.com' }
    And match response.id == '#number'

  Scenario: Create user with minimal data
    Given path '/users'
    And request { name: 'Jane Doe', email: 'jane@example.com' }
    When method post
    Then status 201
    And match response.id == '#number'
    And match response.name == 'Jane Doe'
