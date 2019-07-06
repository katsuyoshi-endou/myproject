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
import jp.co.hisas.career.app.talent.dto.JvSrchRsltListDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvSrchRsltListDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " CMPA_CD as cmpaCd,"
                     + " STF_NO as stfNo,"
                     + " ITEM_01 as item01,"
                     + " ITEM_02 as item02,"
                     + " ITEM_03 as item03,"
                     + " ITEM_04 as item04,"
                     + " ITEM_05 as item05,"
                     + " ITEM_06 as item06,"
                     + " ITEM_07 as item07,"
                     + " ITEM_08 as item08,"
                     + " ITEM_09 as item09,"
                     + " ITEM_10 as item10,"
                     + " ITEM_11 as item11,"
                     + " ITEM_12 as item12,"
                     + " ITEM_13 as item13,"
                     + " ITEM_14 as item14,"
                     + " ITEM_15 as item15,"
                     + " ITEM_16 as item16,"
                     + " ITEM_17 as item17,"
                     + " ITEM_18 as item18,"
                     + " ITEM_19 as item19,"
                     + " ITEM_20 as item20,"
                     + " ITEM_21 as item21,"
                     + " ITEM_22 as item22,"
                     + " ITEM_23 as item23,"
                     + " ITEM_24 as item24,"
                     + " ITEM_25 as item25,"
                     + " ITEM_26 as item26,"
                     + " ITEM_27 as item27,"
                     + " ITEM_28 as item28,"
                     + " ITEM_29 as item29,"
                     + " ITEM_30 as item30,"
                     + " ITEM_31 as item31,"
                     + " ITEM_32 as item32,"
                     + " ITEM_33 as item33,"
                     + " ITEM_34 as item34,"
                     + " ITEM_35 as item35,"
                     + " ITEM_36 as item36,"
                     + " ITEM_37 as item37,"
                     + " ITEM_38 as item38,"
                     + " ITEM_39 as item39,"
                     + " ITEM_40 as item40,"
                     + " ITEM_41 as item41,"
                     + " ITEM_42 as item42,"
                     + " ITEM_43 as item43,"
                     + " ITEM_44 as item44,"
                     + " ITEM_45 as item45,"
                     + " ITEM_46 as item46,"
                     + " ITEM_47 as item47,"
                     + " ITEM_48 as item48,"
                     + " ITEM_49 as item49,"
                     + " ITEM_50 as item50,"
                     + " ITEM_51 as item51,"
                     + " ITEM_52 as item52,"
                     + " ITEM_53 as item53,"
                     + " ITEM_54 as item54,"
                     + " ITEM_55 as item55,"
                     + " ITEM_56 as item56,"
                     + " ITEM_57 as item57,"
                     + " ITEM_58 as item58,"
                     + " ITEM_59 as item59,"
                     + " ITEM_60 as item60"
                     ;

    public JvSrchRsltListDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvSrchRsltListDao(Connection conn) {
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

    public void insert(JvSrchRsltListDto dto) {

        final String sql = "INSERT INTO JV_SRCH_RSLT_LIST ("
                         + "CMPA_CD,"
                         + "STF_NO,"
                         + "ITEM_01,"
                         + "ITEM_02,"
                         + "ITEM_03,"
                         + "ITEM_04,"
                         + "ITEM_05,"
                         + "ITEM_06,"
                         + "ITEM_07,"
                         + "ITEM_08,"
                         + "ITEM_09,"
                         + "ITEM_10,"
                         + "ITEM_11,"
                         + "ITEM_12,"
                         + "ITEM_13,"
                         + "ITEM_14,"
                         + "ITEM_15,"
                         + "ITEM_16,"
                         + "ITEM_17,"
                         + "ITEM_18,"
                         + "ITEM_19,"
                         + "ITEM_20,"
                         + "ITEM_21,"
                         + "ITEM_22,"
                         + "ITEM_23,"
                         + "ITEM_24,"
                         + "ITEM_25,"
                         + "ITEM_26,"
                         + "ITEM_27,"
                         + "ITEM_28,"
                         + "ITEM_29,"
                         + "ITEM_30,"
                         + "ITEM_31,"
                         + "ITEM_32,"
                         + "ITEM_33,"
                         + "ITEM_34,"
                         + "ITEM_35,"
                         + "ITEM_36,"
                         + "ITEM_37,"
                         + "ITEM_38,"
                         + "ITEM_39,"
                         + "ITEM_40,"
                         + "ITEM_41,"
                         + "ITEM_42,"
                         + "ITEM_43,"
                         + "ITEM_44,"
                         + "ITEM_45,"
                         + "ITEM_46,"
                         + "ITEM_47,"
                         + "ITEM_48,"
                         + "ITEM_49,"
                         + "ITEM_50,"
                         + "ITEM_51,"
                         + "ITEM_52,"
                         + "ITEM_53,"
                         + "ITEM_54,"
                         + "ITEM_55,"
                         + "ITEM_56,"
                         + "ITEM_57,"
                         + "ITEM_58,"
                         + "ITEM_59,"
                         + "ITEM_60"
                         + ")VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? )"
                         ;
        Log.sql("[DaoMethod Call] JvSrchRsltListDao.insert");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getCmpaCd());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getStfNo());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getItem01());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getItem02());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getItem03());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 6, dto.getItem04());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 7, dto.getItem05());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 8, dto.getItem06());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 9, dto.getItem07());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 10, dto.getItem08());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 11, dto.getItem09());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 12, dto.getItem10());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 13, dto.getItem11());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 14, dto.getItem12());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 15, dto.getItem13());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 16, dto.getItem14());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 17, dto.getItem15());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 18, dto.getItem16());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 19, dto.getItem17());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 20, dto.getItem18());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 21, dto.getItem19());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 22, dto.getItem20());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 23, dto.getItem21());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 24, dto.getItem22());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 25, dto.getItem23());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 26, dto.getItem24());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 27, dto.getItem25());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 28, dto.getItem26());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 29, dto.getItem27());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 30, dto.getItem28());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 31, dto.getItem29());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 32, dto.getItem30());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 33, dto.getItem31());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 34, dto.getItem32());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 35, dto.getItem33());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 36, dto.getItem34());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 37, dto.getItem35());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 38, dto.getItem36());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 39, dto.getItem37());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 40, dto.getItem38());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 41, dto.getItem39());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 42, dto.getItem40());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 43, dto.getItem41());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 44, dto.getItem42());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 45, dto.getItem43());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 46, dto.getItem44());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 47, dto.getItem45());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 48, dto.getItem46());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 49, dto.getItem47());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 50, dto.getItem48());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 51, dto.getItem49());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 52, dto.getItem50());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 53, dto.getItem51());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 54, dto.getItem52());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 55, dto.getItem53());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 56, dto.getItem54());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 57, dto.getItem55());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 58, dto.getItem56());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 59, dto.getItem57());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 60, dto.getItem58());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 61, dto.getItem59());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 62, dto.getItem60());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void update(JvSrchRsltListDto dto) {

        final String sql = "UPDATE JV_SRCH_RSLT_LIST SET "
                         + "ITEM_01 = ?,"
                         + "ITEM_02 = ?,"
                         + "ITEM_03 = ?,"
                         + "ITEM_04 = ?,"
                         + "ITEM_05 = ?,"
                         + "ITEM_06 = ?,"
                         + "ITEM_07 = ?,"
                         + "ITEM_08 = ?,"
                         + "ITEM_09 = ?,"
                         + "ITEM_10 = ?,"
                         + "ITEM_11 = ?,"
                         + "ITEM_12 = ?,"
                         + "ITEM_13 = ?,"
                         + "ITEM_14 = ?,"
                         + "ITEM_15 = ?,"
                         + "ITEM_16 = ?,"
                         + "ITEM_17 = ?,"
                         + "ITEM_18 = ?,"
                         + "ITEM_19 = ?,"
                         + "ITEM_20 = ?,"
                         + "ITEM_21 = ?,"
                         + "ITEM_22 = ?,"
                         + "ITEM_23 = ?,"
                         + "ITEM_24 = ?,"
                         + "ITEM_25 = ?,"
                         + "ITEM_26 = ?,"
                         + "ITEM_27 = ?,"
                         + "ITEM_28 = ?,"
                         + "ITEM_29 = ?,"
                         + "ITEM_30 = ?,"
                         + "ITEM_31 = ?,"
                         + "ITEM_32 = ?,"
                         + "ITEM_33 = ?,"
                         + "ITEM_34 = ?,"
                         + "ITEM_35 = ?,"
                         + "ITEM_36 = ?,"
                         + "ITEM_37 = ?,"
                         + "ITEM_38 = ?,"
                         + "ITEM_39 = ?,"
                         + "ITEM_40 = ?,"
                         + "ITEM_41 = ?,"
                         + "ITEM_42 = ?,"
                         + "ITEM_43 = ?,"
                         + "ITEM_44 = ?,"
                         + "ITEM_45 = ?,"
                         + "ITEM_46 = ?,"
                         + "ITEM_47 = ?,"
                         + "ITEM_48 = ?,"
                         + "ITEM_49 = ?,"
                         + "ITEM_50 = ?,"
                         + "ITEM_51 = ?,"
                         + "ITEM_52 = ?,"
                         + "ITEM_53 = ?,"
                         + "ITEM_54 = ?,"
                         + "ITEM_55 = ?,"
                         + "ITEM_56 = ?,"
                         + "ITEM_57 = ?,"
                         + "ITEM_58 = ?,"
                         + "ITEM_59 = ?,"
                         + "ITEM_60 = ?"
                         + " WHERE CMPA_CD = ?"
                         + " AND STF_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvSrchRsltListDao.update");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, dto.getItem01());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, dto.getItem02());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 3, dto.getItem03());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 4, dto.getItem04());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 5, dto.getItem05());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 6, dto.getItem06());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 7, dto.getItem07());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 8, dto.getItem08());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 9, dto.getItem09());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 10, dto.getItem10());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 11, dto.getItem11());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 12, dto.getItem12());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 13, dto.getItem13());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 14, dto.getItem14());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 15, dto.getItem15());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 16, dto.getItem16());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 17, dto.getItem17());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 18, dto.getItem18());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 19, dto.getItem19());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 20, dto.getItem20());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 21, dto.getItem21());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 22, dto.getItem22());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 23, dto.getItem23());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 24, dto.getItem24());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 25, dto.getItem25());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 26, dto.getItem26());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 27, dto.getItem27());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 28, dto.getItem28());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 29, dto.getItem29());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 30, dto.getItem30());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 31, dto.getItem31());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 32, dto.getItem32());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 33, dto.getItem33());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 34, dto.getItem34());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 35, dto.getItem35());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 36, dto.getItem36());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 37, dto.getItem37());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 38, dto.getItem38());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 39, dto.getItem39());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 40, dto.getItem40());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 41, dto.getItem41());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 42, dto.getItem42());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 43, dto.getItem43());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 44, dto.getItem44());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 45, dto.getItem45());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 46, dto.getItem46());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 47, dto.getItem47());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 48, dto.getItem48());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 49, dto.getItem49());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 50, dto.getItem50());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 51, dto.getItem51());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 52, dto.getItem52());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 53, dto.getItem53());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 54, dto.getItem54());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 55, dto.getItem55());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 56, dto.getItem56());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 57, dto.getItem57());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 58, dto.getItem58());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 59, dto.getItem59());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 60, dto.getItem60());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 61, dto.getCmpaCd());
            DaoUtil.setVarcharToPreparedStatement(pstmt, 62, dto.getStfNo());
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void delete(String cmpaCd, String stfNo) {

        final String sql = "DELETE FROM JV_SRCH_RSLT_LIST"
                         + " WHERE CMPA_CD = ?"
                         + " AND STF_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvSrchRsltListDao.delete");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, cmpaCd);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, stfNo);
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally { 
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public JvSrchRsltListDto select(String cmpaCd, String stfNo) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_SRCH_RSLT_LIST"
                         + " WHERE CMPA_CD = ?"
                         + " AND STF_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvSrchRsltListDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, cmpaCd);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, stfNo);
            rs = pstmt.executeQuery();
            JvSrchRsltListDto dto = null;
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

    public List<JvSrchRsltListDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvSrchRsltListDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvSrchRsltListDto> lst = new ArrayList<JvSrchRsltListDto>();
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

    public List<JvSrchRsltListDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvSrchRsltListDao.selectDynamic");
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

    public int selectCountDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvSrchRsltListDao.selectCountDynamic");
        ResultSet rs = null;
        int cnt = 0;
        try {
            rs = pstmt.executeQuery();
            if ( rs.next() ) {
                cnt = rs.getInt(1);
            }
            return cnt;
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, rs);
        }
    }

    public int selectCountDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvSrchRsltListDao.selectCountDynamic");
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            return selectCountDynamic(pstmt);
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(PreparedStatement pstmt) {
        try {
            Log.sql("[DaoMethod Call] JvSrchRsltListDao.executeDynamic");
            pstmt.executeUpdate();
        } catch (final SQLException e) {
            Log.error(loginNo, e);
            throw new CareerSQLException(e);
        } finally {
            PZZ040_SQLUtility.closeConnection(loginNo, null, pstmt, null);
        }
    }

    public void executeDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvSrchRsltListDao.executeDynamic");
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

    private JvSrchRsltListDto transferRsToDto(ResultSet rs) throws SQLException {

        JvSrchRsltListDto dto = new JvSrchRsltListDto();
        dto.setCmpaCd(DaoUtil.convertNullToString(rs.getString("cmpaCd")));
        dto.setStfNo(DaoUtil.convertNullToString(rs.getString("stfNo")));
        dto.setItem01(DaoUtil.convertNullToString(rs.getString("item01")));
        dto.setItem02(DaoUtil.convertNullToString(rs.getString("item02")));
        dto.setItem03(DaoUtil.convertNullToString(rs.getString("item03")));
        dto.setItem04(DaoUtil.convertNullToString(rs.getString("item04")));
        dto.setItem05(DaoUtil.convertNullToString(rs.getString("item05")));
        dto.setItem06(DaoUtil.convertNullToString(rs.getString("item06")));
        dto.setItem07(DaoUtil.convertNullToString(rs.getString("item07")));
        dto.setItem08(DaoUtil.convertNullToString(rs.getString("item08")));
        dto.setItem09(DaoUtil.convertNullToString(rs.getString("item09")));
        dto.setItem10(DaoUtil.convertNullToString(rs.getString("item10")));
        dto.setItem11(DaoUtil.convertNullToString(rs.getString("item11")));
        dto.setItem12(DaoUtil.convertNullToString(rs.getString("item12")));
        dto.setItem13(DaoUtil.convertNullToString(rs.getString("item13")));
        dto.setItem14(DaoUtil.convertNullToString(rs.getString("item14")));
        dto.setItem15(DaoUtil.convertNullToString(rs.getString("item15")));
        dto.setItem16(DaoUtil.convertNullToString(rs.getString("item16")));
        dto.setItem17(DaoUtil.convertNullToString(rs.getString("item17")));
        dto.setItem18(DaoUtil.convertNullToString(rs.getString("item18")));
        dto.setItem19(DaoUtil.convertNullToString(rs.getString("item19")));
        dto.setItem20(DaoUtil.convertNullToString(rs.getString("item20")));
        dto.setItem21(DaoUtil.convertNullToString(rs.getString("item21")));
        dto.setItem22(DaoUtil.convertNullToString(rs.getString("item22")));
        dto.setItem23(DaoUtil.convertNullToString(rs.getString("item23")));
        dto.setItem24(DaoUtil.convertNullToString(rs.getString("item24")));
        dto.setItem25(DaoUtil.convertNullToString(rs.getString("item25")));
        dto.setItem26(DaoUtil.convertNullToString(rs.getString("item26")));
        dto.setItem27(DaoUtil.convertNullToString(rs.getString("item27")));
        dto.setItem28(DaoUtil.convertNullToString(rs.getString("item28")));
        dto.setItem29(DaoUtil.convertNullToString(rs.getString("item29")));
        dto.setItem30(DaoUtil.convertNullToString(rs.getString("item30")));
        dto.setItem31(DaoUtil.convertNullToString(rs.getString("item31")));
        dto.setItem32(DaoUtil.convertNullToString(rs.getString("item32")));
        dto.setItem33(DaoUtil.convertNullToString(rs.getString("item33")));
        dto.setItem34(DaoUtil.convertNullToString(rs.getString("item34")));
        dto.setItem35(DaoUtil.convertNullToString(rs.getString("item35")));
        dto.setItem36(DaoUtil.convertNullToString(rs.getString("item36")));
        dto.setItem37(DaoUtil.convertNullToString(rs.getString("item37")));
        dto.setItem38(DaoUtil.convertNullToString(rs.getString("item38")));
        dto.setItem39(DaoUtil.convertNullToString(rs.getString("item39")));
        dto.setItem40(DaoUtil.convertNullToString(rs.getString("item40")));
        dto.setItem41(DaoUtil.convertNullToString(rs.getString("item41")));
        dto.setItem42(DaoUtil.convertNullToString(rs.getString("item42")));
        dto.setItem43(DaoUtil.convertNullToString(rs.getString("item43")));
        dto.setItem44(DaoUtil.convertNullToString(rs.getString("item44")));
        dto.setItem45(DaoUtil.convertNullToString(rs.getString("item45")));
        dto.setItem46(DaoUtil.convertNullToString(rs.getString("item46")));
        dto.setItem47(DaoUtil.convertNullToString(rs.getString("item47")));
        dto.setItem48(DaoUtil.convertNullToString(rs.getString("item48")));
        dto.setItem49(DaoUtil.convertNullToString(rs.getString("item49")));
        dto.setItem50(DaoUtil.convertNullToString(rs.getString("item50")));
        dto.setItem51(DaoUtil.convertNullToString(rs.getString("item51")));
        dto.setItem52(DaoUtil.convertNullToString(rs.getString("item52")));
        dto.setItem53(DaoUtil.convertNullToString(rs.getString("item53")));
        dto.setItem54(DaoUtil.convertNullToString(rs.getString("item54")));
        dto.setItem55(DaoUtil.convertNullToString(rs.getString("item55")));
        dto.setItem56(DaoUtil.convertNullToString(rs.getString("item56")));
        dto.setItem57(DaoUtil.convertNullToString(rs.getString("item57")));
        dto.setItem58(DaoUtil.convertNullToString(rs.getString("item58")));
        dto.setItem59(DaoUtil.convertNullToString(rs.getString("item59")));
        dto.setItem60(DaoUtil.convertNullToString(rs.getString("item60")));
        return dto;
    }

}

