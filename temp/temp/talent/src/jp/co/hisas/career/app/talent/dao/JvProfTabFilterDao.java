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
import jp.co.hisas.career.app.talent.dto.JvProfTabFilterDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvProfTabFilterDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " PARTY as party,"
                     + " ROLE_ID as roleId,"
                     + " TAB_ID as tabId,"
                     + " HYOJI_JUNJO as hyojiJunjo,"
                     + " DISPLAY_MODE as displayMode"
                     ;

    public JvProfTabFilterDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvProfTabFilterDao(Connection conn) {
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

    public JvProfTabFilterDto select(String party, String roleId, String tabId) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_PROF_TAB_FILTER"
                         + " WHERE PARTY = ?"
                         + " AND ROLE_ID = ?"
                         + " AND TAB_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvProfTabFilterDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, party);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, roleId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, tabId);
            rs = pstmt.executeQuery();
            JvProfTabFilterDto dto = null;
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

    private JvProfTabFilterDto transferRsToDto(ResultSet rs) throws SQLException {

        JvProfTabFilterDto dto = new JvProfTabFilterDto();
        dto.setParty(DaoUtil.convertNullToString(rs.getString("party")));
        dto.setRoleId(DaoUtil.convertNullToString(rs.getString("roleId")));
        dto.setTabId(DaoUtil.convertNullToString(rs.getString("tabId")));
        dto.setHyojiJunjo(rs.getInt("hyojiJunjo"));
        dto.setDisplayMode(DaoUtil.convertNullToString(rs.getString("displayMode")));
        return dto;
    }

    public List<JvProfTabFilterDto> selectCompanyAndRole(String party, String roleId) {

        final String sql = "SELECT " + ALLCOLS + " FROM JV_PROF_TAB_FILTER WHERE PARTY=? AND ROLE_ID=? ORDER BY HYOJI_JUNJO";
        Log.sql("[DaoMethod Call] JvProfTabFilterDao.selectCompanyAndRole");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, party);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, roleId);
            rs = pstmt.executeQuery();
            List<JvProfTabFilterDto> lst = new ArrayList<JvProfTabFilterDto>();
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

}

