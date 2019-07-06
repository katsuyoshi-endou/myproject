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
import jp.co.hisas.career.app.talent.dto.VPzCValueDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class VPzCValueDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " PERSON_ID as personId,"
                     + " KENMU_NO as kenmuNo,"
                     + " PERSON_ZOKUSEI_ID as personZokuseiId,"
                     + " START_DATE as startDate,"
                     + " END_DATE as endDate,"
                     + " PERSON_ZOKUSEI_VALUE as personZokuseiValue,"
                     + " UPDATE_PERSON_ID as updatePersonId,"
                     + " UPDATE_FUNCTION as updateFunction,"
                     + " UPDATE_DATE as updateDate,"
                     + " UPDATE_TIME as updateTime"
                     ;

    public VPzCValueDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public VPzCValueDao(Connection conn) {
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

    public List<VPzCValueDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] VPzCValueDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<VPzCValueDto> lst = new ArrayList<VPzCValueDto>();
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

    public List<VPzCValueDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] VPzCValueDao.selectDynamic");
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

    private VPzCValueDto transferRsToDto(ResultSet rs) throws SQLException {

        VPzCValueDto dto = new VPzCValueDto();
        dto.setPersonId(DaoUtil.convertNullToString(rs.getString("personId")));
        dto.setKenmuNo(DaoUtil.convertNullToString(rs.getString("kenmuNo")));
        dto.setPersonZokuseiId(DaoUtil.convertNullToString(rs.getString("personZokuseiId")));
        dto.setStartDate(DaoUtil.convertNullToString(rs.getString("startDate")));
        dto.setEndDate(DaoUtil.convertNullToString(rs.getString("endDate")));
        dto.setPersonZokuseiValue(DaoUtil.convertNullToString(rs.getString("personZokuseiValue")));
        dto.setUpdatePersonId(DaoUtil.convertNullToString(rs.getString("updatePersonId")));
        dto.setUpdateFunction(DaoUtil.convertNullToString(rs.getString("updateFunction")));
        dto.setUpdateDate(DaoUtil.convertNullToString(rs.getString("updateDate")));
        dto.setUpdateTime(DaoUtil.convertNullToString(rs.getString("updateTime")));
        return dto;
    }

    public List<VPzCValueDto> selectKojinZokusei(String personId, String kenmuNo, String personZokuseiId, String startDate) {

        final String sql = "SELECT " + ALLCOLS + " FROM V_PZ_C_VALUE WHERE PERSON_ID=?  AND KENMU_NO=? AND PERSON_ZOKUSEI_ID=? AND TO_CHAR(TO_DATE(?, 'YYYY/MM/DD'), 'YYYY/MM/DD') BETWEEN TO_CHAR(TO_DATE(START_DATE, 'YYYY/MM/DD'), 'YYYY/MM/DD') AND TO_CHAR(TO_DATE(END_DATE, 'YYYY/MM/DD'), 'YYYY/MM/DD')"
                         + " "
                         ;
        Log.sql("[DaoMethod Call] VPzCValueDao.selectKojinZokusei");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, personId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, kenmuNo);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, personZokuseiId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, startDate);
            rs = pstmt.executeQuery();
            List<VPzCValueDto> lst = new ArrayList<VPzCValueDto>();
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

    public List<VPzCValueDto> selectKojinZokuseiAll(String personId, String kenmuNo, String startDate) {

        final String sql = "SELECT " + ALLCOLS + " FROM V_PZ_C_VALUE WHERE PERSON_ID=?  AND KENMU_NO=? AND TO_CHAR(TO_DATE(?, 'YYYY/MM/DD'), 'YYYY/MM/DD') BETWEEN TO_CHAR(TO_DATE(START_DATE, 'YYYY/MM/DD'), 'YYYY/MM/DD') AND TO_CHAR(TO_DATE(END_DATE, 'YYYY/MM/DD'), 'YYYY/MM/DD')"
                         + " "
                         ;
        Log.sql("[DaoMethod Call] VPzCValueDao.selectKojinZokuseiAll");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, personId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, kenmuNo);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, startDate);
            rs = pstmt.executeQuery();
            List<VPzCValueDto> lst = new ArrayList<VPzCValueDto>();
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

