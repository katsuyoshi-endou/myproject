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
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndSglDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTrMysrchCndSglDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " MYSRCH_ID as mysrchId,"
                     + " PARAM_ID as paramId,"
                     + " SEARCH_VALUE as searchValue"
                     ;

    public JvTrMysrchCndSglDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTrMysrchCndSglDao(Connection conn) {
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

    public void insert(JvTrMysrchCndSglDto dto) {

        final String sql = "INSERT INTO JV_TR_MYSRCH_CND_SGL ("
                         + "MYSRCH_ID,"
                         + "PARAM_ID,"
                         + "SEARCH_VALUE"
                         + ")VALUES(?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndSglDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getMysrchId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getParamId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getSearchValue());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void update(JvTrMysrchCndSglDto dto) {

        final String sql = "UPDATE JV_TR_MYSRCH_CND_SGL SET "
                         + "SEARCH_VALUE = ?"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND PARAM_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndSglDao.update");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getSearchValue());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getMysrchId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getParamId());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void delete(String mysrchId, String paramId) {

        final String sql = "DELETE FROM JV_TR_MYSRCH_CND_SGL"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND PARAM_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndSglDao.delete");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, paramId);
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally { 
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvTrMysrchCndSglDto select(String mysrchId, String paramId) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TR_MYSRCH_CND_SGL"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND PARAM_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndSglDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, paramId);
            rs = pstmt.executeQuery();
            JvTrMysrchCndSglDto dto = null;
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

    public List<JvTrMysrchCndSglDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTrMysrchCndSglDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTrMysrchCndSglDto> lst = new ArrayList<JvTrMysrchCndSglDto>();
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

    public List<JvTrMysrchCndSglDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMysrchCndSglDao.selectDynamic");
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
            Log.sql("[DaoMethod Call] JvTrMysrchCndSglDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMysrchCndSglDao.executeDynamic");
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

    private JvTrMysrchCndSglDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTrMysrchCndSglDto dto = new JvTrMysrchCndSglDto();
        dto.setMysrchId(DaoUtil.convertNullToString(rs.getString("mysrchId")));
        dto.setParamId(DaoUtil.convertNullToString(rs.getString("paramId")));
        dto.setSearchValue(DaoUtil.convertNullToString(rs.getString("searchValue")));
        return dto;
    }

}

