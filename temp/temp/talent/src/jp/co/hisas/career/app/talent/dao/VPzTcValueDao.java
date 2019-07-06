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
import jp.co.hisas.career.app.talent.dto.VPzTcValueDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class VPzTcValueDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " PERSON_ID as personId,"
                     + " KENMU_NO as kenmuNo,"
                     + " PERSON_ZOKUSEI_ID as personZokuseiId,"
                     + " ROW_NO as rowNo,"
                     + " PERSON_ZOKUSEI_VALUE as personZokuseiValue,"
                     + " UPDATE_PERSON_ID as updatePersonId,"
                     + " UPDATE_FUNCTION as updateFunction,"
                     + " UPDATE_DATE as updateDate,"
                     + " UPDATE_TIME as updateTime"
                     ;

    public VPzTcValueDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public VPzTcValueDao(Connection conn) {
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

    public List<VPzTcValueDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] VPzTcValueDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<VPzTcValueDto> lst = new ArrayList<VPzTcValueDto>();
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

    public List<VPzTcValueDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] VPzTcValueDao.selectDynamic");
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

    private VPzTcValueDto transferRsToDto(ResultSet rs) throws SQLException {

        VPzTcValueDto dto = new VPzTcValueDto();
        dto.setPersonId(DaoUtil.convertNullToString(rs.getString("personId")));
        dto.setKenmuNo(DaoUtil.convertNullToString(rs.getString("kenmuNo")));
        dto.setPersonZokuseiId(DaoUtil.convertNullToString(rs.getString("personZokuseiId")));
        dto.setRowNo(rs.getInt("rowNo"));
        dto.setPersonZokuseiValue(DaoUtil.convertNullToString(rs.getString("personZokuseiValue")));
        dto.setUpdatePersonId(DaoUtil.convertNullToString(rs.getString("updatePersonId")));
        dto.setUpdateFunction(DaoUtil.convertNullToString(rs.getString("updateFunction")));
        dto.setUpdateDate(DaoUtil.convertNullToString(rs.getString("updateDate")));
        dto.setUpdateTime(DaoUtil.convertNullToString(rs.getString("updateTime")));
        return dto;
    }

}

