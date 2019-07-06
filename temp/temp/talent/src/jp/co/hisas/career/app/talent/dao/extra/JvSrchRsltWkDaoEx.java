package jp.co.hisas.career.app.talent.dao.extra;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.dto.extra.JvSrchRsltWkDtoEx;
import jp.co.hisas.career.framework.exception.CareerSQLException;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.dao.useful.CoreDao;
import jp.co.hisas.career.util.log.Log;

public class JvSrchRsltWkDaoEx extends CoreDao {
	
	public JvSrchRsltWkDaoEx(String loginNo) {
		super( loginNo );
	}
	
	public static final String ALLCOLS = ""
            + " TGT_CMPA_CD as tgtCmpaCd,"
            + " TGT_STF_NO as tgtStfNo,"
            + " WK_IDX as wkIdx,"
            + " STARRED_FLG as starredFlg"
            ;
	
	public List<JvSrchRsltWkDtoEx> selectDynamic( PreparedStatement pstmt ) {
		
		Log.sql( "【DaoMethod Call】 JvSrchRsltWkDao.selectDynamic" );
		ResultSet rs = null;
		try {
			rs = pstmt.executeQuery();
			List<JvSrchRsltWkDtoEx> lst = new ArrayList<JvSrchRsltWkDtoEx>();
			while (rs.next()) {
				lst.add( transferRsToDto( rs ) );
			}
			return lst;
		} catch (final SQLException e) {
			Log.error( loginNo, e );
			throw new CareerSQLException( e );
		} finally {
			PZZ040_SQLUtility.closeConnection( loginNo, null, pstmt, rs );
		}
	}
	
	public List<JvSrchRsltWkDtoEx> selectDynamic( String sql ) {
		
		Log.sql( "【DaoMethod Call】 JvSrchRsltWkDao.selectDynamic" );
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement( sql );
			return selectDynamic( pstmt );
		} catch (final SQLException e) {
			Log.error( loginNo, e );
			throw new CareerSQLException( e );
		} finally {
			PZZ040_SQLUtility.closeConnection( loginNo, null, pstmt, null );
		}
		
	}
	
	public void executeDynamic( PreparedStatement pstmt ) {
		try {
			Log.sql( "【DaoMethod Call】 JvSrchRsltWkDao.executeDynamic" );
			pstmt.executeUpdate();
		} catch (final SQLException e) {
			Log.error( loginNo, e );
			throw new CareerSQLException( e );
		} finally {
			PZZ040_SQLUtility.closeConnection( loginNo, null, pstmt, null );
		}
	}
	
	public void executeDynamic( String sql ) {
		
		Log.sql( "【DaoMethod Call】 JvSrchRsltWkDao.executeDynamic" );
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement( sql );
			executeDynamic( pstmt );
		} catch (final SQLException e) {
			Log.error( loginNo, e );
			throw new CareerSQLException( e );
		} finally {
			PZZ040_SQLUtility.closeConnection( loginNo, null, pstmt, null );
		}
	}
	
	private JvSrchRsltWkDtoEx transferRsToDto( ResultSet rs ) throws SQLException {
		
		JvSrchRsltWkDtoEx dto = new JvSrchRsltWkDtoEx();
		dto.setTgtCmpaCd( DaoUtil.convertNullToString( rs.getString( "tgtCmpaCd" ) ) );
		dto.setTgtStfNo( DaoUtil.convertNullToString( rs.getString( "tgtStfNo" ) ) );
		dto.setWkIdx( rs.getInt( "wkIdx" ) );
		dto.setStarredFlg( rs.getInt( "starredFlg" ) );
		return dto;
	}
	
}
