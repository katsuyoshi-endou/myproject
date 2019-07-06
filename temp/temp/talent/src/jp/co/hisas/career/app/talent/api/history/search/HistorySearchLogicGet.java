package jp.co.hisas.career.app.talent.api.history.search;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.dao.useful.OneColumnDao;

public class HistorySearchLogicGet {
	
	private String daoLoginNo;
	private HistorySearchEvRslt evRslt;
	
	public HistorySearchLogicGet(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new HistorySearchEvRslt();
	}
	
	protected HistorySearchEvRslt main( HistorySearchEvArg arg ) throws SQLException {
		
		Set<String> logs = selectRecentQuickSearchLog( arg );
		
		evRslt.logs = logs;
		
		return evRslt;
	}
	
	private Set<String> selectRecentQuickSearchLog( HistorySearchEvArg arg ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select QUERY as text " );
		sql.append( "  from ( ");
		sql.append( "         select PARTY, GUID, QUERY, max(TIMESTAMP) ts from JV_TR_QUICK_HIST ");
		sql.append( "          where PARTY = ? and GUID = ? ");
		sql.append( "          group by PARTY, GUID, QUERY ");
		sql.append( "          order by ts desc ");
		sql.append( "  ) z ");
		sql.append( " where ROWNUM <= 10 ");
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.party );
		paramList.add( arg.guid );
		
		OneColumnDao dao = new OneColumnDao( daoLoginNo );
		List<String> list = dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
		
		Set<String> set = new LinkedHashSet<String>();
		for (String query : list) {
			set.add( query );
		}
		return set;
	}
	
}
