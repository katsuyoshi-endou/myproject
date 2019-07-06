package jp.co.hisas.career.app.talent.dao.extra;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jp.co.hisas.career.framework.exception.CareerSQLException;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.dao.useful.CoreDao;
import jp.co.hisas.career.util.log.Log;

public class GeneralMapDao extends CoreDao {
	
	public GeneralMapDao(String loginNo) {
		super( loginNo );
	}
	
	public Map<String, String> selectByPK( String[] cols, PreparedStatement pstmt ) {
		Log.sql( "【DaoMethod Call】 GeneralMapDao.selectDynamic" );
		ResultSet rs = null;
		try {
			rs = pstmt.executeQuery();
			Map<String, String> pkRecord = null;
			while (rs.next()) {
				pkRecord = transferRsToMap( cols, cols, rs );
			}
			return pkRecord;
		} catch (final SQLException e) {
			Log.error( loginNo, e );
			throw new CareerSQLException( e );
		} finally {
			PZZ040_SQLUtility.closeConnection( loginNo, null, pstmt, rs );
		}
	}
	
	public List<Map<String, String>> select( String[] cols, PreparedStatement pstmt ) {
		return select( cols, cols, pstmt );
	}
	
	public List<Map<String, String>> select( String[] cols, String[] keys, PreparedStatement pstmt ) {
		Log.sql( "【DaoMethod Call】 GeneralMapDao.selectDynamic" );
		ResultSet rs = null;
		try {
			rs = pstmt.executeQuery();
			List<Map<String, String>> lst = new ArrayList<Map<String, String>>();
			while (rs.next()) {
				lst.add( transferRsToMap( cols, keys, rs ) );
			}
			return lst;
		} catch (final SQLException e) {
			Log.error( loginNo, e );
			throw new CareerSQLException( e );
		} finally {
			PZZ040_SQLUtility.closeConnection( loginNo, null, pstmt, rs );
		}
	}
	
	public void execute( PreparedStatement pstmt ) {
		try {
			Log.sql( "【DaoMethod Call】 GeneralMapDao.executeDynamic" );
			pstmt.executeUpdate();
		} catch (final SQLException e) {
			Log.error( loginNo, e );
			throw new CareerSQLException( e );
		} finally {
			PZZ040_SQLUtility.closeConnection( loginNo, null, pstmt, null );
		}
	}
	
	private Map<String, String> transferRsToMap( String[] cols, String[] keys, ResultSet rs ) throws SQLException {
		
		Map<String, String> resultMap = new HashMap<String, String>();
		
		for (int i = 0; i < cols.length; i++) {
			String colName = cols[i];
			String keyName = keys[i];
			resultMap.put( keyName, DaoUtil.convertNullToString( rs.getString( colName ) ) );
		}
		
		return resultMap;
	}
	
}
