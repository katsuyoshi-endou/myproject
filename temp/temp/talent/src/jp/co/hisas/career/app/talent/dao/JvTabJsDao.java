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
import jp.co.hisas.career.app.talent.dto.JvTabJsDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTabJsDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " TAB_ID as tabId,"
                     + " LINE_NO as lineNo,"
                     + " SCRIPT as script"
                     ;

    public JvTabJsDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTabJsDao(Connection conn) {
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

    public JvTabJsDto select(String tabId, String lineNo) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TAB_JS"
                         + " WHERE TAB_ID = ?"
                         + " AND LINE_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTabJsDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, tabId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, lineNo);
            rs = pstmt.executeQuery();
            JvTabJsDto dto = null;
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

    public List<JvTabJsDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTabJsDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTabJsDto> lst = new ArrayList<JvTabJsDto>();
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

    public List<JvTabJsDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTabJsDao.selectDynamic");
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

    private JvTabJsDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTabJsDto dto = new JvTabJsDto();
        dto.setTabId(DaoUtil.convertNullToString(rs.getString("tabId")));
        dto.setLineNo(DaoUtil.convertNullToString(rs.getString("lineNo")));
        dto.setScript(DaoUtil.convertNullToString(rs.getString("script")));
        return dto;
    }

}

