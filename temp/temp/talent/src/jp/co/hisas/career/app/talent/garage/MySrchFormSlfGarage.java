package jp.co.hisas.career.app.talent.garage;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.NamingException;

import jp.co.hisas.career.app.talent.dao.JvProfTabSectListtypeDao;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectListtypeDto;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;

public class MySrchFormSlfGarage extends Garage {
	
	public MySrchFormSlfGarage(String daoLoginNo) {
		super( daoLoginNo );
	}
	
	public Map<String, List<JvProfTabSectListtypeDto>> getSrchFormShelf( String party, List<String> roleIdList ) throws SQLException, NamingException {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + SU.addPrefixOnDaoAllCols( "l", JvProfTabSectListtypeDao.ALLCOLS ) );
		sql.append( "  from JV_PROF_TAB_SECT_LISTTYPE l " );
		sql.append( "       inner join ( " );
		sql.append( "         select distinct SECT_ID " );
		sql.append( "           from JV_PROF_TAB_SECT_ON s " );
		sql.append( "          where s.PARTY = ? " );
		sql.append( "            and s.ROLE_ID in (" + SU.convListToSqlInVal( roleIdList ) + ") " );
		sql.append( "       ) sect " );
		sql.append( "         on (sect.SECT_ID = L.SECT_ID) " );
		sql.append( " order by l.SECT_ID, l.COL_NO " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		
		// select JV_PROF_TAB_SECT_LISTTYPE
		List<JvProfTabSectListtypeDto> allListList;
		JvProfTabSectListtypeDao daoList = new JvProfTabSectListtypeDao( daoLoginNo );
		allListList = daoList.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
		
		Map<String, List<JvProfTabSectListtypeDto>> allListMap = AU.toMap( allListList, "sectId" );
		return allListMap;
	}
	
}
