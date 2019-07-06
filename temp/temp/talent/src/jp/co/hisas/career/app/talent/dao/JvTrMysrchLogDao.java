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
import jp.co.hisas.career.app.talent.dto.JvTrMysrchLogDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTrMysrchLogDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " MYSRCH_ID as mysrchId,"
                     + " ACT_SEQ as actSeq,"
                     + " ACT_BY as actBy,"
                     + " ACT_TYPE as actType,"
                     + " ACT_ARG as actArg,"
                     + " ACT_AT as actAt"
                     ;

    public JvTrMysrchLogDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTrMysrchLogDao(Connection conn) {
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

    public void insert(JvTrMysrchLogDto dto) {

        final String sql = "INSERT INTO JV_TR_MYSRCH_LOG ("
                         + "MYSRCH_ID,"
                         + "ACT_SEQ,"
                         + "ACT_BY,"
                         + "ACT_TYPE,"
                         + "ACT_ARG,"
                         + "ACT_AT"
                         + ")VALUES(?,?,?,?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchLogDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getMysrchId());
            DaoUtil.setIntToPreparedStatement(pstmt, 2, dto.getActSeq());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getActBy());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getActType());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getActArg());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 6, dto.getActAt());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void update(JvTrMysrchLogDto dto) {

        final String sql = "UPDATE JV_TR_MYSRCH_LOG SET "
                         + "ACT_BY = ?,"
                         + "ACT_TYPE = ?,"
                         + "ACT_ARG = ?,"
                         + "ACT_AT = ?"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND ACT_SEQ = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchLogDao.update");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getActBy());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getActType());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getActArg());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getActAt());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getMysrchId());
            DaoUtil.setIntToPreparedStatement(pstmt, 6, dto.getActSeq());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void delete(String mysrchId, Integer actSeq) {

        final String sql = "DELETE FROM JV_TR_MYSRCH_LOG"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND ACT_SEQ = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchLogDao.delete");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            DaoUtil.setIntToPreparedStatement(pstmt, 2, actSeq);
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally { 
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvTrMysrchLogDto select(String mysrchId, Integer actSeq) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TR_MYSRCH_LOG"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND ACT_SEQ = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchLogDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            DaoUtil.setIntToPreparedStatement(pstmt, 2, actSeq);
            rs = pstmt.executeQuery();
            JvTrMysrchLogDto dto = null;
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

    public List<JvTrMysrchLogDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTrMysrchLogDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTrMysrchLogDto> lst = new ArrayList<JvTrMysrchLogDto>();
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

    public List<JvTrMysrchLogDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMysrchLogDao.selectDynamic");
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
            Log.sql("[DaoMethod Call] JvTrMysrchLogDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMysrchLogDao.executeDynamic");
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

    private JvTrMysrchLogDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTrMysrchLogDto dto = new JvTrMysrchLogDto();
        dto.setMysrchId(DaoUtil.convertNullToString(rs.getString("mysrchId")));
        dto.setActSeq(rs.getInt("actSeq"));
        dto.setActBy(DaoUtil.convertNullToString(rs.getString("actBy")));
        dto.setActType(DaoUtil.convertNullToString(rs.getString("actType")));
        dto.setActArg(DaoUtil.convertNullToString(rs.getString("actArg")));
        dto.setActAt(DaoUtil.convertNullToString(rs.getString("actAt")));
        return dto;
    }

}

