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
import jp.co.hisas.career.app.talent.dto.JvProfTabSectFilterDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log; 
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.exception.CareerSQLException;

public class JvProfTabSectFilterDao {

    Connection conn;
    boolean isConnectionGiven = false;
    String loginNo; 

    public static final String ALLCOLS = ""
                     + " PARTY as party,"
                     + " ROLE_ID as roleId,"
                     + " TAB_ID as tabId,"
                     + " SECT_ID as sectId,"
                     + " ON_OFF as onOff"
                     ;

    public JvProfTabSectFilterDao(String loginNo) {
        this.loginNo = loginNo;
    }

    public JvProfTabSectFilterDao(Connection conn) {
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

    private JvProfTabSectFilterDto transferRsToDto(ResultSet rs) throws SQLException {

        JvProfTabSectFilterDto dto = new JvProfTabSectFilterDto();
        dto.setParty(DaoUtil.convertNullToString(rs.getString("party")));
        dto.setRoleId(DaoUtil.convertNullToString(rs.getString("roleId")));
        dto.setTabId(DaoUtil.convertNullToString(rs.getString("tabId")));
        dto.setSectId(DaoUtil.convertNullToString(rs.getString("sectId")));
        dto.setOnOff(DaoUtil.convertNullToString(rs.getString("onOff")));
        return dto;
    }

    public List<JvProfTabSectFilterDto> selectAllowedSections(String party, String roleId) {

        final String sql = "select " + ALLCOLS + " from JV_PROF_TAB_SECT_FILTER where PARTY = ? and ROLE_ID = ?";
        Log.sql("[DaoMethod Call] JvProfTabSectFilterDao.selectAllowedSections");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 1, party);
            DaoUtil.setVarcharToPreparedStatement(pstmt, 2, roleId);
            rs = pstmt.executeQuery();
            List<JvProfTabSectFilterDto> lst = new ArrayList<JvProfTabSectFilterDto>();
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

