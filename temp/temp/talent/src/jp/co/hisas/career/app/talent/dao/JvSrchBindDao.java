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
import jp.co.hisas.career.app.talent.dto.JvSrchBindDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvSrchBindDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " GUID as guid,"
                     + " TGT_CMPA_CD as tgtCmpaCd,"
                     + " TGT_STF_NO as tgtStfNo,"
                     + " ROLE_ID as roleId,"
                     + " DIRECT_FLG as directFlg"
                     ;

    public JvSrchBindDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvSrchBindDao(Connection conn) {
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

    public JvSrchBindDto select(String guid, String tgtCmpaCd, String tgtStfNo) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_SRCH_BIND"
                         + " WHERE GUID = ?"
                         + " AND TGT_CMPA_CD = ?"
                         + " AND TGT_STF_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvSrchBindDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, guid);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, tgtCmpaCd);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, tgtStfNo);
            rs = pstmt.executeQuery();
            JvSrchBindDto dto = null;
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

    public List<JvSrchBindDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvSrchBindDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvSrchBindDto> lst = new ArrayList<JvSrchBindDto>();
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

    public List<JvSrchBindDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvSrchBindDao.selectDynamic");
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

    private JvSrchBindDto transferRsToDto(ResultSet rs) throws SQLException {

        JvSrchBindDto dto = new JvSrchBindDto();
        dto.setGuid(DaoUtil.convertNullToString(rs.getString("guid")));
        dto.setTgtCmpaCd(DaoUtil.convertNullToString(rs.getString("tgtCmpaCd")));
        dto.setTgtStfNo(DaoUtil.convertNullToString(rs.getString("tgtStfNo")));
        dto.setRoleId(DaoUtil.convertNullToString(rs.getString("roleId")));
        dto.setDirectFlg(DaoUtil.convertNullToString(rs.getString("directFlg")));
        return dto;
    }

}

