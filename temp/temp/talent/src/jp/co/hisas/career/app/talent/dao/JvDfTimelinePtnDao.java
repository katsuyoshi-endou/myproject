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
import jp.co.hisas.career.app.talent.dto.JvDfTimelinePtnDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvDfTimelinePtnDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " TL_PTN_CD as tlPtnCd,"
                     + " ICON as icon,"
                     + " COLOR as color,"
                     + " LABEL as label"
                     ;

    public JvDfTimelinePtnDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvDfTimelinePtnDao(Connection conn) {
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

    public JvDfTimelinePtnDto select(String tlPtnCd) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_DF_TIMELINE_PTN"
                         + " WHERE TL_PTN_CD = ?"
                         ;
        Log.sql("[DaoMethod Call] JvDfTimelinePtnDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, tlPtnCd);
            rs = pstmt.executeQuery();
            JvDfTimelinePtnDto dto = null;
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

    public List<JvDfTimelinePtnDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvDfTimelinePtnDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvDfTimelinePtnDto> lst = new ArrayList<JvDfTimelinePtnDto>();
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

    public List<JvDfTimelinePtnDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvDfTimelinePtnDao.selectDynamic");
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

    private JvDfTimelinePtnDto transferRsToDto(ResultSet rs) throws SQLException {

        JvDfTimelinePtnDto dto = new JvDfTimelinePtnDto();
        dto.setTlPtnCd(DaoUtil.convertNullToString(rs.getString("tlPtnCd")));
        dto.setIcon(DaoUtil.convertNullToString(rs.getString("icon")));
        dto.setColor(DaoUtil.convertNullToString(rs.getString("color")));
        dto.setLabel(DaoUtil.convertNullToString(rs.getString("label")));
        return dto;
    }

}
