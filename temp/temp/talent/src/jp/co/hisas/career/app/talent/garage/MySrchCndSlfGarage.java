package jp.co.hisas.career.app.talent.garage;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.naming.NamingException;

import org.apache.commons.lang.math.NumberUtils;

import jp.co.hisas.career.app.talent.dao.JvDfSrchShelfDao;
import jp.co.hisas.career.app.talent.dao.JvSrchRsltListDao;
import jp.co.hisas.career.app.talent.dao.JvTrMysrchCndSlfDao;
import jp.co.hisas.career.app.talent.dto.JvDfSrchShelfDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndSlfDto;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;

public class MySrchCndSlfGarage extends Garage {
	
	public MySrchCndSlfGarage(String daoLoginNo) {
		super( daoLoginNo );
	}
	
	public Map<String, Map<String, String>> getSavedMySearchSlfMap( String mysrchId ) throws SQLException, NamingException {
		// 検索条件履歴_詳細_SLF
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( " select " + JvTrMysrchCndSlfDao.ALLCOLS );
		sql.append( "   from JV_TR_MYSRCH_CND_SLF " );
		sql.append( "  where MYSRCH_ID = ? " );
		sql.append( "  order by SECT_ID, KOMOKU_ID " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( mysrchId );
		
		JvTrMysrchCndSlfDao dao = new JvTrMysrchCndSlfDao( daoLoginNo );
		List<JvTrMysrchCndSlfDto> list = dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
		Map<String, List<JvTrMysrchCndSlfDto>> sectMap = AU.toMap( list, "sectId" );
		// Map<SectId, Map<PzId, Query[Kigo]>>
		Map<String, Map<String, String>> resultMap = new LinkedHashMap<String, Map<String, String>>();
		for (Map.Entry<String, List<JvTrMysrchCndSlfDto>> entry : sectMap.entrySet()) {
			String sectId = entry.getKey();
			List<JvTrMysrchCndSlfDto> slfList = entry.getValue();
			Map<String, String> pzMap = new HashMap<String, String>();
			for (JvTrMysrchCndSlfDto s : slfList) {
				String qryKigo = String.format( "%s[%s]", s.getQuery(), s.getKigoType() );
				pzMap.put( s.getKomokuId(), qryKigo );
			}
			resultMap.put( sectId, pzMap );
		}
		return resultMap;
	}
	
	public void reduceByShelfCond( String updGuid, Map<String, Map<String, String>> shelfCondMap ) {
		
		for (Map.Entry<String, Map<String, String>> entry : shelfCondMap.entrySet() ) {
			
			String shelfSectId = entry.getKey();
			Map<String, String> shelfConds = entry.getValue();
			if (AU.isAllValueBlank( shelfConds )) {
				continue;
			}
			
			deleteByShelftypeSect( updGuid, shelfConds );
			
			deleteByShelftypeForm( updGuid, shelfSectId );
		}
	}
	
	private void deleteByShelftypeSect( String updGuid, Map<String, String> shelfConds ) {
		String inSql = "";
		String hrzTbl = "";
		// Map<PzId, Value[Kigo]>
		for (Entry<String, String> e : shelfConds.entrySet()) {
			JvDfSrchShelfDao ddao = new JvDfSrchShelfDao( daoLoginNo );
			JvDfSrchShelfDto ddto = ddao.select( e.getKey() );
			hrzTbl = ddto.getHrzTbl(); // Expected all is same
			inSql += makeShelfCond( ddto.getHrzCol(), e.getValue(), "1".equals( ddto.getNumberSrchFlg() ) );
		}
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "delete from JV_SRCH_RSLT_WK wk " );
		sql.append( " where wk.UPD_USER = ?" );
		sql.append( "   and not exists ( " );
		sql.append( "     select * from JV_SRCH_RSLT_WK t1 " );
		sql.append( "         left outer join " + hrzTbl + " hrz " );
		sql.append( "         on T1.TGT_CMPA_CD = hrz.CMPA_CD and T1.TGT_STF_NO = hrz.STF_NO " );
		sql.append( " where t1.TGT_CMPA_CD = wk.TGT_CMPA_CD " );
		sql.append( "   and t1.TGT_STF_NO = wk.TGT_STF_NO " );
		sql.append( "            " + inSql );
		sql.append( "       ) " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( updGuid );
		
		JvSrchRsltListDao dao = new JvSrchRsltListDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private void deleteByShelftypeForm( String updGuid, String shelfSectId ) {
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "delete from JV_SRCH_RSLT_WK wk " );
		sql.append( " where wk.UPD_USER = ?" );
		sql.append( "   and not exists ( " );
		sql.append( "         select 'X' from JV_PROF_TAB_SECT_ON sub " );
		sql.append( "          where sub.PARTY   = wk.PARTY " );
		sql.append( "            and sub.ROLE_ID = wk.ROLE_ID " );
		sql.append( "            and sub.SECT_ID = ? " );
		sql.append( "       ) " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( updGuid );
		paramList.add( shelfSectId );
		
		JvSrchRsltListDao dao = new JvSrchRsltListDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private String makeShelfCond( String col, String query, boolean isNum ) {
		String val  = SU.extract( query, "^(.*)\\[..\\]$" );
		String kigo = SU.extract( query, "^.*\\[(..)\\]$" );
		boolean isNumberOnly = false;
		if (SU.isBlank( col ) || SU.isBlank( val ) || SU.isBlank( kigo )) {
			return "";
		}
		if (isNum) {
			boolean isNumber = NumberUtils.isNumber( val );
			boolean hasAlpha = SU.matches( val, "[A-Za-z]" );
			if (isNumber && !hasAlpha) {
				isNumberOnly = true;
			} else {
				val = "";
			}
		}
		// Guard SQL Injection
		val = SU.replaceAll( val, "'", "''" );
		String s = "";
		if (SU.matches( kigo, "eq" )) {
			// Equal
			s = makeCondFormula( "=", val, isNumberOnly );
		}
		else if (SU.matches( kigo, "ne" )) {
			// Not equal
			s = makeCondFormula( "<>", val, isNumberOnly );
		}
		else if (SU.matches( kigo, "lk" )) {
			// Like
			s = makeCondFormula( "like", "%" + val + "%", isNumberOnly );
		}
		else if (SU.matches( kigo, "nl" )) {
			// Not like
			s = makeCondFormula( "not like", "%" + val + "%", isNumberOnly );
		}
		else if (SU.matches( kigo, "gt" )) {
			// Greater than
			s = makeCondFormula( ">=", val, isNumberOnly );
		}
		else if (SU.matches( kigo, "lt" )) {
			// Less than
			s = makeCondFormula( "<=", val, isNumberOnly );
		}
		
		if (isNum) {
			col = String.format( "to_number(%s)", col );
		}
		if(SU.matches( kigo, "ne" ) || SU.matches( kigo, "nl" )) {
			return String.format( " and ( %s %s or %s is null )", col, s , col );
		} else {
		return String.format( " and %s %s", col, s );
		}
	}
	
	private static String makeCondFormula( String operator, String val, boolean isNumberOnly ) {
		String result = "";
		if (SU.matches( operator, "like|not like" )) {
			result = String.format( "%s '%s'", operator, val );
		}
		else if (isNumberOnly) {
			result = String.format( "%s %s", operator, val );
		}
		else {
			result = String.format( "%s '%s'", operator, val );
		}
		return result;
	}
	
}
