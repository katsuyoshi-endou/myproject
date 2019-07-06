package jp.co.hisas.career.app.talent.garage;

import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.bean.LegacyKensakuDefBean;
import jp.co.hisas.career.app.talent.dao.JvSrchRsltWkDao;
import jp.co.hisas.career.app.talent.dao.JvTrMysrchCndLgcDao;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndLgcDto;
import jp.co.hisas.career.app.talent.mold.MysrchCndLgcMold;
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.util.common.PZZ010_CharacterUtil;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.dao.PersonZokuseiTeigiDao;
import jp.co.hisas.career.util.dto.PersonZokuseiTeigiDto;

public class MySrchCndLgcGarage extends Garage {
	
	public MySrchCndLgcGarage(String daoLoginNo) {
		super( daoLoginNo );
	}
	
	public List<JvTrMysrchCndLgcDto> selectMysrchCndLgcList( String mysrchId ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select" + JvTrMysrchCndLgcDao.ALLCOLS );
		sql.append( "  from JV_TR_MYSRCH_CND_LGC " );
		sql.append( " where MYSRCH_ID = ? " );
		sql.append( " order by LGC_ROW_NO, TAB_ID, PARAM_ID " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( mysrchId );
		
		JvTrMysrchCndLgcDao dao = new JvTrMysrchCndLgcDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public int execLegacySearch( final String loginGuid, final String sessionId, final MysrchCndLgcMold pzsb, boolean isShared ) {
		
		ArrayList<String> paramList = new ArrayList<String>();
		int personCnt = 0;
		
		// 現在の日付を取得
		String systemYMD = PZZ010_CharacterUtil.GetDay();
		systemYMD = systemYMD.substring( 0, 4 ) + "/" + systemYMD.substring( 4, 6 ) + "/" + systemYMD.substring( 6, 8 );
		String systemHMS = PZZ010_CharacterUtil.GetTime();
		systemHMS = systemHMS.substring( 0, 2 ) + ":" + systemHMS.substring( 2, 4 );
		
		// 検索結果人ワーク
		JvSrchRsltWkDao wkDao = new JvSrchRsltWkDao( loginGuid );
		
		/* 検索結果人ワークに検索結果を格納する */
		PersonZokuseiTeigiDao pZokuseiTeigiDao = new PersonZokuseiTeigiDao( loginGuid );
		List<PersonZokuseiTeigiDto> pZokuseiTeigiDtoList = pZokuseiTeigiDao.selectPersonZokuseiAll();
		final LegacyKensakuDefBean legacyKensakuDefBean = new LegacyKensakuDefBean();
		for (final PersonZokuseiTeigiDto dto : pZokuseiTeigiDtoList) {
			legacyKensakuDefBean.putPersonZokuseiTeigiDtoMap( dto.getPersonZokuseiId(), dto );
		}
		String party = pzsb.party;
		String personId = loginGuid;
		ArrayList<String[]> conditionList = new ArrayList<String[]>();
		if (pzsb.isRow1Valid()) {
			String pzTable = legacyKensakuDefBean.getPersonZokuseiTeigiDtoMap( pzsb.row1ZokuseiId ).getButsuriKakunoSaki();
			if (pzTable == null) throw new CareerRuntimeException( "Couldn't get table difinition: " + pzsb.row1PzId );
			String cond[] = { pzTable, pzsb.row1ZokuseiId, pzsb.row1Query, pzsb.row1Kigo };
			conditionList.add( cond );
		}
		if (pzsb.isRow2Valid()) {
			String pzTable = legacyKensakuDefBean.getPersonZokuseiTeigiDtoMap( pzsb.row2ZokuseiId ).getButsuriKakunoSaki();
			if (pzTable == null) throw new CareerRuntimeException( "Couldn't get table difinition: " + pzsb.row2PzId );
			String cond[] = { pzTable, pzsb.row2ZokuseiId, pzsb.row2Query, pzsb.row2Kigo };
			conditionList.add( cond );
		}
		if (pzsb.isRow3Valid()) {
			String pzTable = legacyKensakuDefBean.getPersonZokuseiTeigiDtoMap( pzsb.row3ZokuseiId ).getButsuriKakunoSaki();
			if (pzTable == null) throw new CareerRuntimeException( "Couldn't get table difinition: " + pzsb.row3PzId );
			String cond[] = { pzTable, pzsb.row3ZokuseiId, pzsb.row3Query, pzsb.row3Kigo };
			conditionList.add( cond );
		}
		if (pzsb.isRow4Valid()) {
			String pzTable = legacyKensakuDefBean.getPersonZokuseiTeigiDtoMap( pzsb.row4ZokuseiId ).getButsuriKakunoSaki();
			if (pzTable == null) throw new CareerRuntimeException( "Couldn't get table difinition: " + pzsb.row4PzId );
			String cond[] = { pzTable, pzsb.row4ZokuseiId, pzsb.row4Query, pzsb.row4Kigo };
			conditionList.add( cond );
		}
		if (pzsb.isRow5Valid()) {
			String pzTable = legacyKensakuDefBean.getPersonZokuseiTeigiDtoMap( pzsb.row5ZokuseiId ).getButsuriKakunoSaki();
			if (pzTable == null) throw new CareerRuntimeException( "Couldn't get table difinition: " + pzsb.row5PzId );
			String cond[] = { pzTable, pzsb.row5ZokuseiId, pzsb.row5Query, pzsb.row5Kigo };
			conditionList.add( cond );
		}
		
		String insertSql = "";
		insertSql += "insert into JV_SRCH_RSLT_WK ";
		insertSql += " select '" + sessionId + "' AS SESSION_ID ";
		insertSql += "      , '" + party + "'     AS PARTY ";
		insertSql += "      , '" + personId + "'  AS GUID ";
		insertSql += "      , RSLT1.TGT_CMPA_CD   AS TGT_CMPA_CD ";
		insertSql += "      , RSLT1.TGT_STF_NO    AS TGT_STF_NO ";
		if (isShared) {
		insertSql += "      , 'Public'            AS ROLE_ID ";
		} else {
		insertSql += "      , RSLT1.ROLE_ID       AS ROLE_ID ";
		}
		insertSql += "      , '" + personId + "'  AS UPD_USER ";
		insertSql += "      , null                AS WK_IDX ";
		insertSql += "   from ";
		
		// 絞り込み条件に何も入力されていない場合は全件検索を行う
		if (conditionList.size() == 0) {
			insertSql += " ( ";
			insertSql += " select TGT_CMPA_CD ";
			insertSql += "      , TGT_STF_NO ";
			insertSql += "      , ROLE_ID ";
			insertSql += "   from JV_SRCH_BIND ";
			insertSql += "  where GUID = '"+ personId+ "' ";
			insertSql += "    and TGT_CMPA_CD in (select CMPA_CD from CA_PARTY_COMPANY where PARTY = '" + party + "') ";
			insertSql += " )RSLT1 ";
		}
		
		for (int i = 0; i < conditionList.size(); i++) {
			if (i > 0) {
				insertSql += " inner join ";
			}
			insertSql += makePZSearchSubQuerySQL( i + 1, conditionList.get( i )[0], party, personId, conditionList.get( i )[1], conditionList.get( i )[3], isShared );
			if (i > 0) {
				insertSql += " on (RSLT1.TGT_STF_NO = RSLT" + (i + 1) + ".TGT_STF_NO and RSLT1.TGT_CMPA_CD = RSLT" + (i + 1) + ".TGT_CMPA_CD) ";
			}
			paramList.add( conditionList.get( i )[1] );
			paramList.add( makeOperand( conditionList.get( i )[2], conditionList.get( i )[3] ) );
		}
		
		wkDao.executeDynamic(  DaoUtil.getPstmt( insertSql, paramList )  );
		
		return personCnt;
	}
	
	private String makePZSearchSubQuerySQL( int queryNo, String pzTable, String party, String guid, String pzId, String kigoType, boolean isShared ) {
		
		String whereString = "";
		String nullSrchStr = "";
		if (kigoType == null || "".equals( kigoType )) {
			whereString = " pz.PZ_VAL = ";
		} else if ("0".equals( kigoType )) {
			// である
			whereString = " pz.PZ_VAL = ";
		} else if ("1".equals( kigoType )) {
			// でない
			whereString = " pz.PZ_VAL is null or pz.PZ_VAL <> ";
			nullSrchStr = " or (PZ.PZ_ID is null)";
		} else if ("2".equals( kigoType )) {
			// を含む
			whereString = " pz.PZ_VAL like ";
		} else if ("3".equals( kigoType )) {
			// を含まない
			whereString = " pz.PZ_VAL is null or pz.PZ_VAL not like ";
			nullSrchStr = " or (PZ.PZ_ID is null)";
		} else if ("4".equals( kigoType )) {
			// 以上
			whereString = " pz.PZ_VAL >= ";
		} else if ("5".equals( kigoType )) {
			// 以下
			whereString = " pz.PZ_VAL <= ";
		} else if ("8".equals( kigoType )) {
			// で始まる
			whereString = " pz.PZ_VAL like ";
		} else {
			whereString = " pz.PZ_VAL = ";
		}
		
		String insertSql = "";
		insertSql += "        ( ";
		insertSql += "          select distinct ";
		insertSql += "                 bd.TGT_CMPA_CD as TGT_CMPA_CD ";
		insertSql += "               , bd.TGT_STF_NO  as TGT_STF_NO ";
		insertSql += "               , bd.ROLE_ID     as ROLE_ID ";
		insertSql += "            from JV_SRCH_BIND bd ";
		insertSql += "                   inner join CA_PARTY_COMPANY pc ";
		insertSql += "                     on (pc.PARTY = '" + party + "' ";
		insertSql += "                     and pc.CMPA_CD = bd.TGT_CMPA_CD) ";
	    insertSql += "                   left outer join " + pzTable + " pz ";
		insertSql += "                     on (pz.CMPA_CD = bd.TGT_CMPA_CD ";
	    insertSql += "                     and pz.STF_NO  = bd.TGT_STF_NO ";
	    insertSql += "                     and pz.PZ_ID = '" + pzId + "' )";
	    insertSql += "                   left outer join JV_PROF_KOMOKU_FILTER kf ";
		insertSql += "                     on (kf.PARTY        = '" + party + "' ";
		if (isShared) {
		insertSql += "                     and kf.ROLE_ID      = 'Public' ";
		} else {
		insertSql += "                     and kf.ROLE_ID      = bd.ROLE_ID ";
		}
		insertSql += "                     and kf.KOMOKU_ID    = pz.PZ_ID ";
		insertSql += "                     and kf.KOMOKU_ID    = ? ";// --★
		insertSql += "                     and kf.DISPLAY_MODE = 'visible') ";
		insertSql += "           where ";
		insertSql += "                 bd.GUID = '" + guid + "' ";
	    insertSql += "             and (( pz.PZ_ID = '" + pzId + "' ";
		insertSql += "             and ( " + whereString + " ? ) ";// --★
	    insertSql += "             and kf.DISPLAY_MODE = 'visible') ";
	    insertSql += "             " + nullSrchStr + ") ";
		insertSql += "        ) RSLT" + queryNo + " ";
		return insertSql;
	}
	
	/**
	 * 記号タイプに応じて LIKE 用に ? に入れる文字列に % を追加する。
	 */
	private String makeOperand( String operand, String kigoType ) {
		String newOperand = "";
		if (kigoType == null || "".equals( kigoType )) {
			newOperand = "";
		} else if ("0".equals( kigoType )) {
			// である
			newOperand = operand;
		} else if ("1".equals( kigoType )) {
			// でない
			newOperand = operand;
		} else if ("2".equals( kigoType )) {
			// を含む
			newOperand = "%" + operand + "%";
		} else if ("3".equals( kigoType )) {
			// を含まない
			newOperand = "%" + operand + "%";
		} else if ("4".equals( kigoType )) {
			// 以上
			newOperand = operand;
		} else if ("5".equals( kigoType )) {
			// 以下
			newOperand = operand;
		} else if ("8".equals( kigoType )) {
			// で始まる
			newOperand = operand + "%";
		} else {
			newOperand = "";
		}
		return newOperand;
	}
	
}
