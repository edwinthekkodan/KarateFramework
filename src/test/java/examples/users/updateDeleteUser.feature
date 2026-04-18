Feature: Update and Delete User API Tests

  Background:
    * url baseUrl

  @mainScenario
  Scenario: Update a user with PUT
    Given path '/users/1'
    And request { name: 'Updated Name', email: 'updated@example.com' }
    When method put
    Then status 200
    And match response.name == 'Updated Name'

  Scenario: Partially update a user with PATCH
    Given path '/users/1'
    And request { name: 'Patched Name' }
    When method patch
    Then status 200
    And match response.name == 'Patched Name'

  @deleteTest
  Scenario: Delete a user
    Given path '/users/1'
    When method delete
    Then status 200
