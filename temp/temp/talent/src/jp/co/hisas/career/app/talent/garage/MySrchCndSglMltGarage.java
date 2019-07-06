package jp.co.hisas.career.app.talent.garage;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.naming.NamingException;

import jp.co.hisas.career.app.talent.dao.JvSrchRsltListDao;
import jp.co.hisas.career.app.talent.dao.JvSrchRsltWkDao;
import jp.co.hisas.career.app.talent.dao.JvTrMysrchCndMltDao;
import jp.co.hisas.career.app.talent.dao.JvTrMysrchCndSglDao;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndMltDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndSglDto;
import jp.co.hisas.career.app.talent.mold.MysrchCndLgcMold;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;

public class MySrchCndSglMltGarage extends Garage {
	
	public MySrchCndSglMltGarage(String daoLoginNo) {
		super( daoLoginNo );
	}
	
	public HashMap<String, JvTrMysrchCndSglDto> getSavedMySearchSglMap( String mysrchId ) throws SQLException, NamingException {
		
		// 検索条件履歴_詳細_単一
		List<JvTrMysrchCndSglDto> sglList = selectMysrchCndSgl( mysrchId );
		HashMap<String, JvTrMysrchCndSglDto> sglMap = new HashMap<String, JvTrMysrchCndSglDto>();
		for (JvTrMysrchCndSglDto dto : sglList) {
			sglMap.put( dto.getParamId(), dto );
		}
		
		return sglMap;
	}
	
	private List<JvTrMysrchCndSglDto> selectMysrchCndSgl( String mysrchId ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + JvTrMysrchCndSglDao.ALLCOLS );
		sql.append( "  from JV_TR_MYSRCH_CND_SGL " );
		sql.append( "  where MYSRCH_ID = ? " );
		sql.append( "  order by PARAM_ID " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( mysrchId );
		
		JvTrMysrchCndSglDao dao = new JvTrMysrchCndSglDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public HashMap<String, JvTrMysrchCndMltDto> getSavedMySearchMltMap( String mysrchId ) throws SQLException, NamingException {
		
		// 検索条件履歴_詳細_複数
		List<JvTrMysrchCndMltDto> mltList = selectMysrchCndMlt( mysrchId );
		HashMap<String, JvTrMysrchCndMltDto> mltMap = new HashMap<String, JvTrMysrchCndMltDto>();
		
		JvTrMysrchCndMltDto saveDto = null;
		StringBuilder searchValue = new StringBuilder();
		StringBuilder codeValue = new StringBuilder();
		Iterator<JvTrMysrchCndMltDto> ite = mltList.iterator();
		
		while (ite.hasNext()) {
			JvTrMysrchCndMltDto dto = ite.next();
			
			if (saveDto == null) {
				searchValue.append( dto.getSearchValue() );
				codeValue.append( dto.getCodeValue() );
				
			// 一つ前のレコードとパラメータIDが同じ場合は文字列をカンマ区切りで繋げる
			} else if (saveDto.getParamId().equals( dto.getParamId() )) {
				searchValue.append( "," + dto.getSearchValue() );
				codeValue.append( "," + dto.getCodeValue() );
			// 一つ前のレコードとパラメータIDが異なる場合にカンマで繋げてきたデータをマップに格納する
			} else {
				saveDto.setSearchValue( searchValue.toString() );
				saveDto.setCodeValue( codeValue.toString() );
				mltMap.put( saveDto.getParamId(), saveDto );
				searchValue = new StringBuilder( dto.getSearchValue() );
				codeValue = new StringBuilder( dto.getCodeValue() );
			}
			saveDto = dto;
			// 最後のデータをマップに格納する
			if (!ite.hasNext()) {
				saveDto.setSearchValue( searchValue.toString() );
				saveDto.setCodeValue( codeValue.toString() );
				mltMap.put( saveDto.getParamId(), saveDto );
			}
		}
		return mltMap;
	}
	
	private List<JvTrMysrchCndMltDto> selectMysrchCndMlt( String mysrchId ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + JvTrMysrchCndMltDao.ALLCOLS );
		sql.append( "  from JV_TR_MYSRCH_CND_MLT " );
		sql.append( "  where MYSRCH_ID = ? " );
		sql.append( "  order by PARAM_ID, PARAM_SEQ " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( mysrchId );
		
		JvTrMysrchCndMltDao dao = new JvTrMysrchCndMltDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public void reduceByCondSglMlt( final String login_no, final MysrchCndLgcMold pzSearchBean ) {
		// 基本情報の検索
		if (pzSearchBean.shouldReduce( MysrchCndLgcMold.personalKeyList )) {
			reducePersonalJvSrchRsltWk( login_no, pzSearchBean );
		}
		// 所属の検索
		if (pzSearchBean.shouldReduce( MysrchCndLgcMold.shozokuKeyList )) {
			String reqpzid = "Mlt--commn_shozoku_cd";
			if (pzSearchBean.inUse( reqpzid )) {
				String deptCmpaCd  = pzSearchBean.scMap.get( "Mlt--commn_shozoku_cmpa_cd" );
				String startDeptCd = pzSearchBean.scMap.get( "Mlt--commn_shozoku_cd" );
				reduceByDeptConn( login_no, deptCmpaCd, startDeptCd );
			}
		}
		return;
	}
	
	private void reducePersonalJvSrchRsltWk( final String login_no, final MysrchCndLgcMold pzsb ) {
		StringBuilder sql = new StringBuilder();
		ArrayList<String> paramList = new ArrayList<String>();
		String reqpzid = null;
		sql.append( " delete from JV_SRCH_RSLT_WK WK " );
		sql.append( "  where UPD_USER = ? " ); paramList.add( login_no );
		sql.append( "    and not exists ( " );
		sql.append( "          select 1 " );
		sql.append( "            from PZ_HRZ_00HEADR_BX PZ00 " );
		sql.append( "                 left outer join PZ_HRZ_02SNJKI_BX PZ02 " );
		sql.append( "                   on (PZ02.CMPA_CD = PZ00.CMPA_CD and PZ02.STF_NO = PZ00.STF_NO) " );
		sql.append( "                 left outer join PZ_HRZ_05GAKRK_LT PZ05 " );
		sql.append( "                   on (PZ05.CMPA_CD = PZ00.CMPA_CD and PZ05.STF_NO = PZ00.STF_NO) " );
		sql.append( "           where PZ00.CMPA_CD = WK.TGT_CMPA_CD " );
		sql.append( "             and PZ00.STF_NO  = WK.TGT_STF_NO " );
		reqpzid = "Sgl--commn_simei_kana";
		if (pzsb.inUse( reqpzid )) {
			sql.append( "         and PZ00.PZ_VAL_03 like ? " ); paramList.add( pzsb.scMap.get( reqpzid ) + "%" );
		}
		reqpzid = "Sgl--commn_stf_no";
		if (pzsb.inUse( reqpzid )) {
			sql.append( "         and PZ00.PZ_VAL_02 like ? " ); paramList.add( "%" + pzsb.scMap.get( reqpzid ) + "%" );
		}
		reqpzid = "Sgl--sinjo_kihon_nen_r_start";
		if (pzsb.inUse( reqpzid )) {
			sql.append( "         and PZ02.PZ_VAL_16 >= to_number( ? ) " ); paramList.add( pzsb.scMap.get( reqpzid ) );
		}
		reqpzid = "Sgl--sinjo_kihon_nen_r_end";
		if (pzsb.inUse( reqpzid )) {
			sql.append( "         and PZ02.PZ_VAL_16 <= to_number( ? ) " ); paramList.add( pzsb.scMap.get( reqpzid ) );
		}
		reqpzid = "Sgl--sinjo_kihon_nen_k_start";
		if (pzsb.inUse( reqpzid )) {
			sql.append( "         and PZ02.PZ_VAL_15 >= to_number( ? ) " ); paramList.add( pzsb.scMap.get( reqpzid ) );
		}
		reqpzid = "Sgl--sinjo_kihon_nen_k_end";
		if (pzsb.inUse( reqpzid )) {
			sql.append( "         and PZ02.PZ_VAL_15 <= to_number( ? ) " ); paramList.add( pzsb.scMap.get( reqpzid ) );
		}
		reqpzid = "Sgl--commn_seibetu";
		if (pzsb.inUse( reqpzid )) {
			sql.append( "         and PZ00.PZ_VAL_06 = ? " ); paramList.add( pzsb.scMap.get( reqpzid ) );
		}
		reqpzid = "Mlt--commn_kinmuchi";
		if (pzsb.inUse( reqpzid )) {
			String kinmuchiCdNm = pzsb.scMap.get( reqpzid );
			String kinmuchiNm = SU.replaceAll( kinmuchiCdNm, "[0-9]{4}:", "" );
			sql.append( "         and PZ00.PZ_VAL_15 in " ); addInCondStr( sql, paramList, kinmuchiNm);
		}
		reqpzid = "Sgl--sinjo_kihon_kaigai_keiken";
		if (pzsb.inUse( reqpzid )) {
			sql.append( "         and PZ02.PZ_VAL_01 = ? " ); paramList.add( pzsb.scMap.get( reqpzid ) );
		}
		reqpzid = "Mlt--gkrek_saishu_gakureki";
		if (pzsb.inUse( reqpzid )) {
			sql.append( "         and PZ05.PZ_VAL_08 in " ); addInCondStr( sql, paramList, pzsb.scMap.get( reqpzid ));
		}
		reqpzid = "Mlt--sinjo_kihon_saiyou_kbn";
		if (pzsb.inUse( reqpzid )) {
			sql.append( "         and PZ02.PZ_VAL_02 in " ); addInCondStr( sql, paramList, pzsb.scMap.get( reqpzid ));
		}
		reqpzid = "Mlt--commn_sikaku";
		if (pzsb.inUse( reqpzid )) {
			sql.append( "         and PZ00.PZ_VAL_08 in " ); addInCondStr( sql, paramList, pzsb.scMap.get( reqpzid ));
		}
		reqpzid = "Mlt--commn_jugyoin_kbn";
		if (pzsb.inUse( reqpzid )) {
			sql.append( "         and PZ00.PZ_VAL_11 in " ); addInCondStr( sql, paramList, pzsb.scMap.get( reqpzid ));
		}
		reqpzid = "Mlt--gkrek_senko_cd";
		if (pzsb.inUse( reqpzid )) {
			sql.append( "         and PZ05.PZ_VAL_03 in " ); addInCondStr( sql, paramList, pzsb.scMap.get( reqpzid ));
		}
		sql.append( "        ) " );
		
		// 検索結果ワーク
		JvSrchRsltWkDao wkDao = new JvSrchRsltWkDao( this.daoLoginNo );
		wkDao.executeDynamic(  DaoUtil.getPstmt( sql, paramList )  );
		
		return;
	}
	
	private void addInCondStr( StringBuilder sql, List<String> paramList, String val ) {
		String[] valArray = val.split( "," );
		
		sql.append( " ( " );
		for (int i = 0; i < valArray.length; i++) {
			if (i > 0) {
				sql.append( ", " );
			}
			sql.append( "?" );
			paramList.add( valArray[i] );
		}
		sql.append( " ) " );
	}
	
	/**
	 * 検索結果WKに対し、指定した部署コードとその配下に所属していないレコードを削除する。
	 */
	private void reduceByDeptConn( String guid, String deptCmpaCd, String startDeptCd ) {
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "delete from JV_SRCH_RSLT_WK wk " );
		sql.append( " where wk.UPD_USER = ?" );
		sql.append( "   and (wk.TGT_CMPA_CD, wk.TGT_STF_NO) not in ( " );
		sql.append( "         select pb.CMPA_CD, pb.STF_NO " );
		sql.append( "           from ( select cn.CMPA_CD, cn.TGT_DEPT_CD from V_DEPT_CONNECT cn " );
		sql.append( "                   where cn.CMPA_CD = ? and cn.START_DEPT_CD = ?) tdp " );
		sql.append( "                inner join (select * from PERSON_BELONG union select * from PERSON_BELONG_KENMU ) pb " );
		sql.append( "                    on ( pb.CMPA_CD = tdp.CMPA_CD and pb.DEPT_CD = tdp.TGT_DEPT_CD ) " );
		sql.append( "       ) " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( guid );
		paramList.add( deptCmpaCd );
		paramList.add( startDeptCd );
		
		JvSrchRsltListDao dao = new JvSrchRsltListDao( this.daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
}
