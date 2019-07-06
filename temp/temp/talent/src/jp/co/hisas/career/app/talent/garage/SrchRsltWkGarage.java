package jp.co.hisas.career.app.talent.garage;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import jp.co.hisas.career.app.talent.dao.JvSrchRsltListDao;
import jp.co.hisas.career.app.talent.dao.JvSrchRsltWkDao;
import jp.co.hisas.career.app.talent.dao.KomokuFilterDao;
import jp.co.hisas.career.app.talent.dao.extra.JvSrchRsltWkDaoEx;
import jp.co.hisas.career.app.talent.dto.KomokuFilterDto;
import jp.co.hisas.career.app.talent.dto.extra.JvSrchRsltWkDtoEx;
import jp.co.hisas.career.framework.exception.CareerSecurityException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;

public class SrchRsltWkGarage extends Garage {
	
	public SrchRsltWkGarage(String daoLoginNo) {
		super( daoLoginNo );
	}
	
	public void clearResultWk( String updUser ) throws SQLException {
		JvSrchRsltWkDao dao = new JvSrchRsltWkDao( daoLoginNo );
		dao.deleteJvSrchRsltWkByUpdUser( updUser );
	}
	
	public void updateWkIdx( String sessionId, String party, String guid ) throws SQLException {
		
		StringBuilder sql = new StringBuilder();
		sql.append( " merge into JV_SRCH_RSLT_WK w" );
		sql.append( " using (" );
		sql.append( "     select x.SESSION_ID" );
		sql.append( "          , x.PARTY" );
		sql.append( "          , x.GUID" );
		sql.append( "          , x.TGT_CMPA_CD" );
		sql.append( "          , x.TGT_STF_NO" );
		sql.append( "          , ROW_NUMBER() OVER(order by V.PTN_SORT) as WK_IDX" );
		sql.append( "       from JV_SRCH_RSLT_WK x" );
		sql.append( "            inner join JV_SRCH_RSLT_LIST_PTN_X v" );
		sql.append( "              on (v.CMPA_CD = x.TGT_CMPA_CD and v.STF_NO = x.TGT_STF_NO)" );
		sql.append( "      where x.SESSION_ID = ?" );
		sql.append( "        and x.PARTY = ?" );
		sql.append( "        and x.GUID = ?" );
		sql.append( " ) s" );
		sql.append( "   on (w.SESSION_ID = s.SESSION_ID and w.PARTY = s.PARTY and w.GUID = s.GUID" );
		sql.append( "       and w.TGT_CMPA_CD = s.TGT_CMPA_CD AND w.TGT_STF_NO = s.TGT_STF_NO)" );
		sql.append( " when matched then update" );
		sql.append( " set w.WK_IDX = s.WK_IDX" );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( sessionId );
		paramList.add( party );
		paramList.add( guid );
		
		JvSrchRsltWkDao dao = new JvSrchRsltWkDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void reduceWkExceptRetireSBAW( String loginGuid ) {
		StringBuilder sql = new StringBuilder();
		ArrayList<String> paramList = new ArrayList<String>();
		sql.append( " delete from JV_SRCH_RSLT_WK WK " );
		sql.append( "  where UPD_USER = ? " ); paramList.add( loginGuid );
		sql.append( "    and not exists ( " );
		sql.append( "          select 1 " );
		sql.append( "            from JV_VRT_30_BX PZ00 " );
		sql.append( "           where PZ00.CMPA_CD = WK.TGT_CMPA_CD " );
		sql.append( "             and PZ00.STF_NO  = WK.TGT_STF_NO " );
		sql.append( "             and PZ00.PZ_ID   = 'kojin_genzai_status' " );
		sql.append( "             and PZ00.PZ_VAL <> '退職' " );
		sql.append( "        ) " );
		JvSrchRsltWkDao wkDao = new JvSrchRsltWkDao( daoLoginNo );
		wkDao.executeDynamic(  DaoUtil.getPstmt( sql, paramList )  );
	}
	
	public void reduceWkExceptRemoveSBAW( String loginGuid ) {
		StringBuilder sql = new StringBuilder();
		ArrayList<String> paramList = new ArrayList<String>();
		sql.append( " delete from JV_SRCH_RSLT_WK WK " );
		sql.append( "  where UPD_USER = ? " ); paramList.add( loginGuid );
		sql.append( "    and not exists ( " );
		sql.append( "          select 1 " );
		sql.append( "            from JV_VRT_30_BX PZ00 " );
		sql.append( "           where PZ00.CMPA_CD = WK.TGT_CMPA_CD " );
		sql.append( "             and PZ00.STF_NO  = WK.TGT_STF_NO " );
		sql.append( "             and PZ00.PZ_ID   = 'kojin_genzai_status' " );
		sql.append( "             and PZ00.PZ_VAL <> '出向解除' " );
		sql.append( "        ) " );
		JvSrchRsltWkDao wkDao = new JvSrchRsltWkDao( daoLoginNo );
		wkDao.executeDynamic(  DaoUtil.getPstmt( sql, paramList )  );
	}
	
	public void insertWkMultiStfnoListSBAW( String sessionId, String party, String loginGuid, List<String> stfnoList ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( " insert into JV_SRCH_RSLT_WK (SESSION_ID, PARTY, GUID, TGT_CMPA_CD, TGT_STF_NO, ROLE_ID, UPD_USER) " );
		sql.append( " select ?, ?, ?, bd.TGT_CMPA_CD, bd.TGT_STF_NO, bd.ROLE_ID, bd.GUID " );
		sql.append( "   from JV_SRCH_BIND bd " );
		sql.append( "  where bd.GUID = ? " );
		sql.append( "    and exists ( " );
		sql.append( "          select 1 from CA_PARTY_COMPANY pc " );
		sql.append( "           where pc.CMPA_CD = bd.TGT_CMPA_CD " );
		sql.append( "             and pc.PARTY = ? " );
		sql.append( "        )" );
		sql.append( "    and bd.TGT_STF_NO in (" + SU.convListToSqlInVal( stfnoList ) + ") " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( sessionId );
		paramList.add( party );
		paramList.add( loginGuid );
		paramList.add( loginGuid );
		paramList.add( party );
		
		JvSrchRsltWkDao wkDao = new JvSrchRsltWkDao( daoLoginNo );
		wkDao.executeDynamic(  DaoUtil.getPstmt( sql, paramList )  );
	}
	
	/**
	 * 閲覧可能範囲として紐付けられている社員の中にあるすべてのロールを参照し、
	 * 'retire_searchable' が 'visible' であるものが１つでもあれば true を返す。
	 */
	public boolean judgeRetireSearchable( String party, String login_no ) throws SQLException, NamingException {
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + KomokuFilterDao.ALLCOLS );
		sql.append( "  from JV_PROF_KOMOKU_FILTER k " );
		sql.append( " where k.PARTY = ? " );
		sql.append( "   and k.KOMOKU_ID = 'retire_searchable' " );
		sql.append( "   and k.DISPLAY_MODE = 'visible' " );
// MOD 2017/08/07 r-hagiwara 性能対策 START
//		sql.append( "   and k.ROLE_ID in ( " );
//		sql.append( "         select b.ROLE_ID from JV_SRCH_BIND b " );
//		sql.append( "          where b.GUID = ? " );
		sql.append( "   and EXISTS ( " );
		sql.append( "         select 1 from JV_SRCH_BIND b " );
		sql.append( "          where b.GUID = ? " );
		sql.append( "            and b.ROLE_ID = k.ROLE_ID " );
// MOD 2017/08/07 r-hagiwara 性能対策 END
		sql.append( "            and exists ( " );
		sql.append( "                  select 'X' from CA_PARTY_COMPANY p " );
		sql.append( "                   where p.PARTY = k.PARTY " );
		sql.append( "                     and p.CMPA_CD = b.TGT_CMPA_CD " );
		sql.append( "                ) " );
		sql.append( "       ) " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( login_no );
		
		KomokuFilterDao kfDao = new KomokuFilterDao( daoLoginNo );
		List<KomokuFilterDto> list = kfDao.selectDynamic(  DaoUtil.getPstmt( sql, paramList )  );
		return (list.size() > 0);
	}
	
	public int getWorkCount( String sessionId ) throws SQLException {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select count(*) from JV_SRCH_RSLT_WK where SESSION_ID = ?" );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( sessionId );
		
		JvSrchRsltWkDao dao = new JvSrchRsltWkDao( daoLoginNo );
		return dao.selectCountDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void makeWorkStarred( String sessionId, String party, String guid ) throws SQLException {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "insert into JV_SRCH_RSLT_WK (SESSION_ID, PARTY, GUID, TGT_CMPA_CD, TGT_STF_NO, ROLE_ID, UPD_USER)" );
		sql.append( "       ( " );
		sql.append( "         select ?, ?, ?, st.TGT_CMPA_CD, st.TGT_STF_NO, bd.ROLE_ID, ? " );
		sql.append( "           from JV_TAL_STARRED st " );
		sql.append( "                inner join JV_SRCH_BIND bd " );
		sql.append( "                  on (bd.GUID = st.GUID and bd.TGT_CMPA_CD = st.TGT_CMPA_CD and bd.TGT_STF_NO = st.TGT_STF_NO) " );
		sql.append( "          where st.PARTY = ? and st.GUID = ? " );
		sql.append( "            and st.TGT_CMPA_CD in (select CMPA_CD from CA_PARTY_COMPANY where PARTY = ?) " );
		sql.append( "       ) " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( sessionId );
		paramList.add( party );
		paramList.add( guid );
		paramList.add( guid );
		paramList.add( party );
		paramList.add( guid );
		paramList.add( party );
		
		JvSrchRsltWkDao dao = new JvSrchRsltWkDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void makeWorkViewHistory( String sessionId, String party, String guid ) throws SQLException {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "insert into JV_SRCH_RSLT_WK (SESSION_ID, PARTY, GUID, TGT_CMPA_CD, TGT_STF_NO, ROLE_ID, UPD_USER)" );
		sql.append( "       ( " );
		sql.append( "         select ?, ?, ?, vh.TGT_CMPA_CD, vh.TGT_STF_NO, bd.ROLE_ID, ? " );
		sql.append( "           from (select PARTY, GUID, TGT_CMPA_CD, TGT_STF_NO, max(TIMESTAMP) ts from JV_TR_PROF_VIEW_HIST ");
		sql.append( "                  where PARTY = ? and GUID = ? ");
		sql.append( "                  group by PARTY, GUID, TGT_CMPA_CD, TGT_STF_NO ");
		sql.append( "                  order by ts desc) vh ");
		sql.append( "                inner join JV_SRCH_BIND bd ");
		sql.append( "                  on (bd.GUID = vh.GUID and bd.TGT_CMPA_CD = vh.TGT_CMPA_CD and bd.TGT_STF_NO = vh.TGT_STF_NO) ");
		sql.append( "          where vh.TGT_CMPA_CD in (select CMPA_CD from CA_PARTY_COMPANY where PARTY = ?) ");
		sql.append( "            and ROWNUM <= 100 ");
		sql.append( "       ) " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( sessionId );
		paramList.add( party );
		paramList.add( guid );
		paramList.add( guid );
		paramList.add( party );
		paramList.add( guid );
		paramList.add( party );
		
		JvSrchRsltWkDao dao = new JvSrchRsltWkDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public List<JvSrchRsltWkDtoEx> getTargetList( String sessionId, String party ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + SU.addPrefixOnDaoAllCols( "z", JvSrchRsltWkDaoEx.ALLCOLS ) );
		sql.append( "  from ( " );
		sql.append( "         select w.TGT_CMPA_CD, w.TGT_STF_NO, decode(null, st.GUID, 0, 1) as STARRED_FLG, w.WK_IDX " );
		sql.append( "           from JV_SRCH_RSLT_WK w " );
		sql.append( "                inner join JV_SRCH_RSLT_LIST_PTN_X x " );
		sql.append( "                  on (x.CMPA_CD = w.TGT_CMPA_CD and x.STF_NO = w.TGT_STF_NO) " );
		sql.append( "                left outer join JV_TAL_STARRED st " );
		sql.append( "                  on (st.PARTY = w.PARTY and st.GUID = w.GUID and st.TGT_CMPA_CD = w.TGT_CMPA_CD and st.TGT_STF_NO = w.TGT_STF_NO) " );
		sql.append( "          where w.SESSION_ID = ? " );
		sql.append( "            and w.PARTY = ? " );
		sql.append( "          order by x.PTN_SORT " );
		sql.append( "       ) z " );
		sql.append( " where ROWNUM <= 20 " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( sessionId );
		paramList.add( party );
		
		JvSrchRsltWkDaoEx dao = new JvSrchRsltWkDaoEx( daoLoginNo );
		List<JvSrchRsltWkDtoEx> list = dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
		return list;
	}
	
	public List<JvSrchRsltWkDtoEx> getProfileHistoryTargetList( String sessionId, String party ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + SU.addPrefixOnDaoAllCols( "z", JvSrchRsltWkDaoEx.ALLCOLS ) );
		sql.append( "  from ( " );
		sql.append( "         select w.TGT_CMPA_CD, w.TGT_STF_NO, decode(null, st.GUID, 0, 1) as STARRED_FLG, w.WK_IDX " );
		sql.append( "           from JV_SRCH_RSLT_WK w " );
		sql.append( "                inner join ( " );
		sql.append( "                             select PARTY, GUID, TGT_CMPA_CD, TGT_STF_NO, max(TIMESTAMP) as TIMESTAMP " );
		sql.append( "                               from JV_TR_PROF_VIEW_HIST " );
		sql.append( "                              group by PARTY, GUID, TGT_CMPA_CD, TGT_STF_NO " );
		sql.append( "                ) x " );
		sql.append( "                  on (x.PARTY = w.PARTY and x.GUID = w.GUID and x.TGT_CMPA_CD = w.TGT_CMPA_CD and x.TGT_STF_NO = w.TGT_STF_NO) " );
		sql.append( "                left outer join JV_TAL_STARRED st " );
		sql.append( "                  on (st.PARTY = w.PARTY and st.GUID = w.GUID and st.TGT_CMPA_CD = w.TGT_CMPA_CD and st.TGT_STF_NO = w.TGT_STF_NO) " );
		sql.append( "          where w.SESSION_ID = ? " );
		sql.append( "            and w.PARTY = ? " );
		sql.append( "          order by x.TIMESTAMP desc " );
		sql.append( "       ) z " );
		sql.append( " where ROWNUM <= 20 " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( sessionId );
		paramList.add( party );
		
		JvSrchRsltWkDaoEx dao = new JvSrchRsltWkDaoEx( daoLoginNo );
		List<JvSrchRsltWkDtoEx> list = dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
		return list;
	}
	
	public void makeWorkAll( String sessionId, String party, String guid ) throws SQLException {
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "insert into JV_SRCH_RSLT_WK (SESSION_ID, PARTY, GUID, TGT_CMPA_CD, TGT_STF_NO, ROLE_ID, UPD_USER)" );
		sql.append( "       ( " );
		sql.append( "         select ?, ?, ?, TGT_CMPA_CD, TGT_STF_NO, ROLE_ID, ? " );
		sql.append( "           from JV_SRCH_BIND " );
		sql.append( "          where GUID = ? " );
		sql.append( "            and TGT_CMPA_CD in (select CMPA_CD from CA_PARTY_COMPANY where PARTY = ?) " );
		sql.append( "       ) " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( sessionId );
		paramList.add( party );
		paramList.add( guid );
		paramList.add( guid );
		paramList.add( guid );
		paramList.add( party );
		
		JvSrchRsltListDao dao = new JvSrchRsltListDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void deleteByQuickRegex( String sessionId, String party, String loginGuid, String roleId, String pzId, String operator, String searchVal ) {
		
		String kigo = "";
		if      (SU.equals( operator, "eq"   )) { kigo = "=";  }
		else if (SU.equals( operator, "gteq" )) { kigo = ">="; }
		else if (SU.equals( operator, "lteq" )) { kigo = "<="; }
		else if (SU.equals( operator, "gt"   )) { kigo = ">";  }
		else if (SU.equals( operator, "lt"   )) { kigo = "<";  }
		else { throw new CareerSecurityException(); }
		
		StringBuilder sql = new StringBuilder();
		sql.append( "delete from JV_SRCH_RSLT_WK wk " );
		sql.append( " where wk.UPD_USER = ? " );
		sql.append( "   and wk.ROLE_ID = ? " );
		sql.append( "   and not exists ( " );
		sql.append( "         select * " );
		sql.append( "           from V_PZ_ALL pz " );
		sql.append( "                inner join JV_SRCH_RSLT_WK x " );
		sql.append( "                  on (x.SESSION_ID = ? and x.PARTY = ? and x.ROLE_ID = ? and x.GUID = ? " );
		sql.append( "                  and x.TGT_CMPA_CD = pz.CMPA_CD and x.TGT_STF_NO = pz.STF_NO) " );
		sql.append( "          where pz.PZ_ID = ? and pz.PZ_VAL " + kigo + " ? " );
		sql.append( "            and x.SESSION_ID = wk.SESSION_ID and pz.CMPA_CD = wk.TGT_CMPA_CD and pz.STF_NO = wk.TGT_STF_NO " );
		sql.append( "       ) " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( loginGuid );
		paramList.add( roleId );
		paramList.add( sessionId );
		paramList.add( party );
		paramList.add( roleId );
		paramList.add( loginGuid );
		paramList.add( pzId );
		paramList.add( searchVal );
		
		JvSrchRsltListDao dao = new JvSrchRsltListDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void deleteByQuickAll( String sessionId, String party, String loginGuid, String roleId, String searchVal ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "delete from JV_SRCH_RSLT_WK wk " );
		sql.append( " where wk.UPD_USER = ? " );
		sql.append( "   and wk.ROLE_ID = ? " );
		sql.append( "   and not exists ( " );
		sql.append( "         select * " );
		sql.append( "           from V_PZ_ALL pz " );
		sql.append( "                inner join JV_SRCH_RSLT_WK x " );
		sql.append( "                  on (x.SESSION_ID = ? and x.PARTY = ? and x.ROLE_ID = ? and x.GUID = ? " );
		sql.append( "                  and x.TGT_CMPA_CD = pz.CMPA_CD and x.TGT_STF_NO = pz.STF_NO) " );
		sql.append( "                inner join ( " );
		sql.append( "                    select qa.PZ_ID " );
		sql.append( "                      from JV_DF_QUICK_ALL qa " );
		sql.append( "                           inner join (select KOMOKU_ID from JV_PROF_KOMOKU_FILTER where PARTY = ? and ROLE_ID = ? and DISPLAY_MODE = 'visible') kf " );
		sql.append( "                             on (kf.KOMOKU_ID = qa.PZ_ID) " );
		sql.append( "                     where REGEXP_LIKE(?, qa.REQUIRED_FMT, 'i') " );
		sql.append( "                ) y on (y.PZ_ID = pz.PZ_ID) " );
		sql.append( "          where pz.PZ_VAL like ? " );
		sql.append( "            and x.SESSION_ID = wk.SESSION_ID and pz.CMPA_CD = wk.TGT_CMPA_CD and pz.STF_NO = wk.TGT_STF_NO " );
		sql.append( "       ) " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( loginGuid );
		paramList.add( roleId );
		paramList.add( sessionId );
		paramList.add( party );
		paramList.add( roleId );
		paramList.add( loginGuid );
		paramList.add( party );
		paramList.add( roleId );
		paramList.add( searchVal );
		paramList.add( "%" + searchVal + "%" );
		
		JvSrchRsltListDao dao = new JvSrchRsltListDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
}
