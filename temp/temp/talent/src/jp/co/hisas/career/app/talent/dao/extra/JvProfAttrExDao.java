package jp.co.hisas.career.app.talent.dao.extra;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.dto.extra.JvProfAttrExDto;
import jp.co.hisas.career.framework.exception.CareerSQLException;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.dao.useful.CoreDao;
import jp.co.hisas.career.util.log.Log;

public class JvProfAttrExDao extends CoreDao {
	
	public JvProfAttrExDao(String loginNo) {
		super( loginNo );
	}
	
	public static final String ALLCOLS = ""
            + " EMP_ID as empId,"
            + " ATTR_ID as attrId,"
            + " ATTR_VAL as attrVal"
            ;
	
	public List<JvProfAttrExDto> selectDynamic( PreparedStatement pstmt ) {
		
		Log.sql( "【DaoMethod Call】 JvProfAttrExDao.selectDynamic" );
		ResultSet rs = null;
		try {
			rs = pstmt.executeQuery();
			List<JvProfAttrExDto> lst = new ArrayList<JvProfAttrExDto>();
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
	
	public List<JvProfAttrExDto> selectDynamic( String sql ) {
		
		Log.sql( "【DaoMethod Call】 JvProfAttrExDao.selectDynamic" );
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
			Log.sql( "【DaoMethod Call】 JvProfAttrExDao.executeDynamic" );
			pstmt.executeUpdate();
		} catch (final SQLException e) {
			Log.error( loginNo, e );
			throw new CareerSQLException( e );
		} finally {
			PZZ040_SQLUtility.closeConnection( loginNo, null, pstmt, null );
		}
	}
	
	public void executeDynamic( String sql ) {
		
		Log.sql( "【DaoMethod Call】 JvProfAttrExDao.executeDynamic" );
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
	
	private JvProfAttrExDto transferRsToDto( ResultSet rs ) throws SQLException {
		
		JvProfAttrExDto dto = new JvProfAttrExDto();
		dto.setEmpId( DaoUtil.convertNullToString( rs.getString( "empId" ) ) );
		dto.setAttrId( DaoUtil.convertNullToString( rs.getString( "attrId" ) ) );
		dto.setAttrVal( DaoUtil.convertNullToString( rs.getString( "attrVal" ) ) );
		return dto;
	}
	
}
