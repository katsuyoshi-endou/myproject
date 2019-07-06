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
import jp.co.hisas.career.app.talent.dto.JvWkInstantHitDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvWkInstantHitDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " SESSION_ID as sessionId,"
                     + " GUID as guid,"
                     + " QUERY_SEQ as querySeq,"
                     + " QUERY as query,"
                     + " TGT_CMPA_CD as tgtCmpaCd,"
                     + " TGT_STF_NO as tgtStfNo,"
                     + " PZ_ID as pzId,"
                     + " PZ_VAL as pzVal"
                     ;

    public JvWkInstantHitDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvWkInstantHitDao(Connection conn) {
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

    public List<JvWkInstantHitDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvWkInstantHitDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvWkInstantHitDto> lst = new ArrayList<JvWkInstantHitDto>();
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

    public List<JvWkInstantHitDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvWkInstantHitDao.selectDynamic");
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

    public void executeDynamic(PreparedStatement pstmt) {
        try {
            Log.sql("[DaoMethod Call] JvWkInstantHitDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvWkInstantHitDao.executeDynamic");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            executeDynamic(pstmt);
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    private JvWkInstantHitDto transferRsToDto(ResultSet rs) throws SQLException {

        JvWkInstantHitDto dto = new JvWkInstantHitDto();
        dto.setSessionId(DaoUtil.convertNullToString(rs.getString("sessionId")));
        dto.setGuid(DaoUtil.convertNullToString(rs.getString("guid")));
        dto.setQuerySeq(rs.getInt("querySeq"));
        dto.setQuery(DaoUtil.convertNullToString(rs.getString("query")));
        dto.setTgtCmpaCd(DaoUtil.convertNullToString(rs.getString("tgtCmpaCd")));
        dto.setTgtStfNo(DaoUtil.convertNullToString(rs.getString("tgtStfNo")));
        dto.setPzId(DaoUtil.convertNullToString(rs.getString("pzId")));
        dto.setPzVal(DaoUtil.convertNullToString(rs.getString("pzVal")));
        return dto;
    }

}

