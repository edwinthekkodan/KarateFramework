Feature: Database CRUD Operations

  Background:
    # 'db' is already initialized in karate-config.js via DbUtils

  Scenario: Read all users from the database
    * def result = db.readRows('SELECT * FROM users')
    * print 'Users from DB:', result
    * match each result contains { id: '#number', name: '#string', email: '#string' }

  Scenario: Read a single user by ID
    * def user = db.readRow("SELECT * FROM users WHERE id = 1")
    * print 'User:', user
    * match user.id == 1
    * match user.name == '#string'
    * match user.email == '#string'

  Scenario: Get total count of users
    * def count = db.readValue('SELECT COUNT(*) FROM users')
    * print 'Total users:', count
    * match count == '#number'

  Scenario: Read users with parameterized query
    * def params = [1]
    * def result = db.readRowsWithParams('SELECT * FROM users WHERE id = ?', params)
    * print 'Parameterized result:', result
    * match result == '#[1]'
    * match result[0].id == 1

  Scenario: Insert a new user
    * def insertCount = db.execute("INSERT INTO users (name, email, created_at) VALUES ('Test User', 'testuser@example.com', NOW())")
    * match insertCount == 1
    # Verify the insert
    * def user = db.readRow("SELECT * FROM users WHERE email = 'testuser@example.com'")
    * match user.name == 'Test User'
    * match user.email == 'testuser@example.com'

  Scenario: Insert a user with parameterized query
    * def params = ['Param User', 'paramuser@example.com']
    * def insertCount = db.executeWithParams("INSERT INTO users (name, email, created_at) VALUES (?, ?, NOW())", params)
    * match insertCount == 1
    * def user = db.readRow("SELECT * FROM users WHERE email = 'paramuser@example.com'")
    * match user.name == 'Param User'

  Scenario: Update a user
    * def updateCount = db.execute("UPDATE users SET name = 'Updated Name' WHERE email = 'testuser@example.com'")
    * match updateCount == 1
    * def user = db.readRow("SELECT * FROM users WHERE email = 'testuser@example.com'")
    * match user.name == 'Updated Name'

  Scenario: Delete test users (cleanup)
    * def deleteCount = db.execute("DELETE FROM users WHERE email IN ('testuser@example.com', 'paramuser@example.com')")
    * print 'Deleted rows:', deleteCount
    * match deleteCount == '#number'
