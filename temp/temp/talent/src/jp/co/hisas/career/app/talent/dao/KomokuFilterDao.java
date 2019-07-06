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

import jp.co.hisas.career.app.talent.dto.KomokuFilterDto;
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log;

public class KomokuFilterDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " PARTY as party,"
                     + " ROLE_ID as roleId,"
                     + " KOMOKU_ID as komokuId,"
                     + " DISPLAY_MODE as displayMode"
                     ;

    public KomokuFilterDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public KomokuFilterDao(Connection conn) {
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

    public KomokuFilterDto select(String party, String roleId, String komokuId) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_PROF_KOMOKU_FILTER"
                         + " WHERE PARTY = ?"
                         + " AND ROLE_ID = ?"
                         + " AND KOMOKU_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] KomokuFilterDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, party);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, roleId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, komokuId);
            rs = pstmt.executeQuery();
            KomokuFilterDto dto = null;
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

    public List<KomokuFilterDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] KomokuFilterDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<KomokuFilterDto> lst = new ArrayList<KomokuFilterDto>();
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

    public List<KomokuFilterDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] KomokuFilterDao.selectDynamic");
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

    private KomokuFilterDto transferRsToDto(ResultSet rs) throws SQLException {

        KomokuFilterDto dto = new KomokuFilterDto();
        dto.setParty(DaoUtil.convertNullToString(rs.getString("party")));
        dto.setRoleId(DaoUtil.convertNullToString(rs.getString("roleId")));
        dto.setKomokuId(DaoUtil.convertNullToString(rs.getString("komokuId")));
        dto.setDisplayMode(DaoUtil.convertNullToString(rs.getString("displayMode")));
        return dto;
    }

    public List<KomokuFilterDto> selectCompanyAndRole(String party, String roleId) {

        final String sql = "SELECT " + ALLCOLS + " FROM JV_PROF_KOMOKU_FILTER WHERE PARTY=? AND ROLE_ID=?";
        Log.sql("[DaoMethod Call] KomokuFilterDao.selectCompanyAndRole");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, party);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, roleId);
            rs = pstmt.executeQuery();
            List<KomokuFilterDto> lst = new ArrayList<KomokuFilterDto>();
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

