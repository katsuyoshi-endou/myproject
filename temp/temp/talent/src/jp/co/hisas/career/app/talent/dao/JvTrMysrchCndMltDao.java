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
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndMltDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTrMysrchCndMltDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " MYSRCH_ID as mysrchId,"
                     + " PARAM_ID as paramId,"
                     + " PARAM_SEQ as paramSeq,"
                     + " CODE_VALUE as codeValue,"
                     + " SEARCH_VALUE as searchValue"
                     ;

    public JvTrMysrchCndMltDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTrMysrchCndMltDao(Connection conn) {
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

    public void insert(JvTrMysrchCndMltDto dto) {

        final String sql = "INSERT INTO JV_TR_MYSRCH_CND_MLT ("
                         + "MYSRCH_ID,"
                         + "PARAM_ID,"
                         + "PARAM_SEQ,"
                         + "CODE_VALUE,"
                         + "SEARCH_VALUE"
                         + ")VALUES(?,?,?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndMltDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getMysrchId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getParamId());
            DaoUtil.setIntToPreparedStatement(pstmt, 3, dto.getParamSeq());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getCodeValue());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getSearchValue());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void update(JvTrMysrchCndMltDto dto) {

        final String sql = "UPDATE JV_TR_MYSRCH_CND_MLT SET "
                         + "CODE_VALUE = ?,"
                         + "SEARCH_VALUE = ?"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND PARAM_ID = ?"
                         + " AND PARAM_SEQ = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndMltDao.update");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getCodeValue());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getSearchValue());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getMysrchId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getParamId());
            DaoUtil.setIntToPreparedStatement(pstmt, 5, dto.getParamSeq());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void delete(String mysrchId, String paramId, Integer paramSeq) {

        final String sql = "DELETE FROM JV_TR_MYSRCH_CND_MLT"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND PARAM_ID = ?"
                         + " AND PARAM_SEQ = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndMltDao.delete");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, paramId);
            DaoUtil.setIntToPreparedStatement(pstmt, 3, paramSeq);
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally { 
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvTrMysrchCndMltDto select(String mysrchId, String paramId, Integer paramSeq) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TR_MYSRCH_CND_MLT"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND PARAM_ID = ?"
                         + " AND PARAM_SEQ = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndMltDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, paramId);
            DaoUtil.setIntToPreparedStatement(pstmt, 3, paramSeq);
            rs = pstmt.executeQuery();
            JvTrMysrchCndMltDto dto = null;
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

    public List<JvTrMysrchCndMltDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTrMysrchCndMltDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTrMysrchCndMltDto> lst = new ArrayList<JvTrMysrchCndMltDto>();
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

    public List<JvTrMysrchCndMltDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMysrchCndMltDao.selectDynamic");
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
            Log.sql("[DaoMethod Call] JvTrMysrchCndMltDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMysrchCndMltDao.executeDynamic");
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

    private JvTrMysrchCndMltDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTrMysrchCndMltDto dto = new JvTrMysrchCndMltDto();
        dto.setMysrchId(DaoUtil.convertNullToString(rs.getString("mysrchId")));
        dto.setParamId(DaoUtil.convertNullToString(rs.getString("paramId")));
        dto.setParamSeq(rs.getInt("paramSeq"));
        dto.setCodeValue(DaoUtil.convertNullToString(rs.getString("codeValue")));
        dto.setSearchValue(DaoUtil.convertNullToString(rs.getString("searchValue")));
        return dto;
    }

}

