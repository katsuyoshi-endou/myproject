package jp.co.hisas.career.app.talent.garage;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.dao.JvSrchRsltWkDao;
import jp.co.hisas.career.app.talent.dao.JvTrMyfoldDao;
import jp.co.hisas.career.app.talent.dao.JvTrMyfoldPtcDao;
import jp.co.hisas.career.app.talent.dao.JvTrMyfoldTalentDao;
import jp.co.hisas.career.app.talent.dao.JvTrMysrchLogDao;
import jp.co.hisas.career.app.talent.dao.extra.GeneralMapDao;
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldDto;
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldPtcDto;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;

public class MyFoldGarage extends Garage {
	
	public MyFoldGarage(String daoLoginNo) {
		super( daoLoginNo );
	}
	
	public List<JvTrMyfoldDto> getPrivateMyfolderList( String party, String loginGuid ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select" + SU.addPrefixOnDaoAllCols( "m", JvTrMyfoldDao.ALLCOLS ) );
		sql.append( "  from JV_TR_MYFOLD m " );
		sql.append( "       inner join JV_TR_MYFOLD_PTC p " );
		sql.append( "         on (m.MYFOLD_ID = p.MYFOLD_ID) " );
		sql.append( "  where p.PARTY = ? " );
		sql.append( "    and p.GUID = ? " );
		sql.append( "    and m.SHARED_FLG = 0 " );
		sql.append( "  order by m.MYFOLD_NM " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( loginGuid );
		
		JvTrMyfoldDao dao = new JvTrMyfoldDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public List<JvTrMyfoldDto> getSharedMyfolderList( String party, String loginGuid ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select" + SU.addPrefixOnDaoAllCols( "m", JvTrMyfoldDao.ALLCOLS ) );
		sql.append( "  from JV_TR_MYFOLD m " );
		sql.append( "       inner join JV_TR_MYFOLD_PTC p " );
		sql.append( "         on (m.MYFOLD_ID = p.MYFOLD_ID) " );
		sql.append( "  where p.PARTY = ? " );
		sql.append( "    and p.GUID = ? " );
		sql.append( "    and m.SHARED_FLG = 1 " );
		sql.append( "  order by m.MYFOLD_NM " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( loginGuid );
		
		JvTrMyfoldDao dao = new JvTrMyfoldDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public List<Map<String, String>> getMyFolderListForPickup( String party, String loginGuid ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( " select myf.MYFOLD_ID, myf.MYFOLD_NM, myf.SHARED_FLG, ptc.OWNER_FLG, ptc.TAL_EDIT_FLG " );
		sql.append( "   from JV_TR_MYFOLD myf " );
		sql.append( "        inner join JV_TR_MYFOLD_PTC ptc " );
		sql.append( "          on (ptc.MYFOLD_ID = myf.MYFOLD_ID) " );
		sql.append( "  where PARTY = ? " );
		sql.append( "    and GUID = ? " );
		sql.append( "  order by myf.SHARED_FLG, myf.MYFOLD_NM " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( loginGuid );
		
		String[] cols = { "MYFOLD_ID", "MYFOLD_NM", "SHARED_FLG", "OWNER_FLG", "TAL_EDIT_FLG" };
		
		GeneralMapDao dao = new GeneralMapDao( this.daoLoginNo );
		return dao.select( cols, DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public JvTrMyfoldDto getMyfold( String myfoldId ) throws SQLException {
		JvTrMyfoldDao dao = new JvTrMyfoldDao( daoLoginNo );
		return dao.select( myfoldId );
	}
	
	public void insertMyfold( JvTrMyfoldDto dto ) {
		JvTrMyfoldDao dao = new JvTrMyfoldDao( daoLoginNo );
		dao.insert( dto );
	}
	
	public void insertMyfoldPtc( String myfoldId, String party, String guid ) {
		JvTrMyfoldPtcDao daoP = new JvTrMyfoldPtcDao( daoLoginNo );
		JvTrMyfoldPtcDto dtoP = new JvTrMyfoldPtcDto();
		dtoP.setMyfoldId( myfoldId );
		dtoP.setParty( party );
		dtoP.setGuid( guid );
		dtoP.setOwnerFlg( 1 );
		dtoP.setTalEditFlg( 1 );
		daoP.insert( dtoP );
	}
	
	public void updateMyfold( String myfoldId, String foldNm, String guid ) {
		String timestamp = AU.getTimestamp( "yyyy/MM/dd HH:mm:ss" );
		JvTrMyfoldDao dao = new JvTrMyfoldDao( daoLoginNo );
		JvTrMyfoldDto dto = dao.select( myfoldId );
		dto.setMyfoldNm( foldNm );
		dto.setUpdBy( guid );
		dto.setUpdAt( timestamp );
		dao.update( dto );
	}
	
	public void deleteMyfold( String myfoldId ) {
		JvTrMyfoldDao dao = new JvTrMyfoldDao( daoLoginNo );
		dao.delete( myfoldId );
	}
	
	public void deleteMyfoldPtc( String myfoldId ) {
		StringBuilder sql = new StringBuilder();
		sql.append( "delete from JV_TR_MYFOLD_PTC " );
		sql.append( " where MYFOLD_ID = ? " );
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( myfoldId );
		JvTrMyfoldPtcDao dao = new JvTrMyfoldPtcDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void deleteMyfoldTalent( String myfoldId ) {
		StringBuilder sql = new StringBuilder();
		sql.append( "delete from JV_TR_MYFOLD_TALENT " );
		sql.append( " where MYFOLD_ID = ? " );
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( myfoldId );
		JvTrMyfoldTalentDao daoT = new JvTrMyfoldTalentDao( daoLoginNo );
		daoT.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void insertFromFolder( String sessionId, String party, String guid, String myfoldId ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "insert into JV_SRCH_RSLT_WK " );
		sql.append( "select ?, ?, bd.GUID, bd.TGT_CMPA_CD, bd.TGT_STF_NO " );
		sql.append( "     , case when mf.SHARED_FLG = 1 then 'Public' else BD.ROLE_ID end " );
		sql.append( "     , ?, null " );
		sql.append( "  from JV_TR_MYFOLD_TALENT tf " );
		sql.append( "       inner join JV_TR_MYFOLD mf " );
		sql.append( "         on (mf.MYFOLD_ID = tf.MYFOLD_ID) " );
		sql.append( "       inner join JV_SRCH_BIND bd " );
		sql.append( "         on (bd.GUID = ? and bd.TGT_CMPA_CD = tf.TGT_CMPA_CD and bd.TGT_STF_NO = tf.TGT_STF_NO) " );
		sql.append( " where tf.MYFOLD_ID = ? " );
		sql.append( "   and tf.TGT_CMPA_CD in (select CMPA_CD from CA_PARTY_COMPANY) " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( sessionId );
		paramList.add( party );
		paramList.add( guid );
		paramList.add( guid );
		paramList.add( myfoldId );
		
		JvSrchRsltWkDao dao = new JvSrchRsltWkDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void removeTalent( String myfoldId, String sessionId, String wkIdx ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( " delete from JV_TR_MYFOLD_TALENT f" );
		sql.append( "  where f.MYFOLD_ID = ?" );
		sql.append( "    and exists (" );
		sql.append( "          select 'X'" );
		sql.append( "            from JV_SRCH_RSLT_WK w" );
		sql.append( "           where w.TGT_CMPA_CD = f.TGT_CMPA_CD" );
		sql.append( "             and w.TGT_STF_NO = f.TGT_STF_NO" );
		sql.append( "             and w.SESSION_ID = ?" );
		sql.append( "             and w.WK_IDX = ?" );
		sql.append( "        )" );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( myfoldId );
		paramList.add( sessionId );
		paramList.add( wkIdx );
		
		JvTrMyfoldTalentDao dao = new JvTrMyfoldTalentDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void addTalent( String myfoldId, String sessionId, String wkIdx ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( " insert into JV_TR_MYFOLD_TALENT f" );
		sql.append( " select ?, w.TGT_CMPA_CD, w.TGT_STF_NO" );
		sql.append( "   from JV_SRCH_RSLT_WK w" );
		sql.append( "  where w.SESSION_ID = ?" );
		sql.append( "    and w.WK_IDX = ?" );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( myfoldId );
		paramList.add( sessionId );
		paramList.add( wkIdx );
		
		JvTrMyfoldTalentDao dao = new JvTrMyfoldTalentDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void insertMyfoldLog( String myfoldId, String actBy, String actType, String actArg ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( " insert into JV_TR_MYFOLD_LOG " );
		sql.append( " select MYFOLD_ID, NEXT_SEQ, ?, ?, ?, to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') " );
		sql.append( "   from ( " );
		sql.append( "          select mys.MYFOLD_ID, max(nvl(sub.ACT_SEQ, 0)) + 1 as NEXT_SEQ " );
		sql.append( "            from JV_TR_MYFOLD mys " );
		sql.append( "                 left outer join JV_TR_MYFOLD_LOG sub " );
		sql.append( "                   on (mys.MYFOLD_ID = sub.MYFOLD_ID) " );
		sql.append( "           where mys.MYFOLD_ID = ? " );
		sql.append( "           group by mys.MYFOLD_ID " );
		sql.append( "        ) " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( actBy );
		paramList.add( actType );
		paramList.add( actArg );
		paramList.add( myfoldId );
		
		JvTrMysrchLogDao dao = new JvTrMysrchLogDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
}
