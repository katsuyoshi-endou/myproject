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
import jp.co.hisas.career.app.talent.dto.JvDfInstantSearchDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvDfInstantSearchDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " PARTY as party,"
                     + " SCOPE as scope,"
                     + " SORT as sort,"
                     + " CHECK_FLG as checkFlg"
                     ;

    public JvDfInstantSearchDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvDfInstantSearchDao(Connection conn) {
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

    public JvDfInstantSearchDto select(String party, String scope, Integer sort, Integer checkFlg) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_DF_INSTANT_SEARCH"
                         + " WHERE PARTY = ?"
                         + " AND SCOPE = ?"
                         + " AND SORT = ?"
                         + " AND CHECK_FLG = ?"
                         ;
        Log.sql("[DaoMethod Call] JvDfInstantSearchDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, party);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, scope);
            DaoUtil.setIntToPreparedStatement(pstmt, 3, sort);
            DaoUtil.setIntToPreparedStatement(pstmt, 4, checkFlg);
            rs = pstmt.executeQuery();
            JvDfInstantSearchDto dto = null;
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

    public List<JvDfInstantSearchDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvDfInstantSearchDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvDfInstantSearchDto> lst = new ArrayList<JvDfInstantSearchDto>();
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

    public List<JvDfInstantSearchDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvDfInstantSearchDao.selectDynamic");
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

    private JvDfInstantSearchDto transferRsToDto(ResultSet rs) throws SQLException {

        JvDfInstantSearchDto dto = new JvDfInstantSearchDto();
        dto.setParty(DaoUtil.convertNullToString(rs.getString("party")));
        dto.setScope(DaoUtil.convertNullToString(rs.getString("scope")));
        dto.setSort(rs.getInt("sort"));
        dto.setCheckFlg(rs.getInt("checkFlg"));
        return dto;
    }

}

