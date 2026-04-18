Feature: Get Users API Tests

  Background:
    * url baseUrl

  Scenario: Get all users
    Given path '/users'
    When method get
    Then status 200
    And match response == '#[10]'
    And match each response contains { id: '#number', name: '#string', email: '#string' }

  Scenario: Get user by ID
    Given path '/users/1'
    When method get
    Then status 200
    And match response.id == 1
    And match response.name == '#string'
    And match response.email == '#string'
    And match response.address == '#object'

  Scenario: Get user with invalid ID returns 404
    Given path '/users/99999'
    When method get
    Then status 404
