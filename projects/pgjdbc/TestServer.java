import com.code_intelligence.jazzer.api.FuzzedDataProvider;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class TestServer {

	TestServer() {
	}

	/*
	 * this code causes the JVM to explode
	 */
	void createTestTable() throws SQLException {
		try (Connection connection = getConnection()) {
			Statement statement = connection.createStatement();
		
			statement.execute("DROP TABLE TestTable IF EXISTS");
			statement.execute("CREATE TABLE TestTable (key INTEGER, value VARCHAR(256))");
			statement.execute("INSERT INTO TestTable VALUES ((0, \"Hello\"),(1, \"World\"))");
		}
	}

	String getUserName() {
		return "test";
	}

	String getPassword() {
		return "test";
	}

	Connection getConnection(String connectionOptions) throws SQLException {
		return DriverManager.getConnection("jdbc:postgresql://localhost/?" + connectionOptions, getUserName(), getPassword());
	}

	Connection getConnection() throws SQLException {
		return getConnection("");
	}
}