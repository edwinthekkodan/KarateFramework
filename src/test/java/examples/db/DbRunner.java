package examples.db;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class DbRunner {

    @Test
    void testDbOperations() {
        Results results = Runner.path("classpath:examples/db")
                .outputCucumberJson(true)
                .reportDir("target/surefire-reports")
                .parallel(5);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
