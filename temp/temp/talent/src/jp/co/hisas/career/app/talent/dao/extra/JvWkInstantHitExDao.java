package jp.co.hisas.career.app.talent.dao.extra;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.dto.extra.JvWkInstantHitExDto;
import jp.co.hisas.career.framework.exception.CareerSQLException;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.dao.useful.CoreDao;
import jp.co.hisas.career.util.log.Log;

public class JvWkInstantHitExDao extends CoreDao {
	
	public JvWkInstantHitExDao(String loginNo) {
		super( loginNo );
	}
	
	public static final String ALLCOLS = ""
            + " QUERY_SEQ as querySeq,"
            + " QUERY as query,"
            + " TGT_EID as tgtEid,"
            + " PZ_ID as pzId,"
            + " PZ_NAME as pzName,"
            + " PZ_VAL as pzVal"
            ;
	
	public List<JvWkInstantHitExDto> selectDynamic( PreparedStatement pstmt ) {
		
		Log.sql( "【DaoMethod Call】 OneColumnDao.selectDynamic" );
		ResultSet rs = null;
		try {
			rs = pstmt.executeQuery();
			List<JvWkInstantHitExDto> lst = new ArrayList<JvWkInstantHitExDto>();
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
	
	public List<JvWkInstantHitExDto> selectDynamic( String sql ) {
		
		Log.sql( "【DaoMethod Call】 OneColumnDao.selectDynamic" );
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
	
	private JvWkInstantHitExDto transferRsToDto( ResultSet rs ) throws SQLException {
		
		JvWkInstantHitExDto dto = new JvWkInstantHitExDto();
		dto.setQuerySeq( rs.getInt( "querySeq" ) );
		dto.setQuery( DaoUtil.convertNullToString( rs.getString( "query" ) ) );
		dto.setEid( DaoUtil.convertNullToString( rs.getString( "tgtEid" ) ) );
		dto.setPzId( DaoUtil.convertNullToString( rs.getString( "pzId" ) ) );
		dto.setPzName( DaoUtil.convertNullToString( rs.getString( "pzName" ) ) );
		dto.setPzVal( DaoUtil.convertNullToString( rs.getString( "pzVal" ) ) );
		return dto;
	}
	
}
