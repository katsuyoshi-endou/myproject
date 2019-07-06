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
import jp.co.hisas.career.app.talent.dto.JvDfQuickWordDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvDfQuickWordDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " WORD as word,"
                     + " PZ_ID as pzId,"
                     + " PRIORITY as priority,"
                     + " OVER_FLG as overFlg"
                     ;

    public JvDfQuickWordDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvDfQuickWordDao(Connection conn) {
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

    public JvDfQuickWordDto select() {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_DF_QUICK_WORD"
                         + " WHERE "
                         ;
        Log.sql("[DaoMethod Call] JvDfQuickWordDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            JvDfQuickWordDto dto = null;
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

    public List<JvDfQuickWordDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvDfQuickWordDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvDfQuickWordDto> lst = new ArrayList<JvDfQuickWordDto>();
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

    public List<JvDfQuickWordDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvDfQuickWordDao.selectDynamic");
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

    private JvDfQuickWordDto transferRsToDto(ResultSet rs) throws SQLException {

        JvDfQuickWordDto dto = new JvDfQuickWordDto();
        dto.setWord(DaoUtil.convertNullToString(rs.getString("word")));
        dto.setPzId(DaoUtil.convertNullToString(rs.getString("pzId")));
        dto.setPriority(rs.getInt("priority"));
        dto.setOverFlg(rs.getInt("overFlg"));
        return dto;
    }

}

