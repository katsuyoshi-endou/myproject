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
import jp.co.hisas.career.app.talent.dto.KensakuCategoryDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class KensakuCategoryDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " KENSAKU_CATEGORY_ID as kensakuCategoryId,"
                     + " KENSAKU_CATEGORY_NAME as kensakuCategoryName,"
                     + " HYOJI_JYUNJYO as hyojiJyunjyo,"
                     + " KENGEN_ID as kengenId,"
                     + " PARTY as party,"
                     + " UPDATE_PERSON_ID as updatePersonId,"
                     + " UPDATE_FUNCTION as updateFunction,"
                     + " UPDATE_DATE as updateDate,"
                     + " UPDATE_TIME as updateTime"
                     ;

    public KensakuCategoryDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public KensakuCategoryDao(Connection conn) {
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

    public List<KensakuCategoryDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] KensakuCategoryDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<KensakuCategoryDto> lst = new ArrayList<KensakuCategoryDto>();
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

    public List<KensakuCategoryDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] KensakuCategoryDao.selectDynamic");
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

    private KensakuCategoryDto transferRsToDto(ResultSet rs) throws SQLException {

        KensakuCategoryDto dto = new KensakuCategoryDto();
        dto.setKensakuCategoryId(DaoUtil.convertNullToString(rs.getString("kensakuCategoryId")));
        dto.setKensakuCategoryName(DaoUtil.convertNullToString(rs.getString("kensakuCategoryName")));
        dto.setHyojiJyunjyo(rs.getInt("hyojiJyunjyo"));
        dto.setKengenId(DaoUtil.convertNullToString(rs.getString("kengenId")));
        dto.setParty(DaoUtil.convertNullToString(rs.getString("party")));
        dto.setUpdatePersonId(DaoUtil.convertNullToString(rs.getString("updatePersonId")));
        dto.setUpdateFunction(DaoUtil.convertNullToString(rs.getString("updateFunction")));
        dto.setUpdateDate(DaoUtil.convertNullToString(rs.getString("updateDate")));
        dto.setUpdateTime(DaoUtil.convertNullToString(rs.getString("updateTime")));
        return dto;
    }

}

