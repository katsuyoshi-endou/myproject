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
import jp.co.hisas.career.app.talent.dto.JvTrProfViewHistDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTrProfViewHistDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " SEQ_NO as seqNo,"
                     + " PARTY as party,"
                     + " GUID as guid,"
                     + " TGT_CMPA_CD as tgtCmpaCd,"
                     + " TGT_STF_NO as tgtStfNo,"
                     + " TIMESTAMP as timestamp"
                     ;

    public JvTrProfViewHistDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTrProfViewHistDao(Connection conn) {
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

    public void insert(JvTrProfViewHistDto dto) {

        final String sql = "INSERT INTO JV_TR_PROF_VIEW_HIST ("
                         + "SEQ_NO,"
                         + "PARTY,"
                         + "GUID,"
                         + "TGT_CMPA_CD,"
                         + "TGT_STF_NO,"
                         + "TIMESTAMP"
                         + ")VALUES(?,?,?,?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvTrProfViewHistDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setIntToPreparedStatement(pstmt, 1, dto.getSeqNo());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getParty());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getGuid());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getTgtCmpaCd());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getTgtStfNo());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 6, dto.getTimestamp());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvTrProfViewHistDto select(Integer seqNo) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TR_PROF_VIEW_HIST"
                         + " WHERE SEQ_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrProfViewHistDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setIntToPreparedStatement(pstmt, 1, seqNo);
            rs = pstmt.executeQuery();
            JvTrProfViewHistDto dto = null;
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

    public List<JvTrProfViewHistDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTrProfViewHistDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTrProfViewHistDto> lst = new ArrayList<JvTrProfViewHistDto>();
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

    public List<JvTrProfViewHistDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrProfViewHistDao.selectDynamic");
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
            Log.sql("[DaoMethod Call] JvTrProfViewHistDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrProfViewHistDao.executeDynamic");
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

    private JvTrProfViewHistDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTrProfViewHistDto dto = new JvTrProfViewHistDto();
        dto.setSeqNo(rs.getInt("seqNo"));
        dto.setParty(DaoUtil.convertNullToString(rs.getString("party")));
        dto.setGuid(DaoUtil.convertNullToString(rs.getString("guid")));
        dto.setTgtCmpaCd(DaoUtil.convertNullToString(rs.getString("tgtCmpaCd")));
        dto.setTgtStfNo(DaoUtil.convertNullToString(rs.getString("tgtStfNo")));
        dto.setTimestamp(DaoUtil.convertNullToString(rs.getString("timestamp")));
        return dto;
    }

}

