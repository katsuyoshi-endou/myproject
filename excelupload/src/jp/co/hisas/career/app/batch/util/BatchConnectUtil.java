package jp.co.hisas.career.app.batch.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

public class BatchConnectUtil {

	public static Connection getConnetcion( String jdbcClass, String jdbcURL, String user, String password ) throws SQLException, Exception {

		try {
			Class.forName( jdbcClass );

			final Connection dbConnection = DriverManager.getConnection( jdbcURL, user, password );

			return dbConnection;
		} catch ( final SQLException e ) {
			throw e;
		} catch ( final Exception e ) {
			throw e;
		}
	}

	public static void closeConnection( final Connection conn, final Statement stmt, final ResultSet rs ) throws SQLException {
		try {
			if ( rs != null ) {
				rs.close();
			}

			if ( stmt != null ) {
				stmt.close();
			}

			if ( conn != null ) {
				conn.close();
			}
		} catch ( final Exception e ) {
			throw e;
		}
	}

	public static void closeConnection( final Connection conn, final Statement stmt ) throws SQLException {
		BatchConnectUtil.closeConnection( conn, stmt, null );
	}

	public static void closeconnection( final Connection conn ) throws SQLException {
		BatchConnectUtil.closeConnection( conn, null, null );
	}

	public static void rollbackConnection( final Connection conn ) throws SQLException {
		try {
			conn.rollback();
		} catch ( final SQLException e ) {
			throw e;
		}
	}

	public static void commitConnection( final Connection conn ) throws SQLException {
		try {
			conn.commit();
		} catch ( SQLException e ) {
			throw e;
		}
	}

	public static PreparedStatement getStatement( Connection conn, String sql, List<String> paramList ) throws SQLException {

		PreparedStatement stmt = null;

		try {
			stmt = conn.prepareStatement( sql );

			for ( int i = 0; i < paramList.size(); i++ ) {
				String param = paramList.get( i );
				if ( param == null ) {
					stmt.setNull(i + 1, 12 );
				} else {
					stmt.setString( i + 1, paramList.get( i ));
				}
			}
		} catch ( SQLException e ) {
			throw e;
		}
		return stmt;
	}
}
