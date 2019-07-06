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
import jp.co.hisas.career.app.talent.dto.JvDfQuickAllDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvDfQuickAllDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " PZ_ID as pzId,"
                     + " REQUIRED_FMT as requiredFmt,"
                     + " PRIORITY as priority"
                     ;

    public JvDfQuickAllDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvDfQuickAllDao(Connection conn) {
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

    public JvDfQuickAllDto select() {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_DF_QUICK_ALL"
                         + " WHERE "
                         ;
        Log.sql("[DaoMethod Call] JvDfQuickAllDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            JvDfQuickAllDto dto = null;
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

    public List<JvDfQuickAllDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvDfQuickAllDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvDfQuickAllDto> lst = new ArrayList<JvDfQuickAllDto>();
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

    public List<JvDfQuickAllDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvDfQuickAllDao.selectDynamic");
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

    private JvDfQuickAllDto transferRsToDto(ResultSet rs) throws SQLException {

        JvDfQuickAllDto dto = new JvDfQuickAllDto();
        dto.setPzId(DaoUtil.convertNullToString(rs.getString("pzId")));
        dto.setRequiredFmt(DaoUtil.convertNullToString(rs.getString("requiredFmt")));
        dto.setPriority(rs.getInt("priority"));
        return dto;
    }

}

