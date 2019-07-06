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
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldTalentDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTrMyfoldTalentDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " MYFOLD_ID as myfoldId,"
                     + " TGT_CMPA_CD as tgtCmpaCd,"
                     + " TGT_STF_NO as tgtStfNo"
                     ;

    public JvTrMyfoldTalentDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTrMyfoldTalentDao(Connection conn) {
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

    public void insert(JvTrMyfoldTalentDto dto) {

        final String sql = "INSERT INTO JV_TR_MYFOLD_TALENT ("
                         + "MYFOLD_ID,"
                         + "TGT_CMPA_CD,"
                         + "TGT_STF_NO"
                         + ")VALUES(?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldTalentDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getMyfoldId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getTgtCmpaCd());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getTgtStfNo());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void update(JvTrMyfoldTalentDto dto) {

        final String sql = "UPDATE JV_TR_MYFOLD_TALENT SET"
                         + " WHERE MYFOLD_ID = ?"
                         + " AND TGT_CMPA_CD = ?"
                         + " AND TGT_STF_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldTalentDao.update");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getMyfoldId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getTgtCmpaCd());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getTgtStfNo());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void delete(String myfoldId, String tgtCmpaCd, String tgtStfNo) {

        final String sql = "DELETE FROM JV_TR_MYFOLD_TALENT"
                         + " WHERE MYFOLD_ID = ?"
                         + " AND TGT_CMPA_CD = ?"
                         + " AND TGT_STF_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldTalentDao.delete");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, myfoldId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, tgtCmpaCd);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, tgtStfNo);
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally { 
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvTrMyfoldTalentDto select(String myfoldId, String tgtCmpaCd, String tgtStfNo) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TR_MYFOLD_TALENT"
                         + " WHERE MYFOLD_ID = ?"
                         + " AND TGT_CMPA_CD = ?"
                         + " AND TGT_STF_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldTalentDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, myfoldId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, tgtCmpaCd);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, tgtStfNo);
            rs = pstmt.executeQuery();
            JvTrMyfoldTalentDto dto = null;
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

    public List<JvTrMyfoldTalentDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTrMyfoldTalentDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTrMyfoldTalentDto> lst = new ArrayList<JvTrMyfoldTalentDto>();
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

    public List<JvTrMyfoldTalentDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMyfoldTalentDao.selectDynamic");
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
            Log.sql("[DaoMethod Call] JvTrMyfoldTalentDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMyfoldTalentDao.executeDynamic");
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

    private JvTrMyfoldTalentDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTrMyfoldTalentDto dto = new JvTrMyfoldTalentDto();
        dto.setMyfoldId(DaoUtil.convertNullToString(rs.getString("myfoldId")));
        dto.setTgtCmpaCd(DaoUtil.convertNullToString(rs.getString("tgtCmpaCd")));
        dto.setTgtStfNo(DaoUtil.convertNullToString(rs.getString("tgtStfNo")));
        return dto;
    }

}

