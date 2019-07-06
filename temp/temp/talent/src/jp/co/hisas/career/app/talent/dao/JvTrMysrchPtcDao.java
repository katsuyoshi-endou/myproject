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
import jp.co.hisas.career.app.talent.dto.JvTrMysrchPtcDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTrMysrchPtcDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " MYSRCH_ID as mysrchId,"
                     + " PARTY as party,"
                     + " GUID as guid,"
                     + " OWNER_FLG as ownerFlg,"
                     + " CND_EDIT_FLG as cndEditFlg"
                     ;

    public JvTrMysrchPtcDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTrMysrchPtcDao(Connection conn) {
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

    public void insert(JvTrMysrchPtcDto dto) {

        final String sql = "INSERT INTO JV_TR_MYSRCH_PTC ("
                         + "MYSRCH_ID,"
                         + "PARTY,"
                         + "GUID,"
                         + "OWNER_FLG,"
                         + "CND_EDIT_FLG"
                         + ")VALUES(?,?,?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchPtcDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getMysrchId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getParty());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getGuid());
            DaoUtil.setIntToPreparedStatement(pstmt, 4, dto.getOwnerFlg());
            DaoUtil.setIntToPreparedStatement(pstmt, 5, dto.getCndEditFlg());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void update(JvTrMysrchPtcDto dto) {

        final String sql = "UPDATE JV_TR_MYSRCH_PTC SET "
                         + "OWNER_FLG = ?,"
                         + "CND_EDIT_FLG = ?"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND PARTY = ?"
                         + " AND GUID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchPtcDao.update");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setIntToPreparedStatement(pstmt, 1, dto.getOwnerFlg());
            DaoUtil.setIntToPreparedStatement(pstmt, 2, dto.getCndEditFlg());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getMysrchId());
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

    public void delete(String mysrchId, String party, String guid) {

        final String sql = "DELETE FROM JV_TR_MYSRCH_PTC"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND PARTY = ?"
                         + " AND GUID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchPtcDao.delete");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
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

    public JvTrMysrchPtcDto select(String mysrchId, String party, String guid) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TR_MYSRCH_PTC"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND PARTY = ?"
                         + " AND GUID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchPtcDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, party);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, guid);
            rs = pstmt.executeQuery();
            JvTrMysrchPtcDto dto = null;
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

    public List<JvTrMysrchPtcDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTrMysrchPtcDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTrMysrchPtcDto> lst = new ArrayList<JvTrMysrchPtcDto>();
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

    public List<JvTrMysrchPtcDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMysrchPtcDao.selectDynamic");
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
            Log.sql("[DaoMethod Call] JvTrMysrchPtcDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMysrchPtcDao.executeDynamic");
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

    private JvTrMysrchPtcDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTrMysrchPtcDto dto = new JvTrMysrchPtcDto();
        dto.setMysrchId(DaoUtil.convertNullToString(rs.getString("mysrchId")));
        dto.setParty(DaoUtil.convertNullToString(rs.getString("party")));
        dto.setGuid(DaoUtil.convertNullToString(rs.getString("guid")));
        dto.setOwnerFlg(rs.getInt("ownerFlg"));
        dto.setCndEditFlg(rs.getInt("cndEditFlg"));
        return dto;
    }

}

