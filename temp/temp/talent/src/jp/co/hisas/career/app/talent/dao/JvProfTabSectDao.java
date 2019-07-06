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
import jp.co.hisas.career.app.talent.dto.JvProfTabSectDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvProfTabSectDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " TAB_ID as tabId,"
                     + " SECT_ID as sectId,"
                     + " SORT as sort,"
                     + " LABEL_ID as labelId,"
                     + " LAYOUT_TYPE as layoutType,"
                     + " CLASSES as classes,"
                     + " WIDTH as width,"
                     + " STYLE as style"
                     ;

    public JvProfTabSectDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvProfTabSectDao(Connection conn) {
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

    public JvProfTabSectDto select(String tabId, String sectId) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_PROF_TAB_SECT"
                         + " WHERE TAB_ID = ?"
                         + " AND SECT_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvProfTabSectDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, tabId);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, sectId);
            rs = pstmt.executeQuery();
            JvProfTabSectDto dto = null;
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

    public List<JvProfTabSectDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvProfTabSectDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvProfTabSectDto> lst = new ArrayList<JvProfTabSectDto>();
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

    public List<JvProfTabSectDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvProfTabSectDao.selectDynamic");
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

    private JvProfTabSectDto transferRsToDto(ResultSet rs) throws SQLException {

        JvProfTabSectDto dto = new JvProfTabSectDto();
        dto.setTabId(DaoUtil.convertNullToString(rs.getString("tabId")));
        dto.setSectId(DaoUtil.convertNullToString(rs.getString("sectId")));
        dto.setSort(rs.getInt("sort"));
        dto.setLabelId(DaoUtil.convertNullToString(rs.getString("labelId")));
        dto.setLayoutType(DaoUtil.convertNullToString(rs.getString("layoutType")));
        dto.setClasses(DaoUtil.convertNullToString(rs.getString("classes")));
        dto.setWidth(DaoUtil.convertNullToString(rs.getString("width")));
        dto.setStyle(DaoUtil.convertNullToString(rs.getString("style")));
        return dto;
    }

    public List<JvProfTabSectDto> selectSectionsByTabId(String tabId) {

        final String sql = "select " + ALLCOLS + " from JV_PROF_TAB_SECT where TAB_ID = ? order by SORT";
        Log.sql("[DaoMethod Call] JvProfTabSectDao.selectSectionsByTabId");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, tabId);
            rs = pstmt.executeQuery();
            List<JvProfTabSectDto> lst = new ArrayList<JvProfTabSectDto>();
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

