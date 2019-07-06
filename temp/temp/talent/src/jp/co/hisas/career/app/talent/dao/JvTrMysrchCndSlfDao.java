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
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndSlfDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTrMysrchCndSlfDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " MYSRCH_ID as mysrchId,"
                     + " SECT_ID as sectId,"
                     + " KOMOKU_ID as komokuId,"
                     + " QUERY as query,"
                     + " KIGO_TYPE as kigoType"
                     ;

    public JvTrMysrchCndSlfDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTrMysrchCndSlfDao(Connection conn) {
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

    public void insert(JvTrMysrchCndSlfDto dto) {

        final String sql = "INSERT INTO JV_TR_MYSRCH_CND_SLF ("
                         + "MYSRCH_ID,"
                         + "SECT_ID,"
                         + "KOMOKU_ID,"
                         + "QUERY,"
                         + "KIGO_TYPE"
                         + ")VALUES(?,?,?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndSlfDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getMysrchId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getSectId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getKomokuId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getQuery());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getKigoType());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void update(JvTrMysrchCndSlfDto dto) {

        final String sql = "UPDATE JV_TR_MYSRCH_CND_SLF SET "
                         + "QUERY = ?,"
                         + "KIGO_TYPE = ?"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND SECT_ID = ?"
                         + " AND KOMOKU_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndSlfDao.update");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getQuery());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getKigoType());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getMysrchId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getSectId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getKomokuId());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void delete(String mysrchId, String sectId, String komokuId) {

        final String sql = "DELETE FROM JV_TR_MYSRCH_CND_SLF"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND SECT_ID = ?"
                         + " AND KOMOKU_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndSlfDao.delete");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, sectId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, komokuId);
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally { 
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvTrMysrchCndSlfDto select(String mysrchId, String sectId, String komokuId) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TR_MYSRCH_CND_SLF"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND SECT_ID = ?"
                         + " AND KOMOKU_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchCndSlfDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, sectId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, komokuId);
            rs = pstmt.executeQuery();
            JvTrMysrchCndSlfDto dto = null;
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

    public List<JvTrMysrchCndSlfDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTrMysrchCndSlfDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTrMysrchCndSlfDto> lst = new ArrayList<JvTrMysrchCndSlfDto>();
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

    public List<JvTrMysrchCndSlfDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMysrchCndSlfDao.selectDynamic");
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
            Log.sql("[DaoMethod Call] JvTrMysrchCndSlfDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMysrchCndSlfDao.executeDynamic");
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

    private JvTrMysrchCndSlfDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTrMysrchCndSlfDto dto = new JvTrMysrchCndSlfDto();
        dto.setMysrchId(DaoUtil.convertNullToString(rs.getString("mysrchId")));
        dto.setSectId(DaoUtil.convertNullToString(rs.getString("sectId")));
        dto.setKomokuId(DaoUtil.convertNullToString(rs.getString("komokuId")));
        dto.setQuery(DaoUtil.convertNullToString(rs.getString("query")));
        dto.setKigoType(DaoUtil.convertNullToString(rs.getString("kigoType")));
        return dto;
    }

}

