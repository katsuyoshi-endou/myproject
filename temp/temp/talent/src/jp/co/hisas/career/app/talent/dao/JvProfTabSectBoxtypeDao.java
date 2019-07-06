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
import jp.co.hisas.career.app.talent.dto.JvProfTabSectBoxtypeDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvProfTabSectBoxtypeDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " SECT_ID as sectId,"
                     + " ROW_NO as rowNo,"
                     + " COL_NO as colNo,"
                     + " COLSPAN as colspan,"
                     + " TAG_NAME as tagName,"
                     + " CLASSES as classes,"
                     + " WIDTH as width,"
                     + " STYLE as style,"
                     + " LABEL_OR_DATA as labelOrData,"
                     + " PARAM_ID as paramId"
                     ;

    public JvProfTabSectBoxtypeDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvProfTabSectBoxtypeDao(Connection conn) {
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

    public JvProfTabSectBoxtypeDto select(String sectId, Integer rowNo, Integer colNo) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_PROF_TAB_SECT_BOXTYPE"
                         + " WHERE SECT_ID = ?"
                         + " AND ROW_NO = ?"
                         + " AND COL_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvProfTabSectBoxtypeDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, sectId);
            DaoUtil.setIntToPreparedStatement(pstmt, 2, rowNo);
            DaoUtil.setIntToPreparedStatement(pstmt, 3, colNo);
            rs = pstmt.executeQuery();
            JvProfTabSectBoxtypeDto dto = null;
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

    public List<JvProfTabSectBoxtypeDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvProfTabSectBoxtypeDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvProfTabSectBoxtypeDto> lst = new ArrayList<JvProfTabSectBoxtypeDto>();
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

    public List<JvProfTabSectBoxtypeDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvProfTabSectBoxtypeDao.selectDynamic");
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

    private JvProfTabSectBoxtypeDto transferRsToDto(ResultSet rs) throws SQLException {

        JvProfTabSectBoxtypeDto dto = new JvProfTabSectBoxtypeDto();
        dto.setSectId(DaoUtil.convertNullToString(rs.getString("sectId")));
        dto.setRowNo(rs.getInt("rowNo"));
        dto.setColNo(rs.getInt("colNo"));
        dto.setColspan(rs.getInt("colspan"));
        dto.setTagName(DaoUtil.convertNullToString(rs.getString("tagName")));
        dto.setClasses(DaoUtil.convertNullToString(rs.getString("classes")));
        dto.setWidth(DaoUtil.convertNullToString(rs.getString("width")));
        dto.setStyle(DaoUtil.convertNullToString(rs.getString("style")));
        dto.setLabelOrData(DaoUtil.convertNullToString(rs.getString("labelOrData")));
        dto.setParamId(DaoUtil.convertNullToString(rs.getString("paramId")));
        return dto;
    }

    public List<JvProfTabSectBoxtypeDto> selectBoxtypeSectionBySectId(String sectId) {

        final String sql = "select " + ALLCOLS + " from JV_PROF_TAB_SECT_BOXTYPE where SECT_ID = ? order by ROW_NO, COL_NO";
        Log.sql("[DaoMethod Call] JvProfTabSectBoxtypeDao.selectBoxtypeSectionBySectId");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, sectId);
            rs = pstmt.executeQuery();
            List<JvProfTabSectBoxtypeDto> lst = new ArrayList<JvProfTabSectBoxtypeDto>();
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

