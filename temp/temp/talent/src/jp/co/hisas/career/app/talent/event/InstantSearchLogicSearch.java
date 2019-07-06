package jp.co.hisas.career.app.talent.event;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.dao.JvSrchRsltListDao;
import jp.co.hisas.career.app.talent.dao.JvWkInstantHitDao;
import jp.co.hisas.career.app.talent.garage.InstantSearchGarage;
import jp.co.hisas.career.app.talent.garage.SrchBindGarage;
import jp.co.hisas.career.app.talent.garage.SrchRsltWkGarage;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;

public class InstantSearchLogicSearch {
	
	private String daoLoginNo;
	private InstantSearchEvRslt evRslt;
	
	public InstantSearchLogicSearch( String daoLoginNo ) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new InstantSearchEvRslt();
	}
	
	protected InstantSearchEvRslt main( InstantSearchEvArg arg ) throws SQLException {
		
		SrchRsltWkGarage ggWk = new SrchRsltWkGarage( daoLoginNo );
		SrchBindGarage ggBd = new SrchBindGarage( daoLoginNo );
		InstantSearchGarage ggIs = new InstantSearchGarage( daoLoginNo );
		
		/* Clear Work Data */
		ggWk.clearResultWk( daoLoginNo );
		
		/* Make Work Data */
		ggWk.makeWorkAll( arg.sessionId, arg.party, arg.guid );
		
		/* Query Log */
		ggIs.insertInstantSearchHistory( arg.party, arg.guid, arg.scopes, arg.query );
		
		/* Except Retire/Remove */
		if (arg.exceptRetire) {
			ggWk.reduceWkExceptRetireSBAW( arg.guid );
		}
		if (arg.exceptRemove) {
			ggWk.reduceWkExceptRemoveSBAW( arg.guid );
		}
		
		List<String> scopeList = SU.arrayToList( arg.scopes );
		String[] queries = arg.query.split( " " );
		
		/* Reduce Work Data */
		List<String> roleList = ggBd.getRoleList( arg.party, daoLoginNo );
		reduceWkByQueries( arg, scopeList, queries, roleList );
		
		/* Update WK_IDX for sort and separated fetch */
		ggWk.updateWkIdx( arg.sessionId, arg.party, arg.guid );
		
		/* Make Hit PZ Data */
		makeHitPZ( arg, scopeList, queries, roleList );
		
		/* Keep user inputs */
		evRslt.queryWords = queries;
		evRslt.scopeList = scopeList;
		
		return evRslt;
	}
	
	private void reduceWkByQueries( InstantSearchEvArg arg, List<String> scopeList, String[] queries, List<String> roleList ) {
		
		if (SU.isBlank( arg.query )) { return; }
		if (SU.isBlank( arg.scopes )) { return; }
		SU.allowsOnlyCode( arg.scopes );
		
		for (String roleId : roleList) {
			for (String q : queries) {
				reduceWkCore( arg, roleId, scopeList, q );
			}
		}
	}
	
	private void makeHitPZ( InstantSearchEvArg arg, List<String> scopeList, String[] queries, List<String> roleList ) {
		
		// Need to clear before judge from args.
		deleteHitPzItems( arg );
		
		if (SU.isBlank( arg.query )) { return; }
		if (SU.isBlank( arg.scopes )) { return; }
		SU.allowsOnlyCode( arg.scopes );
		
		for (String roleId : roleList) {
			for (int i = 0; i < queries.length; i++) {
				insertHitPzItems( arg, i, roleId, scopeList, queries[i] );
			}
		}
	}
	
	/**
	 * すべての人属性値 (V_PZ_ALL) からクエリ文字列を含む値をもつ社員を割り出し、
	 * 該当しない社員を検索結果テーブルのレコードから削ります。
	 */
	private void reduceWkCore( InstantSearchEvArg arg, String roleId, List<String> scopeList, String query ) {
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "delete from JV_SRCH_RSLT_WK wk" );
		sql.append( " where wk.SESSION_ID = ? " );
		sql.append( "   and wk.ROLE_ID = ? " );
		sql.append( "   and not exists (" );
		sql.append( "       select pza.CMPA_CD" );
		sql.append( "            , pza.STF_NO" );
		sql.append( "         from V_PZ_ALL pza" );
		sql.append( "              inner join JV_SRCH_RSLT_WK wk2" );
		sql.append( "                on (wk2.TGT_CMPA_CD = pza.CMPA_CD and wk2.TGT_STF_NO = pza.STF_NO and wk2.ROLE_ID = ?)" );
		sql.append( "              inner join (" );
		sql.append( "                select kf.KOMOKU_ID as KOMOKU_ID" );
		sql.append( "                  from JV_PROF_KOMOKU_FILTER kf" );
		sql.append( "                       inner join JV_DF_INSTANT_SEARCH_SCOPE sc" );
		sql.append( "                         on (sc.PARTY = kf.PARTY and kf.KOMOKU_ID = sc.PZ_ID and sc.SCOPE in ( " + SU.convListToSqlInVal( scopeList ) + " ) )" );
		sql.append( "                 where kf.PARTY = ? " );
		sql.append( "                   and kf.ROLE_ID = ? " );
		sql.append( "                   and kf.DISPLAY_MODE = 'visible'" );
		sql.append( "              ) akf on (akf.KOMOKU_ID = pza.PZ_ID)" );
		sql.append( "        where pza.PZ_VAL like ? " );
		sql.append( "          and pza.CMPA_CD = wk.TGT_CMPA_CD" );
		sql.append( "          and pza.STF_NO  = wk.TGT_STF_NO" );
		sql.append( "   )" );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.sessionId );
		paramList.add( roleId );
		paramList.add( roleId );
		paramList.add( arg.party );
		paramList.add( roleId );
		paramList.add( "%" + query + "%" );
		
		JvSrchRsltListDao dao = new JvSrchRsltListDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private void deleteHitPzItems( InstantSearchEvArg arg ) {
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "delete from JV_TR_INSTANT_HIT where GUID = ? " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.guid );
		
		JvWkInstantHitDao dao = new JvWkInstantHitDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private void insertHitPzItems( InstantSearchEvArg arg, int querySeq, String roleId, List<String> scopeList, String query ) {
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "insert into JV_TR_INSTANT_HIT " );
		sql.append( "select wk.SESSION_ID, ?, ?, ?, wk.TGT_CMPA_CD, wk.TGT_STF_NO, pza.PZ_ID" );
		sql.append( "     , case" );
		sql.append( "         when length(pza.PZ_VAL) > 20 then substr(pza.PZ_VAL, 1, 20) || '...' " );
		sql.append( "         else pza.PZ_VAL " );
		sql.append( "       end " );
		sql.append( "  from V_PZ_ALL pza" );
		sql.append( "       inner join JV_SRCH_RSLT_WK wk" );
		sql.append( "         on (wk.TGT_CMPA_CD = pza.CMPA_CD and wk.TGT_STF_NO = pza.STF_NO)" );
		sql.append( "       inner join (" );
		sql.append( "         select kf.KOMOKU_ID as KOMOKU_ID" );
		sql.append( "           from JV_PROF_KOMOKU_FILTER kf" );
		sql.append( "                inner join JV_DF_INSTANT_SEARCH_SCOPE sc" );
		sql.append( "                  on (sc.PARTY = kf.PARTY and kf.KOMOKU_ID = sc.PZ_ID and sc.SCOPE in ( " + SU.convListToSqlInVal( scopeList ) + " ) )" );
		sql.append( "          where kf.PARTY = ? " );
		sql.append( "            and kf.ROLE_ID = ? " );
		sql.append( "            and kf.DISPLAY_MODE = 'visible'" );
		sql.append( "       ) akf on (akf.KOMOKU_ID = pza.PZ_ID)" );
		sql.append( " where pza.PZ_VAL like ? " );
		sql.append( "   and pza.CMPA_CD = wk.TGT_CMPA_CD" );
		sql.append( "   and pza.STF_NO  = wk.TGT_STF_NO" );
		sql.append( "   and wk.SESSION_ID = ? " );
		sql.append( "   and wk.ROLE_ID = ? " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.guid );
		paramList.add( "" + querySeq );
		paramList.add( query );
		paramList.add( arg.party );
		paramList.add( roleId );
		paramList.add( "%" + query + "%" );
		paramList.add( arg.sessionId );
		paramList.add( roleId );
		
		JvWkInstantHitDao dao = new JvWkInstantHitDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
}
