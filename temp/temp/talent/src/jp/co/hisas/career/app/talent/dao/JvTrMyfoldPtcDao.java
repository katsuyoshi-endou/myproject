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
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldPtcDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTrMyfoldPtcDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " MYFOLD_ID as myfoldId,"
                     + " PARTY as party,"
                     + " GUID as guid,"
                     + " OWNER_FLG as ownerFlg,"
                     + " TAL_EDIT_FLG as talEditFlg"
                     ;

    public JvTrMyfoldPtcDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTrMyfoldPtcDao(Connection conn) {
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

    public void insert(JvTrMyfoldPtcDto dto) {

        final String sql = "INSERT INTO JV_TR_MYFOLD_PTC ("
                         + "MYFOLD_ID,"
                         + "PARTY,"
                         + "GUID,"
                         + "OWNER_FLG,"
                         + "TAL_EDIT_FLG"
                         + ")VALUES(?,?,?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldPtcDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getMyfoldId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getParty());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getGuid());
            DaoUtil.setIntToPreparedStatement(pstmt, 4, dto.getOwnerFlg());
            DaoUtil.setIntToPreparedStatement(pstmt, 5, dto.getTalEditFlg());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void update(JvTrMyfoldPtcDto dto) {

        final String sql = "UPDATE JV_TR_MYFOLD_PTC SET "
                         + "OWNER_FLG = ?,"
                         + "TAL_EDIT_FLG = ?"
                         + " WHERE MYFOLD_ID = ?"
                         + " AND PARTY = ?"
                         + " AND GUID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldPtcDao.update");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setIntToPreparedStatement(pstmt, 1, dto.getOwnerFlg());
            DaoUtil.setIntToPreparedStatement(pstmt, 2, dto.getTalEditFlg());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getMyfoldId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getParty());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getGuid());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void delete(String myfoldId, String party, String guid) {

        final String sql = "DELETE FROM JV_TR_MYFOLD_PTC"
                         + " WHERE MYFOLD_ID = ?"
                         + " AND PARTY = ?"
                         + " AND GUID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldPtcDao.delete");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, myfoldId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, party);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, guid);
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally { 
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvTrMyfoldPtcDto select(String myfoldId, String party, String guid) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TR_MYFOLD_PTC"
                         + " WHERE MYFOLD_ID = ?"
                         + " AND PARTY = ?"
                         + " AND GUID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldPtcDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, myfoldId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, party);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, guid);
            rs = pstmt.executeQuery();
            JvTrMyfoldPtcDto dto = null;
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

    public List<JvTrMyfoldPtcDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTrMyfoldPtcDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTrMyfoldPtcDto> lst = new ArrayList<JvTrMyfoldPtcDto>();
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

    public List<JvTrMyfoldPtcDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMyfoldPtcDao.selectDynamic");
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
            Log.sql("[DaoMethod Call] JvTrMyfoldPtcDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMyfoldPtcDao.executeDynamic");
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

    private JvTrMyfoldPtcDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTrMyfoldPtcDto dto = new JvTrMyfoldPtcDto();
        dto.setMyfoldId(DaoUtil.convertNullToString(rs.getString("myfoldId")));
        dto.setParty(DaoUtil.convertNullToString(rs.getString("party")));
        dto.setGuid(DaoUtil.convertNullToString(rs.getString("guid")));
        dto.setOwnerFlg(rs.getInt("ownerFlg"));
        dto.setTalEditFlg(rs.getInt("talEditFlg"));
        return dto;
    }

}

