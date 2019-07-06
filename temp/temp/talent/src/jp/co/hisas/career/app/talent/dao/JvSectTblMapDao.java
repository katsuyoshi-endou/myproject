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
import jp.co.hisas.career.app.talent.dto.JvSectTblMapDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvSectTblMapDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " PARTY as party,"
                     + " CSV_PTN_ID as csvPtnId,"
                     + " CSV_PTN_NM as csvPtnNm,"
                     + " FILTER_SECT_ID as filSectId,"
                     + " TBL_OBJ as tblObj,"
                     + " FILE_NM as fileNm"
                     ;

    public JvSectTblMapDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvSectTblMapDao(Connection conn) {
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

    public JvSectTblMapDto select(String party, String sectId) {

        final String sql = "SELECT "
                         + "" + ALLCOLS + ""
                         + " FROM JV_SECT_TBL_MAP"
                         + " WHERE PARTY = ?"
                         + " AND CSV_PTN_ID = ?"
                         ;
        Log.sql("[DaoMethod Call] JvSectTblMapDao.select");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, party);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, sectId);
            rs = pstmt.executeQuery();
            JvSectTblMapDto dto = null;
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

    public List<JvSectTblMapDto> selectDynamic(PreparedStatement pstmt) {

        Log.sql("[DaoMethod Call] JvSectTblMapDao.selectDynamic");
        ResultSet rs = null;
        try {
            rs = pstmt.executeQuery();
            List<JvSectTblMapDto> lst = new ArrayList<JvSectTblMapDto>();
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

    public List<JvSectTblMapDto> selectDynamic(String sql) {

        Log.sql("[DaoMethod Call] JvSectTblMapDao.selectDynamic");
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

    private JvSectTblMapDto transferRsToDto(ResultSet rs) throws SQLException {

        JvSectTblMapDto dto = new JvSectTblMapDto();
        dto.setParty(DaoUtil.convertNullToString(rs.getString("party")));
        dto.setCsvPtnId(DaoUtil.convertNullToString(rs.getString("csvPtnId")));
        dto.setCsvPtnNm(DaoUtil.convertNullToString(rs.getString("csvPtnNm")));
        dto.setFilSectId(DaoUtil.convertNullToString(rs.getString("filSectId")));
        dto.setTblObj(DaoUtil.convertNullToString(rs.getString("tblObj")));
        dto.setFileNm(DaoUtil.convertNullToString(rs.getString("fileNm")));
        return dto;
    }

    public List<JvSectTblMapDto> selectAllSectionsByParty(String party) {

        final String sql = "select " + ALLCOLS + " from JV_SECT_TBL_MAP where PARTY = ? order by CSV_PTN_ID";
        Log.sql("[DaoMethod Call] JvSectTblMapDao.selectAllSectionsByParty");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, party);
            rs = pstmt.executeQuery();
            List<JvSectTblMapDto> lst = new ArrayList<JvSectTblMapDto>();
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

