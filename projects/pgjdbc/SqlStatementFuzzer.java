import com.code_intelligence.jazzer.api.FuzzedDataProvider;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import org.postgresql.jdbc.PgConnection;

public class SqlStatementFuzzer extends TestServer {

	SqlStatementFuzzer() {
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

	public static void fuzzerTestOneInput(FuzzedDataProvider fuzzedDataPovider) {
		SqlStatementFuzzer closure = new SqlStatementFuzzer();
		try {
			closure.createTestTable();
		} catch (SQLException ex) {
			/* documented, ignore */
		}
	}
}