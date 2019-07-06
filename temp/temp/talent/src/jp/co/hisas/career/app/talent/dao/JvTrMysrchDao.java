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
import jp.co.hisas.career.app.talent.dto.JvTrMysrchDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTrMysrchDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " MYSRCH_ID as mysrchId,"
                     + " MYSRCH_NM as mysrchNm,"
                     + " SHARED_FLG as sharedFlg,"
                     + " BIND_ONLY_FLG as bindOnlyFlg,"
                     + " MADE_BY as madeBy,"
                     + " MADE_AT as madeAt,"
                     + " UPD_BY as updBy,"
                     + " UPD_AT as updAt"
                     ;

    public JvTrMysrchDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTrMysrchDao(Connection conn) {
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

    public void insert(JvTrMysrchDto dto) {

        final String sql = "INSERT INTO JV_TR_MYSRCH ("
                         + "MYSRCH_ID,"
                         + "MYSRCH_NM,"
                         + "SHARED_FLG,"
                         + "BIND_ONLY_FLG,"
                         + "MADE_BY,"
                         + "MADE_AT,"
                         + "UPD_BY,"
                         + "UPD_AT"
                         + ")VALUES(?,?,?,?,?,?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getMysrchId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getMysrchNm());
            DaoUtil.setIntToPreparedStatement(pstmt, 3, dto.getSharedFlg());
            DaoUtil.setIntToPreparedStatement(pstmt, 4, dto.getBindOnlyFlg());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getMadeBy());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 6, dto.getMadeAt());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 7, dto.getUpdBy());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 8, dto.getUpdAt());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void update(JvTrMysrchDto dto) {

        final String sql = "UPDATE JV_TR_MYSRCH SET "
                         + "MYSRCH_NM = ?,"
                         + "SHARED_FLG = ?,"
                         + "BIND_ONLY_FLG = ?,"
                         + "MADE_BY = ?,"
                         + "MADE_AT = ?,"
                         + "UPD_BY = ?,"
                         + "UPD_AT = ?"
                         + " WHERE MYSRCH_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchDao.update");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getMysrchNm());
            DaoUtil.setIntToPreparedStatement(pstmt, 2, dto.getSharedFlg());
            DaoUtil.setIntToPreparedStatement(pstmt, 3, dto.getBindOnlyFlg());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getMadeBy());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getMadeAt());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 6, dto.getUpdBy());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 7, dto.getUpdAt());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 8, dto.getMysrchId());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void delete(String mysrchId) {

        final String sql = "DELETE FROM JV_TR_MYSRCH"
                         + " WHERE MYSRCH_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchDao.delete");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally { 
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvTrMysrchDto select(String mysrchId) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TR_MYSRCH"
                         + " WHERE MYSRCH_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMysrchDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            rs = pstmt.executeQuery();
            JvTrMysrchDto dto = null;
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

    public List<JvTrMysrchDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTrMysrchDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTrMysrchDto> lst = new ArrayList<JvTrMysrchDto>();
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

    public List<JvTrMysrchDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMysrchDao.selectDynamic");
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
            Log.sql("[DaoMethod Call] JvTrMysrchDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMysrchDao.executeDynamic");
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

    private JvTrMysrchDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTrMysrchDto dto = new JvTrMysrchDto();
        dto.setMysrchId(DaoUtil.convertNullToString(rs.getString("mysrchId")));
        dto.setMysrchNm(DaoUtil.convertNullToString(rs.getString("mysrchNm")));
        dto.setSharedFlg(rs.getInt("sharedFlg"));
        dto.setBindOnlyFlg(rs.getInt("bindOnlyFlg"));
        dto.setMadeBy(DaoUtil.convertNullToString(rs.getString("madeBy")));
        dto.setMadeAt(DaoUtil.convertNullToString(rs.getString("madeAt")));
        dto.setUpdBy(DaoUtil.convertNullToString(rs.getString("updBy")));
        dto.setUpdAt(DaoUtil.convertNullToString(rs.getString("updAt")));
        return dto;
    }

}

