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
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldLogDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvTrMyfoldLogDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " MYSRCH_ID as mysrchId,"
                     + " MYSRCH_NM as mysrchNm,"
                     + " SHARED_FLG as sharedFlg,"
                     + " BIND_ONLY_FLG as bindOnlyFlg,"
                     + " MADE_BY as madeBy,"
                     + " MADE_AT as madeAt"
                     ;

    public JvTrMyfoldLogDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvTrMyfoldLogDao(Connection conn) {
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

    public void insert(JvTrMyfoldLogDto dto) {

        final String sql = "INSERT INTO JV_TR_MYFOLD_LOG ("
                         + "MYSRCH_ID,"
                         + "MYSRCH_NM,"
                         + "SHARED_FLG,"
                         + "BIND_ONLY_FLG,"
                         + "MADE_BY,"
                         + "MADE_AT"
                         + ")VALUES(?,?,?,?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldLogDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getMysrchId());
            DaoUtil.setIntToPreparedStatement(pstmt, 2, dto.getMysrchNm());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getSharedFlg());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getBindOnlyFlg());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getMadeBy());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 6, dto.getMadeAt());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void update(JvTrMyfoldLogDto dto) {

        final String sql = "UPDATE JV_TR_MYFOLD_LOG SET "
                         + "SHARED_FLG = ?,"
                         + "BIND_ONLY_FLG = ?,"
                         + "MADE_BY = ?,"
                         + "MADE_AT = ?"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND MYSRCH_NM = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldLogDao.update");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getSharedFlg());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getBindOnlyFlg());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getMadeBy());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getMadeAt());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getMysrchId());
            DaoUtil.setIntToPreparedStatement(pstmt, 6, dto.getMysrchNm());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void delete(String mysrchId, Integer mysrchNm) {

        final String sql = "DELETE FROM JV_TR_MYFOLD_LOG"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND MYSRCH_NM = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldLogDao.delete");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            DaoUtil.setIntToPreparedStatement(pstmt, 2, mysrchNm);
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally { 
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvTrMyfoldLogDto select(String mysrchId, Integer mysrchNm) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_TR_MYFOLD_LOG"
                         + " WHERE MYSRCH_ID = ?"
                         + " AND MYSRCH_NM = ?"
                         ;
        Log.sql("[DaoMethod Call] JvTrMyfoldLogDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, mysrchId);
            DaoUtil.setIntToPreparedStatement(pstmt, 2, mysrchNm);
            rs = pstmt.executeQuery();
            JvTrMyfoldLogDto dto = null;
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

    public List<JvTrMyfoldLogDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvTrMyfoldLogDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvTrMyfoldLogDto> lst = new ArrayList<JvTrMyfoldLogDto>();
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

    public List<JvTrMyfoldLogDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMyfoldLogDao.selectDynamic");
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
            Log.sql("[DaoMethod Call] JvTrMyfoldLogDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvTrMyfoldLogDao.executeDynamic");
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

    private JvTrMyfoldLogDto transferRsToDto(ResultSet rs) throws SQLException {

        JvTrMyfoldLogDto dto = new JvTrMyfoldLogDto();
        dto.setMysrchId(DaoUtil.convertNullToString(rs.getString("mysrchId")));
        dto.setMysrchNm(rs.getInt("mysrchNm"));
        dto.setSharedFlg(DaoUtil.convertNullToString(rs.getString("sharedFlg")));
        dto.setBindOnlyFlg(DaoUtil.convertNullToString(rs.getString("bindOnlyFlg")));
        dto.setMadeBy(DaoUtil.convertNullToString(rs.getString("madeBy")));
        dto.setMadeAt(DaoUtil.convertNullToString(rs.getString("madeAt")));
        return dto;
    }

}

