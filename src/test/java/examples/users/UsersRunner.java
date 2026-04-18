package examples.users;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class UsersRunner {

    @Test
    void testUsers() {
        Results results = Runner.path("classpath:examples/users")
                .outputCucumberJson(true)
                .reportDir("target/surefire-reports")
                .parallel(5);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
