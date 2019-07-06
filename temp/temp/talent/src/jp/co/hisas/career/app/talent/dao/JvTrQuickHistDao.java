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
import jp.co.hisas.career.app.talent.dto.JvTrQuickHistDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTrQuickHistDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " SEQ_NO as seqNo,"
                     + " PARTY as party,"
                     + " GUID as guid,"
                     + " QUERY as query,"
                     + " TIMESTAMP as timestamp"
                     ;

    public JvTrQuickHistDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTrQuickHistDao(Connection conn) {
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

    public void insert(JvTrQuickHistDto dto) {

        final String sql = "INSERT INTO JV_TR_QUICK_HIST ("
                         + "SEQ_NO,"
                         + "PARTY,"
                         + "GUID,"
                         + "QUERY,"
                         + "TIMESTAMP"
                         + ")VALUES(?,?,?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvTrQuickHistDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setIntToPreparedStatement(pstmt, 1, dto.getSeqNo());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getParty());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getGuid());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getQuery());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getTimestamp());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvTrQuickHistDto select(Integer seqNo) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TR_QUICK_HIST"
                         + " WHERE SEQ_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrQuickHistDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setIntToPreparedStatement(pstmt, 1, seqNo);
            rs = pstmt.executeQuery();
            JvTrQuickHistDto dto = null;
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

    public List<JvTrQuickHistDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTrQuickHistDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTrQuickHistDto> lst = new ArrayList<JvTrQuickHistDto>();
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

    public List<JvTrQuickHistDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrQuickHistDao.selectDynamic");
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
            Log.sql("[DaoMethod Call] JvTrQuickHistDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrQuickHistDao.executeDynamic");
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

    private JvTrQuickHistDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTrQuickHistDto dto = new JvTrQuickHistDto();
        dto.setSeqNo(rs.getInt("seqNo"));
        dto.setParty(DaoUtil.convertNullToString(rs.getString("party")));
        dto.setGuid(DaoUtil.convertNullToString(rs.getString("guid")));
        dto.setQuery(DaoUtil.convertNullToString(rs.getString("query")));
        dto.setTimestamp(DaoUtil.convertNullToString(rs.getString("timestamp")));
        return dto;
    }

}

