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
import jp.co.hisas.career.app.talent.dto.JvSrchRsltWkDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvSrchRsltWkDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " SESSION_ID as sessionId,"
                     + " PARTY as party,"
                     + " GUID as guid,"
                     + " TGT_CMPA_CD as tgtCmpaCd,"
                     + " TGT_STF_NO as tgtStfNo,"
                     + " ROLE_ID as roleId,"
                     + " UPD_USER as updUser"
                     ;

    public JvSrchRsltWkDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvSrchRsltWkDao(Connection conn) {
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

    public void insert(JvSrchRsltWkDto dto) {

        final String sql = "INSERT INTO JV_SRCH_RSLT_WK ("
                         + "SESSION_ID,"
                         + "PARTY,"
                         + "GUID,"
                         + "TGT_CMPA_CD,"
                         + "TGT_STF_NO,"
                         + "ROLE_ID,"
                         + "UPD_USER"
                         + ")VALUES(?,?,?,?,?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvSrchRsltWkDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getSessionId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getParty());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getGuid());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getTgtCmpaCd());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getTgtStfNo());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 6, dto.getRoleId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 7, dto.getUpdUser());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void update(JvSrchRsltWkDto dto) {

        final String sql = "UPDATE JV_SRCH_RSLT_WK SET "
                         + "ROLE_ID = ?,"
                         + "UPD_USER = ?"
                         + " WHERE SESSION_ID = ?"
                         + " AND PARTY = ?"
                         + " AND GUID = ?"
                         + " AND TGT_CMPA_CD = ?"
                         + " AND TGT_STF_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvSrchRsltWkDao.update");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getRoleId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getUpdUser());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getSessionId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getParty());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getGuid());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 6, dto.getTgtCmpaCd());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 7, dto.getTgtStfNo());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void delete(String sessionId, String party, String guid, String tgtCmpaCd, String tgtStfNo) {

        final String sql = "DELETE FROM JV_SRCH_RSLT_WK"
                         + " WHERE SESSION_ID = ?"
                         + " AND PARTY = ?"
                         + " AND GUID = ?"
                         + " AND TGT_CMPA_CD = ?"
                         + " AND TGT_STF_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvSrchRsltWkDao.delete");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, sessionId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, party);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, guid);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, tgtCmpaCd);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, tgtStfNo);
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally { 
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvSrchRsltWkDto select(String sessionId, String party, String guid, String tgtCmpaCd, String tgtStfNo) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_SRCH_RSLT_WK"
                         + " WHERE SESSION_ID = ?"
                         + " AND PARTY = ?"
                         + " AND GUID = ?"
                         + " AND TGT_CMPA_CD = ?"
                         + " AND TGT_STF_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvSrchRsltWkDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, sessionId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, party);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, guid);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, tgtCmpaCd);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, tgtStfNo);
            rs = pstmt.executeQuery();
            JvSrchRsltWkDto dto = null;
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

    public List<JvSrchRsltWkDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvSrchRsltWkDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvSrchRsltWkDto> lst = new ArrayList<JvSrchRsltWkDto>();
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

    public List<JvSrchRsltWkDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvSrchRsltWkDao.selectDynamic");
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

    public int selectCountDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvSrchRsltWkDao.selectCountDynamic");
        ResultSet rs = null;
        int cnt = 0;
        try {
            rs = pstmt.executeQuery();
            if ( rs.next() ) {
                cnt = rs.getInt(1);
            }
            return cnt;
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, rs);
        }
    }

    public int selectCountDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvSrchRsltWkDao.selectCountDynamic");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            return selectCountDynamic(pstmt);
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(PreparedStatement pstmt) {
        try {
            Log.sql("[DaoMethod Call] JvSrchRsltWkDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvSrchRsltWkDao.executeDynamic");
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

    private JvSrchRsltWkDto transferRsToDto(ResultSet rs) throws SQLException {

        JvSrchRsltWkDto dto = new JvSrchRsltWkDto();
        dto.setSessionId(DaoUtil.convertNullToString(rs.getString("sessionId")));
        dto.setParty(DaoUtil.convertNullToString(rs.getString("party")));
        dto.setGuid(DaoUtil.convertNullToString(rs.getString("guid")));
        dto.setTgtCmpaCd(DaoUtil.convertNullToString(rs.getString("tgtCmpaCd")));
        dto.setTgtStfNo(DaoUtil.convertNullToString(rs.getString("tgtStfNo")));
        dto.setRoleId(DaoUtil.convertNullToString(rs.getString("roleId")));
        dto.setUpdUser(DaoUtil.convertNullToString(rs.getString("updUser")));
        return dto;
    }

    public void deleteJvSrchRsltWkByUpdUser(String sessionId) {

        final String sql = "DELETE FROM JV_SRCH_RSLT_WK WHERE UPD_USER = ?";
        Log.sql("[DaoMethod Call] JvSrchRsltWkDao.deleteJvSrchRsltWkByUpdUser");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, sessionId);
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public int countJvSrchRsltWkBySessionId(String sessionId) {

        final String sql = "SELECT COUNT(*) FROM JV_SRCH_RSLT_WK WHERE SESSION_ID = ?";
        Log.sql("[DaoMethod Call] JvSrchRsltWkDao.countJvSrchRsltWkBySessionId");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int cnt = 0;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, sessionId);
            rs = pstmt.executeQuery();
            if ( rs.next() ) {
                cnt = rs.getInt(1);
            }
            return cnt;
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, rs);
        }
    }

}

