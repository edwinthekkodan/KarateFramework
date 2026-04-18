# Karate API Test Framework

A robust API testing framework built with [Karate](https://github.com/karatelabs/karate) — an open-source tool that combines API test-automation, mocking, performance testing, and UI automation into a single, unified framework.

## Project Structure

```
src/
├── test/
│   ├── java/
│   │   ├── karate-config.js              # Global config (base URL, DB config, headers, timeouts)
│   │   ├── logback-test.xml              # Logging configuration
│   │   ├── examples/
│   │   │   ├── users/
│   │   │   │   ├── UsersRunner.java      # Runner for user API tests
│   │   │   │   ├── getUsers.feature      # GET /users tests
│   │   │   │   ├── createUser.feature    # POST /users tests
│   │   │   │   └── updateDeleteUser.feature  # PUT/PATCH/DELETE tests
│   │   │   ├── posts/
│   │   │   │   ├── PostsRunner.java      # Runner for post API tests
│   │   │   │   └── getPosts.feature      # GET /posts & /posts/{id} tests
│   │   │   └── db/
│   │   │       ├── DbRunner.java         # Runner for database tests
│   │   │       ├── dbOperations.feature  # Database CRUD operation tests
│   │   │       └── apiDbValidation.feature   # API ↔ Database validation tests
│   │   ├── utils/
│   │   │   └── DbUtils.java             # Database utility class (JDBC helper)
│   │   └── JavaCoding/
│   │       ├── FibonacciSeries.java      # Fibonacci series generator
│   │       ├── NumberOfCharacters.java   # Character count utility
│   │       ├── PallindromeString.java    # Palindrome checker
│   │       └── TestCode.java            # String reversal utility
│   └── resources/
│       └── db/
│           └── setup.sql                 # Database schema & seed data script
```

## Prerequisites

- **Java 11+** (JDK)
- **Maven 3.6+**
- **MySQL 8+** or **PostgreSQL** (required only for database tests)

## Running Tests

### Run all tests in parallel
```bash
mvn test
```

### Run a specific runner
```bash
mvn test -Dtest=UsersRunner
mvn test -Dtest=PostsRunner
mvn test -Dtest=DbRunner
```

### Run with a specific environment
```bash
mvn test -Dkarate.env=staging
```

## Database Testing

### Setup

1. Install MySQL or PostgreSQL and create the test database:
   ```bash
   mysql -u root -p < src/test/resources/db/setup.sql
   ```

2. Update the database connection details in `karate-config.js`:
   ```javascript
   var dbConfig = {
       url: 'jdbc:mysql://localhost:3306/testdb',
       username: 'root',
       password: 'root',
       driverClassName: 'com.mysql.cj.jdbc.Driver'
   };
   ```

### DbUtils API

The `DbUtils` class (`utils/DbUtils.java`) is initialized in `karate-config.js` and available as `db` in all feature files:

| Method | Description | Example |
|---|---|---|
| `db.readRows(query)` | Returns all rows as a list of maps | `db.readRows('SELECT * FROM users')` |
| `db.readRow(query)` | Returns the first row as a map | `db.readRow('SELECT * FROM users WHERE id = 1')` |
| `db.readValue(query)` | Returns first column of first row | `db.readValue('SELECT COUNT(*) FROM users')` |
| `db.readRowsWithParams(query, params)` | Parameterized SELECT | `db.readRowsWithParams('SELECT * FROM users WHERE id = ?', [1])` |
| `db.execute(sql)` | Execute INSERT/UPDATE/DELETE | `db.execute("DELETE FROM users WHERE id = 1")` |
| `db.executeWithParams(sql, params)` | Parameterized INSERT/UPDATE/DELETE | `db.executeWithParams("INSERT INTO users (name) VALUES (?)", ['John'])` |
| `db.executeBatch(sqlList)` | Execute a batch of statements | `db.executeBatch(["DELETE FROM orders", "DELETE FROM users"])` |

> **Note:** If no database is available, API-only tests will still run — the DB connection failure is caught gracefully in `karate-config.js`.

## Reports

After test execution, reports are generated at:
- **Karate HTML Report**: `target/karate-reports/karate-summary.html`
- **Cucumber HTML Report**: `target/cucumber-html-reports/overview-features.html`

## Environments

Configured in `karate-config.js`:

| Environment | Base URL | DB Host |
|---|---|---|
| `dev` (default) | `https://jsonplaceholder.typicode.com` | `localhost` |
| `staging` | `https://staging-api.example.com` | `staging-db.example.com` |
| `prod` | `https://api.example.com` | `prod-db.example.com` |

## Tech Stack

| Component | Version |
|---|---|
| Karate | 1.4.1 |
| JUnit 5 | (via karate-junit5) |
| MySQL Connector/J | 8.3.0 |
| PostgreSQL Driver | 42.7.2 |
| Cucumber Reporting | 5.8.0 |
| Maven Surefire | 3.2.5 |
