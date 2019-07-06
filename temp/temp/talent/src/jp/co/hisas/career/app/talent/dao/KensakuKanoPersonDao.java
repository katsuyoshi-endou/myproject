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
import jp.co.hisas.career.app.talent.dto.KensakuKanoPersonDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class KensakuKanoPersonDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " PERSON_ID as personId,"
                     + " TGT_PERSON_ID as tgtPersonId,"
                     + " TGT_KENMU_NO as tgtKenmuNo,"
                     + " TGT_SOSIKI_CODE as tgtSosikiCode,"
                     + " ROLE_ID as roleId"
                     ;

    public KensakuKanoPersonDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public KensakuKanoPersonDao(Connection conn) {
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

    public KensakuKanoPersonDto select(String personId, String tgtPersonId, Integer tgtKenmuNo, String tgtSosikiCode) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM KENSAKU_KANO_PERSON"
                         + " WHERE PERSON_ID = ?"
                         + " AND TGT_PERSON_ID = ?"
                         + " AND TGT_KENMU_NO = ?"
                         + " AND TGT_SOSIKI_CODE = ?"
                         ;
        Log.sql("[DaoMethod Call] KensakuKanoPersonDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, personId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, tgtPersonId);
            DaoUtil.setIntToPreparedStatement(pstmt, 3, tgtKenmuNo);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, tgtSosikiCode);
            rs = pstmt.executeQuery();
            KensakuKanoPersonDto dto = null;
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

    private KensakuKanoPersonDto transferRsToDto(ResultSet rs) throws SQLException {

        KensakuKanoPersonDto dto = new KensakuKanoPersonDto();
        dto.setPersonId(DaoUtil.convertNullToString(rs.getString("personId")));
        dto.setTgtPersonId(DaoUtil.convertNullToString(rs.getString("tgtPersonId")));
        dto.setTgtKenmuNo(rs.getInt("tgtKenmuNo"));
        dto.setTgtSosikiCode(DaoUtil.convertNullToString(rs.getString("tgtSosikiCode")));
        dto.setRoleId(DaoUtil.convertNullToString(rs.getString("roleId")));
        return dto;
    }

    public List<KensakuKanoPersonDto> selectKensakuKanoPersonByPersonId(String personId) {

        final String sql = "SELECT " + ALLCOLS + ""
                         + " FROM KENSAKU_KANO_PERSON"
                         + " WHERE PERSON_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] KensakuKanoPersonDao.selectKensakuKanoPersonByPersonId");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, personId);
            rs = pstmt.executeQuery();
            List<KensakuKanoPersonDto> lst = new ArrayList<KensakuKanoPersonDto>();
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

    public List<KensakuKanoPersonDto> selectKensakuKanoPersonByTgtPersonId(String personId, String tgtPersonId, String tgtCompanyCode) {

        final String sql = "SELECT " + ALLCOLS + ""
                         + " FROM KENSAKU_KANO_PERSON"
                         + " WHERE PERSON_ID = ?"
                         + " AND TGT_PERSON_ID = ?"
                         + " AND TGT_SOSIKI_CODE = ?"
                         ;
        Log.sql("[DaoMethod Call] KensakuKanoPersonDao.selectKensakuKanoPersonByTgtPersonId");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, personId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, tgtPersonId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, tgtCompanyCode);
            rs = pstmt.executeQuery();
            List<KensakuKanoPersonDto> lst = new ArrayList<KensakuKanoPersonDto>();
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

    public List<KensakuKanoPersonDto> selectKensakuKanoPersonByTgtPersonIdAndTgtKenmuNo(String personId, String tgtPersonId, Integer tgtKenmuNo) {

        final String sql = "SELECT " + ALLCOLS + ""
                         + " FROM KENSAKU_KANO_PERSON"
                         + " WHERE PERSON_ID = ?"
                         + " AND TGT_PERSON_ID = ?"
                         + " AND TGT_KENMU_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] KensakuKanoPersonDao.selectKensakuKanoPersonByTgtPersonIdAndTgtKenmuNo");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, personId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, tgtPersonId);
            DaoUtil.setIntToPreparedStatement(pstmt, 3, tgtKenmuNo);
            rs = pstmt.executeQuery();
            List<KensakuKanoPersonDto> lst = new ArrayList<KensakuKanoPersonDto>();
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

