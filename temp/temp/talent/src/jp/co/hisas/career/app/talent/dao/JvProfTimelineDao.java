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
import jp.co.hisas.career.app.talent.dto.JvProfTimelineDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvProfTimelineDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " CMPA_CD as cmpaCd,"
                     + " STF_NO as stfNo,"
                     + " SEQ_NO as seqNo,"
                     + " TL_DATE as tlDate,"
                     + " TL_PTN_CD as tlPtnCd,"
                     + " TITLE as title,"
                     + " NOTE as note"
                     ;

    public JvProfTimelineDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvProfTimelineDao(Connection conn) {
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

    public JvProfTimelineDto select() {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_PROF_TIMELINE"
                         + " WHERE "
                         ;
        Log.sql("[DaoMethod Call] JvProfTimelineDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            JvProfTimelineDto dto = null;
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

    public List<JvProfTimelineDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvProfTimelineDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvProfTimelineDto> lst = new ArrayList<JvProfTimelineDto>();
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

    public List<JvProfTimelineDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvProfTimelineDao.selectDynamic");
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

    private JvProfTimelineDto transferRsToDto(ResultSet rs) throws SQLException {

        JvProfTimelineDto dto = new JvProfTimelineDto();
        dto.setCmpaCd(DaoUtil.convertNullToString(rs.getString("cmpaCd")));
        dto.setStfNo(DaoUtil.convertNullToString(rs.getString("stfNo")));
        dto.setSeqNo(rs.getInt("seqNo"));
        dto.setTlDate(DaoUtil.convertNullToString(rs.getString("tlDate")));
        dto.setTlPtnCd(DaoUtil.convertNullToString(rs.getString("tlPtnCd")));
        dto.setTitle(DaoUtil.convertNullToString(rs.getString("title")));
        dto.setNote(DaoUtil.convertNullToString(rs.getString("note")));
        return dto;
    }

}

