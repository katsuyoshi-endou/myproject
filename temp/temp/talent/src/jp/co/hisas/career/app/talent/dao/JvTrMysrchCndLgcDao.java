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
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndLgcDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTrMysrchCndLgcDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " MYSRCH_ID as mysrchId,"
                     + " LGC_ROW_NO as lgcRowNo,"
                     + " TAB_ID as tabId,"
                     + " PARAM_ID as paramId,"
                     + " SEARCH_VALUE as searchValue,"
                     + " KIGO_TYPE as kigoType"
                     ;

    public JvTrMysrchCndLgcDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTrMysrchCndLgcDao(Connection conn) {
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

    public void insert(JvTrMysrchCndLgcDto dto) {

        final String sql = "INSERT INTO JV_TR_MYSRCH_CND_LGC ("
                         + "MYSRCH_ID,"
                         + "LGC_ROW_NO,"
                         + "TAB_ID,"
                         + "PARAM_ID,"
                         + "SEARCH_VALUE,"
                         + "KIGO_TYPE"
                         + ")VALUES(?,?,?,?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndLgcDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getMysrchId());
            DaoUtil.setIntToPreparedStatement(pstmt, 2, dto.getLgcRowNo());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getTabId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getParamId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getSearchValue());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 6, dto.getKigoType());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void update(JvTrMysrchCndLgcDto dto) {

        final String sql = "UPDATE JV_TR_MYSRCH_CND_LGC SET "
                         + "SEARCH_VALUE = ?,"
                         + "KIGO_TYPE = ?"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND LGC_ROW_NO = ?"
                         + " AND TAB_ID = ?"
                         + " AND PARAM_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndLgcDao.update");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getSearchValue());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getKigoType());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getMysrchId());
            DaoUtil.setIntToPreparedStatement(pstmt, 4, dto.getLgcRowNo());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getTabId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 6, dto.getParamId());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void delete(String mysrchId, Integer lgcRowNo, String tabId, String paramId) {

        final String sql = "DELETE FROM JV_TR_MYSRCH_CND_LGC"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND LGC_ROW_NO = ?"
                         + " AND TAB_ID = ?"
                         + " AND PARAM_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndLgcDao.delete");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            DaoUtil.setIntToPreparedStatement(pstmt, 2, lgcRowNo);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, tabId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, paramId);
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally { 
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvTrMysrchCndLgcDto select(String mysrchId, Integer lgcRowNo, String tabId, String paramId) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TR_MYSRCH_CND_LGC"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND LGC_ROW_NO = ?"
                         + " AND TAB_ID = ?"
                         + " AND PARAM_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndLgcDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            DaoUtil.setIntToPreparedStatement(pstmt, 2, lgcRowNo);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, tabId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, paramId);
            rs = pstmt.executeQuery();
            JvTrMysrchCndLgcDto dto = null;
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

    public List<JvTrMysrchCndLgcDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTrMysrchCndLgcDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTrMysrchCndLgcDto> lst = new ArrayList<JvTrMysrchCndLgcDto>();
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

    public List<JvTrMysrchCndLgcDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMysrchCndLgcDao.selectDynamic");
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
            Log.sql("[DaoMethod Call] JvTrMysrchCndLgcDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMysrchCndLgcDao.executeDynamic");
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

    private JvTrMysrchCndLgcDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTrMysrchCndLgcDto dto = new JvTrMysrchCndLgcDto();
        dto.setMysrchId(DaoUtil.convertNullToString(rs.getString("mysrchId")));
        dto.setLgcRowNo(rs.getInt("lgcRowNo"));
        dto.setTabId(DaoUtil.convertNullToString(rs.getString("tabId")));
        dto.setParamId(DaoUtil.convertNullToString(rs.getString("paramId")));
        dto.setSearchValue(DaoUtil.convertNullToString(rs.getString("searchValue")));
        dto.setKigoType(DaoUtil.convertNullToString(rs.getString("kigoType")));
        return dto;
    }

}

