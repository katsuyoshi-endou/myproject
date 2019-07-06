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
import jp.co.hisas.career.app.talent.dto.JvProfTabSectListtypeDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvProfTabSectListtypeDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " SECT_ID as sectId,"
                     + " COL_NO as colNo,"
                     + " CLASSES as classes,"
                     + " WIDTH as width,"
                     + " HEADER_LABEL_ID as headerLabelId,"
                     + " HEADER_STYLE as headerStyle,"
                     + " SUB_HEADER_LABEL_ID as subHeaderLabelId,"
                     + " DATA_PARAM_ID as dataParamId,"
                     + " DATA_STYLE as dataStyle"
                     ;

    public JvProfTabSectListtypeDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvProfTabSectListtypeDao(Connection conn) {
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

    public JvProfTabSectListtypeDto select(String sectId, Integer colNo) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_PROF_TAB_SECT_LISTTYPE"
                         + " WHERE SECT_ID = ?"
                         + " AND COL_NO = ?"
                         ;
        Log.sql("[DaoMethod Call] JvProfTabSectListtypeDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, sectId);
            DaoUtil.setIntToPreparedStatement(pstmt, 2, colNo);
            rs = pstmt.executeQuery();
            JvProfTabSectListtypeDto dto = null;
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

    public List<JvProfTabSectListtypeDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvProfTabSectListtypeDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvProfTabSectListtypeDto> lst = new ArrayList<JvProfTabSectListtypeDto>();
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

    public List<JvProfTabSectListtypeDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvProfTabSectListtypeDao.selectDynamic");
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

    private JvProfTabSectListtypeDto transferRsToDto(ResultSet rs) throws SQLException {

        JvProfTabSectListtypeDto dto = new JvProfTabSectListtypeDto();
        dto.setSectId(DaoUtil.convertNullToString(rs.getString("sectId")));
        dto.setColNo(rs.getInt("colNo"));
        dto.setClasses(DaoUtil.convertNullToString(rs.getString("classes")));
        dto.setWidth(DaoUtil.convertNullToString(rs.getString("width")));
        dto.setHeaderLabelId(DaoUtil.convertNullToString(rs.getString("headerLabelId")));
        dto.setHeaderStyle(DaoUtil.convertNullToString(rs.getString("headerStyle")));
        dto.setSubHeaderLabelId(DaoUtil.convertNullToString(rs.getString("subHeaderLabelId")));
        dto.setDataParamId(DaoUtil.convertNullToString(rs.getString("dataParamId")));
        dto.setDataStyle(DaoUtil.convertNullToString(rs.getString("dataStyle")));
        return dto;
    }

    public List<JvProfTabSectListtypeDto> selectListtypeSectionBySectId(String sectId) {

        final String sql = "select " + ALLCOLS + " from JV_PROF_TAB_SECT_LISTTYPE where SECT_ID = ? order by COL_NO";
        Log.sql("[DaoMethod Call] JvProfTabSectListtypeDao.selectListtypeSectionBySectId");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, sectId);
            rs = pstmt.executeQuery();
            List<JvProfTabSectListtypeDto> lst = new ArrayList<JvProfTabSectListtypeDto>();
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

