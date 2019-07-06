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
import jp.co.hisas.career.app.talent.dto.KensakuKigoDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class KensakuKigoDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " KENSAKU_KOMOKU_ID as kensakuKomokuId,"
                     + " HYOJI_JYUNJYO as hyojiJyunjyo,"
                     + " HYOJI_NAME as hyojiName,"
                     + " KIGO_TYPE as kigoType,"
                     + " UPDATE_PERSON_ID as updatePersonId,"
                     + " UPDATE_FUNCTION as updateFunction,"
                     + " UPDATE_DATE as updateDate,"
                     + " UPDATE_TIME as updateTime"
                     ;

    public KensakuKigoDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public KensakuKigoDao(Connection conn) {
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

    private KensakuKigoDto transferRsToDto(ResultSet rs) throws SQLException {

        KensakuKigoDto dto = new KensakuKigoDto();
        dto.setKensakuKomokuId(DaoUtil.convertNullToString(rs.getString("kensakuKomokuId")));
        dto.setHyojiJyunjyo(rs.getInt("hyojiJyunjyo"));
        dto.setHyojiName(DaoUtil.convertNullToString(rs.getString("hyojiName")));
        dto.setKigoType(DaoUtil.convertNullToString(rs.getString("kigoType")));
        dto.setUpdatePersonId(DaoUtil.convertNullToString(rs.getString("updatePersonId")));
        dto.setUpdateFunction(DaoUtil.convertNullToString(rs.getString("updateFunction")));
        dto.setUpdateDate(DaoUtil.convertNullToString(rs.getString("updateDate")));
        dto.setUpdateTime(DaoUtil.convertNullToString(rs.getString("updateTime")));
        return dto;
    }

    public List<KensakuKigoDto> selectKensakuKigoAll() {

        final String sql = "SELECT " + ALLCOLS + " FROM KENSAKU_KIGO ORDER BY HYOJI_JYUNJYO";
        Log.sql("[DaoMethod Call] KensakuKigoDao.selectKensakuKigoAll");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            List<KensakuKigoDto> lst = new ArrayList<KensakuKigoDto>();
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

