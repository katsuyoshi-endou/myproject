package jp.co.hisas.career.app.talent.garage;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.dao.JvTrMysrchCndLgcDao;
import jp.co.hisas.career.app.talent.dao.JvTrMysrchCndMltDao;
import jp.co.hisas.career.app.talent.dao.JvTrMysrchCndSglDao;
import jp.co.hisas.career.app.talent.dao.JvTrMysrchCndSlfDao;
import jp.co.hisas.career.app.talent.dao.JvTrMysrchDao;
import jp.co.hisas.career.app.talent.dao.JvTrMysrchLogDao;
import jp.co.hisas.career.app.talent.dao.JvTrMysrchPtcDao;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndLgcDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndMltDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndSglDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndSlfDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchPtcDto;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;

public class MySrchGarage extends Garage {
	
	public MySrchGarage(String daoLoginNo) {
		super( daoLoginNo );
	}
	
	public List<JvTrMysrchDto> getPrivateMysearchList( String party, String loginGuid ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select" + SU.addPrefixOnDaoAllCols( "m", JvTrMysrchDao.ALLCOLS ) );
		sql.append( "  from JV_TR_MYSRCH m " );
		sql.append( "       inner join JV_TR_MYSRCH_PTC p " );
		sql.append( "         on (m.MYSRCH_ID = p.MYSRCH_ID) " );
		sql.append( "  where p.PARTY = ? " );
		sql.append( "    and p.GUID = ? " );
		sql.append( "    and m.SHARED_FLG = 0 " );
		sql.append( "  order by m.MYSRCH_NM " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( loginGuid );
		
		JvTrMysrchDao dao = new JvTrMysrchDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public List<JvTrMysrchDto> getSharedMysearchList( String party, String loginGuid ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select" + SU.addPrefixOnDaoAllCols( "m", JvTrMysrchDao.ALLCOLS ) );
		sql.append( "  from JV_TR_MYSRCH m " );
		sql.append( "       inner join JV_TR_MYSRCH_PTC p " );
		sql.append( "         on (m.MYSRCH_ID = p.MYSRCH_ID) " );
		sql.append( "  where p.PARTY = ? " );
		sql.append( "    and p.GUID = ? " );
		sql.append( "    and m.SHARED_FLG = 1 " );
		sql.append( "  order by m.MYSRCH_NM " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( loginGuid );
		
		JvTrMysrchDao dao = new JvTrMysrchDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public JvTrMysrchDto getJvTrMysrch( String mysrchId ) {
		if (SU.isBlank( mysrchId )) {
			return new JvTrMysrchDto();
		}
		JvTrMysrchDao dao = new JvTrMysrchDao( daoLoginNo );
		return dao.select( mysrchId );
	}
	
	public void insertMysrch( String mysrchId, String mysrchNm, String guid, boolean isShared ) {
		String timestamp = AU.getTimestamp( "yyyy/MM/dd HH:mm:ss" );
		JvTrMysrchDao dao = new JvTrMysrchDao( daoLoginNo );
		JvTrMysrchDto dto = new JvTrMysrchDto();
		dto.setMysrchId( mysrchId );
		dto.setMysrchNm( mysrchNm );
		dto.setSharedFlg( isShared ? 1 : 0 );
		dto.setBindOnlyFlg( 1 );
		dto.setMadeBy( guid );
		dto.setMadeAt( timestamp );
		dto.setUpdBy( guid );
		dto.setUpdAt( timestamp );
		dao.insert( dto );
	}
	
	public void updateMysrch( String mysrchId, String mysrchNm, String guid ) {
		String timestamp = AU.getTimestamp( "yyyy/MM/dd HH:mm:ss" );
		JvTrMysrchDao dao = new JvTrMysrchDao( daoLoginNo );
		JvTrMysrchDto dto = dao.select( mysrchId );
		dto.setMysrchNm( mysrchNm );
		dto.setUpdBy( guid );
		dto.setUpdAt( timestamp );
		dao.update( dto );
	}
	
	public void insertMysrchPtc( String mysrchId, String party, String guid ) {
		JvTrMysrchPtcDao dao = new JvTrMysrchPtcDao( daoLoginNo );
		JvTrMysrchPtcDto dto = new JvTrMysrchPtcDto();
		dto.setMysrchId( mysrchId );
		dto.setParty( party );
		dto.setGuid( guid );
		dto.setOwnerFlg( 1 );
		dto.setCndEditFlg( 1 );
		dao.insert( dto );
	}
	
	public void insertMysrchCndSgl( String mysrchId, Map<String, String> singleMap ) {
		JvTrMysrchCndSglDao dao;
		for (Map.Entry<String, String> entry : singleMap.entrySet()) {
			if (SU.isNotBlank( entry.getValue() )) {
				JvTrMysrchCndSglDto dto = new JvTrMysrchCndSglDto();
				dto.setMysrchId( mysrchId );
				dto.setParamId( entry.getKey() );
				dto.setSearchValue( entry.getValue() );
				dao = new JvTrMysrchCndSglDao( daoLoginNo );
				dao.insert( dto );
			}
		}
	}
	
	public void insertMysrchCndMlt( String mysrchId, Map<String, Map<Integer, String[]>> multiMap ) {
		JvTrMysrchCndMltDao dao;
		for (Map.Entry<String, Map<Integer, String[]>> entry : multiMap.entrySet()) {
			String paramId = entry.getKey();
			Map<Integer, String[]> data = multiMap.get( paramId );
			for (Map.Entry<Integer, String[]> dataEntry : data.entrySet()) {
				int paramSeq = dataEntry.getKey();
				String[] code_srch = dataEntry.getValue();
				JvTrMysrchCndMltDto dto = new JvTrMysrchCndMltDto();
				dto.setMysrchId( mysrchId );
				dto.setParamId( paramId );
				dto.setParamSeq( paramSeq );
				dto.setCodeValue( code_srch[0] );
				dto.setSearchValue( code_srch[1] );
				dao = new JvTrMysrchCndMltDao( daoLoginNo );
				dao.insert( dto );
			}
		}
	}
	
	public void insertMysrchCndLgc( String mysrchId, List<JvTrMysrchCndLgcDto> lgcList ) {
		JvTrMysrchCndLgcDao dao;
		for (JvTrMysrchCndLgcDto dto : lgcList) {
			dao = new JvTrMysrchCndLgcDao( daoLoginNo );
			dto.setMysrchId( mysrchId );
			dao.insert( dto );
		}
	}
	
	public void insertMysrchCndSlf( String mysrchId, Map<String, Map<String, String>> shelfMap ) {
		JvTrMysrchCndSlfDao dao = new JvTrMysrchCndSlfDao( daoLoginNo );
		for (Map.Entry<String, Map<String, String>> entry : shelfMap.entrySet()) {
			String sectId = entry.getKey();
			// <PzId, Value[Kigo]>
			Map<String, String> queryMap = entry.getValue();
			for (Map.Entry<String, String> qe : queryMap.entrySet()) {
				String pzId  = qe.getKey();
				String qryKg = qe.getValue();
				String query = SU.extract( qryKg, "(.*)\\[.*\\]" );
				String kigo  = SU.extract( qryKg, ".*\\[(.*)\\]" );
				if (SU.isBlank( query )) {
					continue;
				}
				JvTrMysrchCndSlfDto dto = new JvTrMysrchCndSlfDto();
				dto.setMysrchId( mysrchId );
				dto.setSectId( sectId );
				dto.setKomokuId( pzId );
				dto.setQuery( query );
				dto.setKigoType( kigo );
				dao.insert( dto );
			}
		}
	}
	
	public void deleteMysrch( String mysrchId ) {
		JvTrMysrchDao dao = new JvTrMysrchDao( daoLoginNo );
		dao.delete( mysrchId );
	}
	
	public void deleteMysrchPtc( String mysrchId, String party, String guid ) {
		JvTrMysrchPtcDao dao = new JvTrMysrchPtcDao( daoLoginNo );
		dao.delete( mysrchId, party, guid );
	}
	
	public void deleteMysrchCndSgl( String mysrchId ) {
		StringBuilder sql = new StringBuilder();
		sql.append( "delete from JV_TR_MYSRCH_CND_SGL where MYSRCH_ID = ? " );
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( mysrchId );
		JvTrMysrchCndSglDao dao = new JvTrMysrchCndSglDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void deleteMysrchCndMlt( String mysrchId ) {
		StringBuilder sql = new StringBuilder();
		sql.append( "delete from JV_TR_MYSRCH_CND_MLT where MYSRCH_ID = ? " );
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( mysrchId );
		JvTrMysrchCndMltDao dao = new JvTrMysrchCndMltDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void deleteMysrchCndLgc( String mysrchId ) {
		StringBuilder sql = new StringBuilder();
		sql.append( "delete from JV_TR_MYSRCH_CND_LGC where MYSRCH_ID = ? " );
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( mysrchId );
		JvTrMysrchCndLgcDao dao = new JvTrMysrchCndLgcDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void deleteMysrchCndSlf( String mysrchId ) {
		StringBuilder sql = new StringBuilder();
		sql.append( "delete from JV_TR_MYSRCH_CND_SLF where MYSRCH_ID = ? " );
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( mysrchId );
		JvTrMysrchCndSlfDao dao = new JvTrMysrchCndSlfDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void insertMysrchLog( String mysrchId, String actBy, String actType, String actArg ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( " insert into JV_TR_MYSRCH_LOG " );
		sql.append( " select MYSRCH_ID, NEXT_SEQ, ?, ?, ?, to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') " );
		sql.append( "   from ( " );
		sql.append( "          select mys.MYSRCH_ID, max(nvl(sub.ACT_SEQ, 0)) + 1 as NEXT_SEQ " );
		sql.append( "            from JV_TR_MYSRCH mys " );
		sql.append( "                 left outer join JV_TR_MYSRCH_LOG sub " );
		sql.append( "                   on (mys.MYSRCH_ID = sub.MYSRCH_ID) " );
		sql.append( "           where mys.MYSRCH_ID = ? " );
		sql.append( "           group by mys.MYSRCH_ID " );
		sql.append( "        ) " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( actBy );
		paramList.add( actType );
		paramList.add( actArg );
		paramList.add( mysrchId );
		
		JvTrMysrchLogDao dao = new JvTrMysrchLogDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
}
