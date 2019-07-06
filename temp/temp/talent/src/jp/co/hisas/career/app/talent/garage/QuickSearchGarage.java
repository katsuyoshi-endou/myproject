package jp.co.hisas.career.app.talent.garage;

import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.dao.JvDfQuickRegexDao;
import jp.co.hisas.career.app.talent.dao.JvDfQuickWordDao;
import jp.co.hisas.career.app.talent.dao.JvTrQuickHistDao;
import jp.co.hisas.career.app.talent.dto.JvDfQuickRegexDto;
import jp.co.hisas.career.app.talent.dto.JvDfQuickWordDto;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;

public class QuickSearchGarage extends Garage {
	
	public QuickSearchGarage(String daoLoginNo) {
		super( daoLoginNo );
	}
	
	public void insertQuickSearchLog( String party, String guid, String query ) {
		
		if (SU.isBlank( query )) { return; }
		
		StringBuilder sql = new StringBuilder();
		sql.append( "insert into JV_TR_QUICK_HIST ");
		sql.append( "select NEXT_SEQ, ?, ?, ?, to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') ");
		sql.append( "  from (select nvl(max(SEQ_NO),0)+1 as NEXT_SEQ from JV_TR_QUICK_HIST) t ");
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( guid );
		paramList.add( query );
		
		JvTrQuickHistDao dao = new JvTrQuickHistDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public List<JvDfQuickRegexDto> getDfQuickRegex( String party, String roleId ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + SU.addPrefixOnDaoAllCols( "qr", JvDfQuickRegexDao.ALLCOLS ) );
		sql.append( "  from JV_DF_QUICK_REGEX qr ");
		sql.append( "       inner join (select KOMOKU_ID from JV_PROF_KOMOKU_FILTER where PARTY = ? and ROLE_ID = ? and DISPLAY_MODE = 'visible') kf ");
		sql.append( "         on (kf.KOMOKU_ID = qr.PZ_ID) ");
		sql.append( "order by qr.PRIORITY ");
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( roleId );
		
		JvDfQuickRegexDao dao = new JvDfQuickRegexDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public List<JvDfQuickWordDto> getDfQuickWord( String party, String roleId ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + SU.addPrefixOnDaoAllCols( "qw", JvDfQuickWordDao.ALLCOLS ) );
		sql.append( "  from JV_DF_QUICK_WORD qw ");
		sql.append( "       inner join (select KOMOKU_ID from JV_PROF_KOMOKU_FILTER where PARTY = ? and ROLE_ID = ? and DISPLAY_MODE = 'visible') kf ");
		sql.append( "         on (kf.KOMOKU_ID = qw.PZ_ID) ");
		sql.append( "order by qw.PRIORITY ");
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( roleId );
		
		JvDfQuickWordDao dao = new JvDfQuickWordDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
}
