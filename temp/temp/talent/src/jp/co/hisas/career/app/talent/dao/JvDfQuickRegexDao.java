/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jp.co.hisas.career.app.talent.dto.JvDfQuickRegexDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvDfQuickRegexDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " REGEX_PTN as regexPtn,"
                     + " PZ_ID as pzId,"
                     + " OPERATOR as operator,"
                     + " PRIORITY as priority,"
                     + " OVER_FLG as overFlg"
                     ;

    public JvDfQuickRegexDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvDfQuickRegexDao(Connection conn) {
        this.conn = conn;
        this.isConnectionGiven = true;
    }

    private Connection getConnection() {
        Connection connection =
                isConnectionGiven ? this.conn : PZZ040_SQLUtility.getCachedConnection();
        if ( connection == null ) {
            throw new CareerRuntimeException();
        }
        return connection;
    }

    public JvDfQuickRegexDto select() {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_DF_QUICK_REGEX"
                         + " WHERE "
                         ;
        Log.sql("[DaoMethod Call] JvDfQuickRegexDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            JvDfQuickRegexDto dto = null;
            if ( rs.next() ) {
                dto = transferRsToDto(rs);
            }
            return dto;
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, rs);
        }
    }

    public List<JvDfQuickRegexDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvDfQuickRegexDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvDfQuickRegexDto> lst = new ArrayList<JvDfQuickRegexDto>();
            while ( rs.next() ) {
               lst.add(transferRsToDto(rs));
            }
            return lst;
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, rs);
        }
    }

    public List<JvDfQuickRegexDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvDfQuickRegexDao.selectDynamic");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            return selectDynamic(pstmt);
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }

     }

    private JvDfQuickRegexDto transferRsToDto(ResultSet rs) throws SQLException {

        JvDfQuickRegexDto dto = new JvDfQuickRegexDto();
        dto.setRegexPtn(DaoUtil.convertNullToString(rs.getString("regexPtn")));
        dto.setPzId(DaoUtil.convertNullToString(rs.getString("pzId")));
        dto.setOperator(DaoUtil.convertNullToString(rs.getString("operator")));
        dto.setPriority(rs.getInt("priority"));
        dto.setOverFlg(rs.getInt("overFlg"));
        return dto;
    }

}

