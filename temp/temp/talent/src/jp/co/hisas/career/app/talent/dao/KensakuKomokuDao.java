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
import jp.co.hisas.career.app.talent.dto.KensakuKomokuDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class KensakuKomokuDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " KENSAKU_KOMOKU_ID as kensakuKomokuId,"
                     + " KENSAKU_KOMOKU_NAME as kensakuKomokuName,"
                     + " NYURYOKU_KETASU as nyuryokuKetasu,"
                     + " KENSAKU_TYPE as kensakuType,"
                     + " HYOJI_JYUNJYO as hyojiJyunjyo,"
                     + " KENSAKU_CATEGORY_ID as kensakuCategoryId,"
                     + " MASTER_ID as masterId,"
                     + " KENSAKU_TABLE_KUBUN as kensakuTableKubun,"
                     + " PERSON_ZOKUSEI_ID as personZokuseiId,"
                     + " PERSON_ZOKUSEI_KENSAKU_TYPE as personZokuseiKensakuType,"
                     + " PARTY as party,"
                     + " UPDATE_PERSON_ID as updatePersonId,"
                     + " UPDATE_FUNCTION as updateFunction,"
                     + " UPDATE_DATE as updateDate,"
                     + " UPDATE_TIME as updateTime"
                     ;

    public KensakuKomokuDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public KensakuKomokuDao(Connection conn) {
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

    public List<KensakuKomokuDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] KensakuKomokuDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<KensakuKomokuDto> lst = new ArrayList<KensakuKomokuDto>();
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

    public List<KensakuKomokuDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] KensakuKomokuDao.selectDynamic");
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

    private KensakuKomokuDto transferRsToDto(ResultSet rs) throws SQLException {

        KensakuKomokuDto dto = new KensakuKomokuDto();
        dto.setKensakuKomokuId(DaoUtil.convertNullToString(rs.getString("kensakuKomokuId")));
        dto.setKensakuKomokuName(DaoUtil.convertNullToString(rs.getString("kensakuKomokuName")));
        dto.setNyuryokuKetasu(rs.getInt("nyuryokuKetasu"));
        dto.setKensakuType(rs.getInt("kensakuType"));
        dto.setHyojiJyunjyo(rs.getInt("hyojiJyunjyo"));
        dto.setKensakuCategoryId(DaoUtil.convertNullToString(rs.getString("kensakuCategoryId")));
        dto.setMasterId(DaoUtil.convertNullToString(rs.getString("masterId")));
        dto.setKensakuTableKubun(DaoUtil.convertNullToString(rs.getString("kensakuTableKubun")));
        dto.setPersonZokuseiId(DaoUtil.convertNullToString(rs.getString("personZokuseiId")));
        dto.setPersonZokuseiKensakuType(rs.getInt("personZokuseiKensakuType"));
        dto.setParty(DaoUtil.convertNullToString(rs.getString("party")));
        dto.setUpdatePersonId(DaoUtil.convertNullToString(rs.getString("updatePersonId")));
        dto.setUpdateFunction(DaoUtil.convertNullToString(rs.getString("updateFunction")));
        dto.setUpdateDate(DaoUtil.convertNullToString(rs.getString("updateDate")));
        dto.setUpdateTime(DaoUtil.convertNullToString(rs.getString("updateTime")));
        return dto;
    }

}

