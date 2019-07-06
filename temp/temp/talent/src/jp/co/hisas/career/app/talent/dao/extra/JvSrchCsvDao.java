package jp.co.hisas.career.app.talent.dao.extra;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.dto.extra.JvSrchCsvDto;
import jp.co.hisas.career.framework.exception.CareerSQLException;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.dao.useful.CoreDao;
import jp.co.hisas.career.util.log.Log;

public class JvSrchCsvDao extends CoreDao {
	
	public JvSrchCsvDao(String loginNo) {
		super( loginNo );
	}
	
	public static final String ALLCOLS = ""
            + " CMPA_CD as cmpaCd,"
            + " STF_NO as stfNo,"
            + " SORT as sort,"
            + " ITEM_01 as item01,"
            + " ITEM_02 as item02,"
            + " ITEM_03 as item03,"
            + " ITEM_04 as item04,"
            + " ITEM_05 as item05,"
            + " ITEM_06 as item06,"
            + " ITEM_07 as item07,"
            + " ITEM_08 as item08,"
            + " ITEM_09 as item09,"
            + " ITEM_10 as item10,"
            + " ITEM_11 as item11,"
            + " ITEM_12 as item12,"
            + " ITEM_13 as item13,"
            + " ITEM_14 as item14,"
            + " ITEM_15 as item15,"
            + " ITEM_16 as item16,"
            + " ITEM_17 as item17,"
            + " ITEM_18 as item18,"
            + " ITEM_19 as item19,"
            + " ITEM_20 as item20,"
            + " ITEM_21 as item21,"
            + " ITEM_22 as item22,"
            + " ITEM_23 as item23,"
            + " ITEM_24 as item24,"
            + " ITEM_25 as item25,"
            + " ITEM_26 as item26,"
            + " ITEM_27 as item27,"
            + " ITEM_28 as item28,"
            + " ITEM_29 as item29,"
            + " ITEM_30 as item30,"
            + " ITEM_31 as item31,"
            + " ITEM_32 as item32,"
            + " ITEM_33 as item33,"
            + " ITEM_34 as item34,"
            + " ITEM_35 as item35,"
            + " ITEM_36 as item36,"
            + " ITEM_37 as item37,"
            + " ITEM_38 as item38,"
            + " ITEM_39 as item39,"
            + " ITEM_40 as item40,"
            + " ITEM_41 as item41,"
            + " ITEM_42 as item42,"
            + " ITEM_43 as item43,"
            + " ITEM_44 as item44,"
            + " ITEM_45 as item45,"
            + " ITEM_46 as item46,"
            + " ITEM_47 as item47,"
            + " ITEM_48 as item48,"
            + " ITEM_49 as item49,"
            + " ITEM_50 as item50,"
            + " ITEM_51 as item51,"
            + " ITEM_52 as item52,"
            + " ITEM_53 as item53,"
            + " ITEM_54 as item54,"
            + " ITEM_55 as item55,"
            + " ITEM_56 as item56,"
            + " ITEM_57 as item57,"
            + " ITEM_58 as item58,"
            + " ITEM_59 as item59,"
            + " ITEM_60 as item60"
            ;
	
	/**
	 * 動的SELECT文を実行する。
	 * 
	 * @param pstmt PreparedStatement
	 * @return List<JvSrchCsvDto> JvSrchCsvDto型データのリスト。
	 */
	public List<JvSrchCsvDto> selectDynamic( PreparedStatement pstmt ) {
		
		Log.sql( "【DaoMethod Call】 OneColumnDao.selectDynamic" );
		ResultSet rs = null;
		try {
			rs = pstmt.executeQuery();
			List<JvSrchCsvDto> lst = new ArrayList<JvSrchCsvDto>();
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
	
	/**
	 * 動的SELECT文を実行する。
	 * 
	 * @param sql SQL文
	 * @return List<JvSrchCsvDto> JvSrchCsvDto型データのリスト。
	 */
	public List<JvSrchCsvDto> selectDynamic( String sql ) {
		
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
	
	/**
	 * ResultSetからData Transfer Objectへのデータ転送。
	 * 
	 * @param rs ResultSet カーソル位置はこのメソッドでは変更しません。
	 * @return Data Transfer Object
	 * @throws SQLException
	 */
	private JvSrchCsvDto transferRsToDto( ResultSet rs ) throws SQLException {
		
		JvSrchCsvDto dto = new JvSrchCsvDto();
		dto.setCmpaCd( DaoUtil.convertNullToString( rs.getString( "cmpaCd" ) ) );
		dto.setStfNo( DaoUtil.convertNullToString( rs.getString( "stfNo" ) ) );
		dto.setSort( DaoUtil.convertNullToString( rs.getString( "sort" ) ) );
		dto.setItem01( DaoUtil.convertNullToString( rs.getString( "item01" ) ) );
		dto.setItem02( DaoUtil.convertNullToString( rs.getString( "item02" ) ) );
		dto.setItem03( DaoUtil.convertNullToString( rs.getString( "item03" ) ) );
		dto.setItem04( DaoUtil.convertNullToString( rs.getString( "item04" ) ) );
		dto.setItem05( DaoUtil.convertNullToString( rs.getString( "item05" ) ) );
		dto.setItem06( DaoUtil.convertNullToString( rs.getString( "item06" ) ) );
		dto.setItem07( DaoUtil.convertNullToString( rs.getString( "item07" ) ) );
		dto.setItem08( DaoUtil.convertNullToString( rs.getString( "item08" ) ) );
		dto.setItem09( DaoUtil.convertNullToString( rs.getString( "item09" ) ) );
		dto.setItem10( DaoUtil.convertNullToString( rs.getString( "item10" ) ) );
		dto.setItem11( DaoUtil.convertNullToString( rs.getString( "item11" ) ) );
		dto.setItem12( DaoUtil.convertNullToString( rs.getString( "item12" ) ) );
		dto.setItem13( DaoUtil.convertNullToString( rs.getString( "item13" ) ) );
		dto.setItem14( DaoUtil.convertNullToString( rs.getString( "item14" ) ) );
		dto.setItem15( DaoUtil.convertNullToString( rs.getString( "item15" ) ) );
		dto.setItem16( DaoUtil.convertNullToString( rs.getString( "item16" ) ) );
		dto.setItem17( DaoUtil.convertNullToString( rs.getString( "item17" ) ) );
		dto.setItem18( DaoUtil.convertNullToString( rs.getString( "item18" ) ) );
		dto.setItem19( DaoUtil.convertNullToString( rs.getString( "item19" ) ) );
		dto.setItem20( DaoUtil.convertNullToString( rs.getString( "item20" ) ) );
		dto.setItem21( DaoUtil.convertNullToString( rs.getString( "item21" ) ) );
		dto.setItem22( DaoUtil.convertNullToString( rs.getString( "item22" ) ) );
		dto.setItem23( DaoUtil.convertNullToString( rs.getString( "item23" ) ) );
		dto.setItem24( DaoUtil.convertNullToString( rs.getString( "item24" ) ) );
		dto.setItem25( DaoUtil.convertNullToString( rs.getString( "item25" ) ) );
		dto.setItem26( DaoUtil.convertNullToString( rs.getString( "item26" ) ) );
		dto.setItem27( DaoUtil.convertNullToString( rs.getString( "item27" ) ) );
		dto.setItem28( DaoUtil.convertNullToString( rs.getString( "item28" ) ) );
		dto.setItem29( DaoUtil.convertNullToString( rs.getString( "item29" ) ) );
		dto.setItem30( DaoUtil.convertNullToString( rs.getString( "item30" ) ) );
		dto.setItem31( DaoUtil.convertNullToString( rs.getString( "item31" ) ) );
		dto.setItem32( DaoUtil.convertNullToString( rs.getString( "item32" ) ) );
		dto.setItem33( DaoUtil.convertNullToString( rs.getString( "item33" ) ) );
		dto.setItem34( DaoUtil.convertNullToString( rs.getString( "item34" ) ) );
		dto.setItem35( DaoUtil.convertNullToString( rs.getString( "item35" ) ) );
		dto.setItem36( DaoUtil.convertNullToString( rs.getString( "item36" ) ) );
		dto.setItem37( DaoUtil.convertNullToString( rs.getString( "item37" ) ) );
		dto.setItem38( DaoUtil.convertNullToString( rs.getString( "item38" ) ) );
		dto.setItem39( DaoUtil.convertNullToString( rs.getString( "item39" ) ) );
		dto.setItem40( DaoUtil.convertNullToString( rs.getString( "item40" ) ) );
		dto.setItem41( DaoUtil.convertNullToString( rs.getString( "item41" ) ) );
		dto.setItem42( DaoUtil.convertNullToString( rs.getString( "item42" ) ) );
		dto.setItem43( DaoUtil.convertNullToString( rs.getString( "item43" ) ) );
		dto.setItem44( DaoUtil.convertNullToString( rs.getString( "item44" ) ) );
		dto.setItem45( DaoUtil.convertNullToString( rs.getString( "item45" ) ) );
		dto.setItem46( DaoUtil.convertNullToString( rs.getString( "item46" ) ) );
		dto.setItem47( DaoUtil.convertNullToString( rs.getString( "item47" ) ) );
		dto.setItem48( DaoUtil.convertNullToString( rs.getString( "item48" ) ) );
		dto.setItem49( DaoUtil.convertNullToString( rs.getString( "item49" ) ) );
		dto.setItem50( DaoUtil.convertNullToString( rs.getString( "item50" ) ) );
		dto.setItem51( DaoUtil.convertNullToString( rs.getString( "item51" ) ) );
		dto.setItem52( DaoUtil.convertNullToString( rs.getString( "item52" ) ) );
		dto.setItem53( DaoUtil.convertNullToString( rs.getString( "item53" ) ) );
		dto.setItem54( DaoUtil.convertNullToString( rs.getString( "item54" ) ) );
		dto.setItem55( DaoUtil.convertNullToString( rs.getString( "item55" ) ) );
		dto.setItem56( DaoUtil.convertNullToString( rs.getString( "item56" ) ) );
		dto.setItem57( DaoUtil.convertNullToString( rs.getString( "item57" ) ) );
		dto.setItem58( DaoUtil.convertNullToString( rs.getString( "item58" ) ) );
		dto.setItem59( DaoUtil.convertNullToString( rs.getString( "item59" ) ) );
		dto.setItem60( DaoUtil.convertNullToString( rs.getString( "item60" ) ) );
		return dto;
	}
	
}
