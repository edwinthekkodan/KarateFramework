function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);

  if (!env) {
    env = 'dev';
  }

  var config = {
    env: env,
    baseUrl: 'https://jsonplaceholder.typicode.com'
  };

  if (env == 'dev') {
    config.baseUrl = 'https://jsonplaceholder.typicode.com';
  } else if (env == 'staging') {
    config.baseUrl = 'https://staging-api.example.com';
  } else if (env == 'prod') {
    config.baseUrl = 'https://api.example.com';
  }

  // ============================================================
  // DATABASE CONFIGURATION
  // Update these values to match your test database connection.
  // ============================================================
  var dbConfig = {
    // --- MySQL example ---
    url: 'jdbc:mysql://localhost:3306/testdb',
    username: 'root',
    password: 'root',
    driverClassName: 'com.mysql.cj.jdbc.Driver'

    // --- PostgreSQL example (uncomment to use) ---
    // url: 'jdbc:postgresql://localhost:5432/testdb',
    // username: 'postgres',
    // password: 'postgres',
    // driverClassName: 'org.postgresql.Driver'
  };

  // Override DB config per environment
  if (env == 'staging') {
    dbConfig.url = 'jdbc:mysql://staging-db.example.com:3306/testdb';
    dbConfig.username = 'staging_user';
    dbConfig.password = 'staging_pass';
  } else if (env == 'prod') {
    dbConfig.url = 'jdbc:mysql://prod-db.example.com:3306/testdb';
    dbConfig.username = 'prod_user';
    dbConfig.password = 'prod_pass';
  }

  // Initialize DbUtils — available as 'db' in all feature files
  // Wrapped in try-catch so API-only tests work without a database
  try {
    var DbUtils = Java.type('utils.DbUtils');
    config.db = new DbUtils(dbConfig);
    karate.log('Database connection initialized successfully');
  } catch (e) {
    karate.log('WARNING: Database not available - DB tests will be skipped. Error:', e.message);
    config.db = null;
  }

  // common headers
  karate.configure('headers', { 'Content-Type': 'application/json' });

  // connection and read timeout
  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', 30000);

  return config;
}
