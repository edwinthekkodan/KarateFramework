package utils;

import java.sql.*;
import java.util.*;

/**
 * Database utility class for Karate tests.
 * Called from feature files via Java interop to perform CRUD operations on a
 * test database.
 *
 * Usage in karate-config.js:
 * var DbUtils = Java.type('utils.DbUtils');
 * config.db = new DbUtils(dbConfig);
 *
 * Usage in .feature files:
 * * def result = db.readRows('SELECT * FROM users')
 * * def count = db.readValue('SELECT count(*) FROM users')
 */
public class DbUtils {

    private final String url;
    private final String username;
    private final String password;
    private final String driver;

    /**
     * Construct with a Map typically passed from karate-config.js.
     * Expected keys: url, username, password, driverClassName
     */
    public DbUtils(Map<String, Object> config) {
        this.url = (String) config.get("url");
        this.username = (String) config.get("username");
        this.password = (String) config.get("password");
        this.driver = (String) config.get("driverClassName");
        try {
            Class.forName(this.driver);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("JDBC driver not found: " + this.driver, e);
        }
    }

    /**
     * Get a fresh JDBC connection.
     */
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

    /**
     * Execute a SELECT query and return all rows as a List of Maps.
     * Each Map represents one row with column-name keys.
     *
     * Example: def rows = db.readRows('SELECT id, name FROM users')
     * match rows[0].name == 'John'
     */
    public List<Map<String, Object>> readRows(String query) {
        List<Map<String, Object>> rows = new ArrayList<>();
        try (Connection conn = getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            ResultSetMetaData meta = rs.getMetaData();
            int columnCount = meta.getColumnCount();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (int i = 1; i <= columnCount; i++) {
                    row.put(meta.getColumnLabel(i), rs.getObject(i));
                }
                rows.add(row);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Query failed: " + query, e);
        }
        return rows;
    }

    /**
     * Execute a SELECT query with parameters and return all rows.
     *
     * Example: def rows = db.readRowsWithParams('SELECT * FROM users WHERE id = ?',
     * [1])
     */
    public List<Map<String, Object>> readRowsWithParams(String query, List<Object> params) {
        List<Map<String, Object>> rows = new ArrayList<>();
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(query)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData meta = rs.getMetaData();
                int columnCount = meta.getColumnCount();
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    for (int i = 1; i <= columnCount; i++) {
                        row.put(meta.getColumnLabel(i), rs.getObject(i));
                    }
                    rows.add(row);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Parameterized query failed: " + query, e);
        }
        return rows;
    }

    /**
     * Execute a SELECT and return the first column of the first row.
     * Useful for counts, single lookups, etc.
     *
     * Example: def count = db.readValue('SELECT count(*) FROM users')
     */
    public Object readValue(String query) {
        try (Connection conn = getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                return rs.getObject(1);
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException("Query failed: " + query, e);
        }
    }

    /**
     * Execute a SELECT and return only the first row as a Map.
     *
     * Example: def user = db.readRow('SELECT * FROM users WHERE id = 1')
     * match user.name == 'John'
     */
    public Map<String, Object> readRow(String query) {
        List<Map<String, Object>> rows = readRows(query);
        return rows.isEmpty() ? null : rows.get(0);
    }

    /**
     * Execute an INSERT, UPDATE, or DELETE statement.
     * Returns the number of affected rows.
     *
     * Example: def count = db.execute("INSERT INTO users (name, email) VALUES
     * ('John', 'john@test.com')")
     */
    public int execute(String sql) {
        try (Connection conn = getConnection();
                Statement stmt = conn.createStatement()) {
            return stmt.executeUpdate(sql);
        } catch (SQLException e) {
            throw new RuntimeException("SQL execution failed: " + sql, e);
        }
    }

    /**
     * Execute a parameterized INSERT, UPDATE, or DELETE statement.
     * Returns the number of affected rows.
     *
     * Example: def count = db.executeWithParams("INSERT INTO users (name, email)
     * VALUES (?, ?)", ['John', 'john@test.com'])
     */
    public int executeWithParams(String sql, List<Object> params) {
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Parameterized SQL execution failed: " + sql, e);
        }
    }

    /**
     * Execute a batch of SQL statements (e.g. for setup/teardown).
     *
     * Example: db.executeBatch(["DELETE FROM orders", "DELETE FROM users"])
     */
    public void executeBatch(List<String> sqlStatements) {
        try (Connection conn = getConnection();
                Statement stmt = conn.createStatement()) {
            for (String sql : sqlStatements) {
                stmt.addBatch(sql);
            }
            stmt.executeBatch();
        } catch (SQLException e) {
            throw new RuntimeException("Batch execution failed", e);
        }
    }
}
