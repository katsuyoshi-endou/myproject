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
import jp.co.hisas.career.app.talent.dto.JvProfTabSectAddontypeDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvProfTabSectAddontypeDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " SECT_ID as sectId,"
                     + " ADDON_ID as addonId"
                     ;

    public JvProfTabSectAddontypeDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvProfTabSectAddontypeDao(Connection conn) {
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

    public JvProfTabSectAddontypeDto select(String sectId, String addonId) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_PROF_TAB_SECT_ADDONTYPE"
                         + " WHERE SECT_ID = ?"
                         + " AND ADDON_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvProfTabSectAddontypeDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, sectId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, addonId);
            rs = pstmt.executeQuery();
            JvProfTabSectAddontypeDto dto = null;
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

    public List<JvProfTabSectAddontypeDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvProfTabSectAddontypeDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvProfTabSectAddontypeDto> lst = new ArrayList<JvProfTabSectAddontypeDto>();
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

    public List<JvProfTabSectAddontypeDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvProfTabSectAddontypeDao.selectDynamic");
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

    private JvProfTabSectAddontypeDto transferRsToDto(ResultSet rs) throws SQLException {

        JvProfTabSectAddontypeDto dto = new JvProfTabSectAddontypeDto();
        dto.setSectId(DaoUtil.convertNullToString(rs.getString("sectId")));
        dto.setAddonId(DaoUtil.convertNullToString(rs.getString("addonId")));
        return dto;
    }

}

