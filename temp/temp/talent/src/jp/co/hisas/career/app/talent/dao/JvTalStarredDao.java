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
import jp.co.hisas.career.app.talent.dto.JvTalStarredDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTalStarredDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " PARTY as party,"
                     + " GUID as guid,"
                     + " TGT_CMPA_CD as tgtCmpaCd,"
                     + " TGT_STF_NO as tgtStfNo"
                     ;

    public JvTalStarredDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTalStarredDao(Connection conn) {
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

    public void insert(JvTalStarredDto dto) {

        final String sql = "INSERT INTO JV_TAL_STARRED ("
                         + "PARTY,"
                         + "GUID,"
                         + "TGT_CMPA_CD,"
                         + "TGT_STF_NO"
                         + ")VALUES(?,?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvTalStarredDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getParty());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getGuid());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getTgtCmpaCd());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getTgtStfNo());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void update(JvTalStarredDto dto) {

        final String sql = "UPDATE JV_TAL_STARRED SET"
                         + " WHERE PARTY = ?"
                         + " AND GUID = ?"
                         + " AND TGT_CMPA_CD = ?"
                         + " AND TGT_STF_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTalStarredDao.update");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getParty());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getGuid());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getTgtCmpaCd());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getTgtStfNo());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void delete(String party, String guid, String tgtCmpaCd, String tgtStfNo) {

        final String sql = "DELETE FROM JV_TAL_STARRED"
                         + " WHERE PARTY = ?"
                         + " AND GUID = ?"
                         + " AND TGT_CMPA_CD = ?"
                         + " AND TGT_STF_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTalStarredDao.delete");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, party);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, guid);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, tgtCmpaCd);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, tgtStfNo);
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally { 
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvTalStarredDto select(String party, String guid, String tgtCmpaCd, String tgtStfNo) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TAL_STARRED"
                         + " WHERE PARTY = ?"
                         + " AND GUID = ?"
                         + " AND TGT_CMPA_CD = ?"
                         + " AND TGT_STF_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTalStarredDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, party);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, guid);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, tgtCmpaCd);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, tgtStfNo);
            rs = pstmt.executeQuery();
            JvTalStarredDto dto = null;
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

    public List<JvTalStarredDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTalStarredDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTalStarredDto> lst = new ArrayList<JvTalStarredDto>();
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

    public List<JvTalStarredDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTalStarredDao.selectDynamic");
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
            Log.sql("[DaoMethod Call] JvTalStarredDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTalStarredDao.executeDynamic");
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

    private JvTalStarredDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTalStarredDto dto = new JvTalStarredDto();
        dto.setParty(DaoUtil.convertNullToString(rs.getString("party")));
        dto.setGuid(DaoUtil.convertNullToString(rs.getString("guid")));
        dto.setTgtCmpaCd(DaoUtil.convertNullToString(rs.getString("tgtCmpaCd")));
        dto.setTgtStfNo(DaoUtil.convertNullToString(rs.getString("tgtStfNo")));
        return dto;
    }

}

