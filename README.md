# Karate API Test Framework

A robust API testing framework built with [Karate](https://github.com/karatelabs/karate) — an open-source tool that combines API test-automation, mocking, performance testing, and UI automation into a single, unified framework.

## Project Structure

```
src/test/java/
├── karate-config.js          # Global config (base URL, headers, timeouts)
├── logback-test.xml           # Logging configuration
├── examples/
│   ├── TestRunner.java        # Parallel test runner with HTML reports
│   ├── users/
│   │   ├── UsersRunner.java   # Runner for user tests
│   │   ├── getUsers.feature   # GET /users tests
│   │   ├── createUser.feature # POST /users tests
│   │   └── updateDeleteUser.feature # PUT/PATCH/DELETE tests
│   └── posts/
│       ├── PostsRunner.java   # Runner for post tests
│       └── getPosts.feature   # GET /posts tests
```

## Prerequisites

- **Java 11+** (JDK)
- **Maven 3.6+**

## Running Tests

### Run all tests in parallel
```bash
mvn test
```

### Run a specific feature/runner
```bash
mvn test -Dtest=UsersRunner
mvn test -Dtest=PostsRunner
```

### Run with a specific environment
```bash
mvn test -Dkarate.env=staging
```

## Reports

After test execution, reports are generated at:
- **Karate HTML Report**: `target/karate-reports/karate-summary.html`
- **Cucumber HTML Report**: `target/cucumber-html-reports/overview-features.html`

## Environments

Configured in `karate-config.js`:

| Environment | Base URL |
|---|---|
| `dev` (default) | `https://jsonplaceholder.typicode.com` |
| `staging` | `https://staging-api.example.com` |
| `prod` | `https://api.example.com` |
