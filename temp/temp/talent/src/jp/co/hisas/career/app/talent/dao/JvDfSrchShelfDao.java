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
import jp.co.hisas.career.app.talent.dto.JvDfSrchShelfDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvDfSrchShelfDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " PZ_ID as pzId,"
                     + " HRZ_TBL as hrzTbl,"
                     + " HRZ_COL as hrzCol,"
                     + " NUMBER_SRCH_FLG as numberSrchFlg"
                     ;

    public JvDfSrchShelfDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvDfSrchShelfDao(Connection conn) {
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

    public JvDfSrchShelfDto select(String pzId) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_DF_SRCH_SHELF"
                         + " WHERE PZ_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvDfSrchShelfDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, pzId);
            rs = pstmt.executeQuery();
            JvDfSrchShelfDto dto = null;
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

    public List<JvDfSrchShelfDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvDfSrchShelfDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvDfSrchShelfDto> lst = new ArrayList<JvDfSrchShelfDto>();
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

    public List<JvDfSrchShelfDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvDfSrchShelfDao.selectDynamic");
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

    private JvDfSrchShelfDto transferRsToDto(ResultSet rs) throws SQLException {

        JvDfSrchShelfDto dto = new JvDfSrchShelfDto();
        dto.setPzId(DaoUtil.convertNullToString(rs.getString("pzId")));
        dto.setHrzTbl(DaoUtil.convertNullToString(rs.getString("hrzTbl")));
        dto.setHrzCol(DaoUtil.convertNullToString(rs.getString("hrzCol")));
        dto.setNumberSrchFlg(DaoUtil.convertNullToString(rs.getString("numberSrchFlg")));
        return dto;
    }

}

