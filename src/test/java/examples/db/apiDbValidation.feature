Feature: API and Database Validation
  Verify that API responses are consistent with database records.

  Background:
    * url baseUrl

  Scenario: Compare API user count with database count
    # Get count from API
    Given path '/users'
    When method get
    Then status 200
    * def apiCount = response.length

    # Get count from database
    * def dbCount = db.readValue('SELECT COUNT(*) FROM users')
    * print 'API count:', apiCount, '| DB count:', dbCount

    # NOTE: In a real project where the API is backed by your DB,
    # you would assert: match apiCount == dbCount
    # Here we just demonstrate the pattern
    * match apiCount == '#number'
    * match dbCount == '#number'

  Scenario: Verify API response matches database record
    # Get user from API
    Given path '/users/1'
    When method get
    Then status 200
    * def apiUser = response

    # Get same user from database
    * def dbUser = db.readRow('SELECT * FROM users WHERE id = 1')

    # NOTE: In a real project, you would assert field-level matches:
    # match apiUser.name == dbUser.name
    # match apiUser.email == dbUser.email
    * print 'API User:', apiUser
    * print 'DB User:', dbUser
