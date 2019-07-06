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
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTrMyfoldDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " MYFOLD_ID as myfoldId,"
                     + " MYFOLD_NM as myfoldNm,"
                     + " SHARED_FLG as sharedFlg,"
                     + " BIND_ONLY_FLG as bindOnlyFlg,"
                     + " MADE_BY as madeBy,"
                     + " MADE_AT as madeAt,"
                     + " UPD_BY as updBy,"
                     + " UPD_AT as updAt"
                     ;

    public JvTrMyfoldDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTrMyfoldDao(Connection conn) {
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

    public void insert(JvTrMyfoldDto dto) {

        final String sql = "INSERT INTO JV_TR_MYFOLD ("
                         + "MYFOLD_ID,"
                         + "MYFOLD_NM,"
                         + "SHARED_FLG,"
                         + "BIND_ONLY_FLG,"
                         + "MADE_BY,"
                         + "MADE_AT,"
                         + "UPD_BY,"
                         + "UPD_AT"
                         + ")VALUES(?,?,?,?,?,?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getMyfoldId());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getMyfoldNm());
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

    public void update(JvTrMyfoldDto dto) {

        final String sql = "UPDATE JV_TR_MYFOLD SET "
                         + "MYFOLD_NM = ?,"
                         + "SHARED_FLG = ?,"
                         + "BIND_ONLY_FLG = ?,"
                         + "MADE_BY = ?,"
                         + "MADE_AT = ?,"
                         + "UPD_BY = ?,"
                         + "UPD_AT = ?"
                         + " WHERE MYFOLD_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldDao.update");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getMyfoldNm());
            DaoUtil.setIntToPreparedStatement(pstmt, 2, dto.getSharedFlg());
            DaoUtil.setIntToPreparedStatement(pstmt, 3, dto.getBindOnlyFlg());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getMadeBy());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getMadeAt());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 6, dto.getUpdBy());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 7, dto.getUpdAt());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 8, dto.getMyfoldId());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void delete(String myfoldId) {

        final String sql = "DELETE FROM JV_TR_MYFOLD"
                         + " WHERE MYFOLD_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldDao.delete");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, myfoldId);
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally { 
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvTrMyfoldDto select(String myfoldId) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TR_MYFOLD"
                         + " WHERE MYFOLD_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, myfoldId);
            rs = pstmt.executeQuery();
            JvTrMyfoldDto dto = null;
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

    public List<JvTrMyfoldDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTrMyfoldDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTrMyfoldDto> lst = new ArrayList<JvTrMyfoldDto>();
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

    public List<JvTrMyfoldDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMyfoldDao.selectDynamic");
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
            Log.sql("[DaoMethod Call] JvTrMyfoldDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMyfoldDao.executeDynamic");
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

    private JvTrMyfoldDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTrMyfoldDto dto = new JvTrMyfoldDto();
        dto.setMyfoldId(DaoUtil.convertNullToString(rs.getString("myfoldId")));
        dto.setMyfoldNm(DaoUtil.convertNullToString(rs.getString("myfoldNm")));
        dto.setSharedFlg(rs.getInt("sharedFlg"));
        dto.setBindOnlyFlg(rs.getInt("bindOnlyFlg"));
        dto.setMadeBy(DaoUtil.convertNullToString(rs.getString("madeBy")));
        dto.setMadeAt(DaoUtil.convertNullToString(rs.getString("madeAt")));
        dto.setUpdBy(DaoUtil.convertNullToString(rs.getString("updBy")));
        dto.setUpdAt(DaoUtil.convertNullToString(rs.getString("updAt")));
        return dto;
    }

}

