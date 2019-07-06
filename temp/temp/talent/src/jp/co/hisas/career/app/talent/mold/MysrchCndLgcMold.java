package jp.co.hisas.career.app.talent.mold;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import jp.co.hisas.career.app.talent.bean.LegacyKensakuDefBean;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndLgcDto;
import jp.co.hisas.career.app.talent.dto.KensakuCategoryDto;
import jp.co.hisas.career.app.talent.dto.KensakuKigoDto;
import jp.co.hisas.career.app.talent.dto.KensakuKomokuDto;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;

public class MysrchCndLgcMold implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	public static final String SESSION_KEY = "PZSearchCondBean";
	
	public String party;
	
	// row1
	public boolean row1IsChecked;
	public String row1TabId;
	public String row1TabName;
	public String row1PzId;
	public String row1PzName;
	public String row1ZokuseiId;
	public String row1Query;
	public String row1Kigo;
	public String row1KigoName;
	// row2
	public boolean row2IsChecked;
	public String row2TabId;
	public String row2TabName;
	public String row2PzId;
	public String row2PzName;
	public String row2ZokuseiId;
	public String row2Query;
	public String row2Kigo;
	public String row2KigoName;
	// row3
	public boolean row3IsChecked;
	public String row3TabId;
	public String row3TabName;
	public String row3PzId;
	public String row3PzName;
	public String row3ZokuseiId;
	public String row3Query;
	public String row3Kigo;
	public String row3KigoName;
	// row4
	public boolean row4IsChecked;
	public String row4TabId;
	public String row4TabName;
	public String row4PzId;
	public String row4PzName;
	public String row4ZokuseiId;
	public String row4Query;
	public String row4Kigo;
	public String row4KigoName;
	// row5
	public boolean row5IsChecked;
	public String row5TabId;
	public String row5TabName;
	public String row5PzId;
	public String row5PzName;
	public String row5ZokuseiId;
	public String row5Query;
	public String row5Kigo;
	public String row5KigoName;
	
	public Map<String, String> scMap = new HashMap<String, String>();
	
	// リクエストから取得したパラメータをマップに保持する際に使用するキー
	public static List<String> registKeyList = Arrays.asList( "Sgl--currentstatus_except_retire", "Sgl--currentstatus_except_remove" );
	public static List<String> personalKeyList = Arrays.asList( "Sgl--isGensyokuOnly", "Sgl--commn_simei_kana", "Sgl--commn_stf_no", "Sgl--sinjo_kihon_nen_r_start", "Sgl--sinjo_kihon_nen_r_end", "Sgl--sinjo_kihon_nen_k_start", "Sgl--sinjo_kihon_nen_k_end", "Sgl--commn_seibetu", "Mlt--commn_kinmuchi", "Mlt--commn_kinmuchi_cd", "Sgl--sinjo_kihon_kaigai_keiken", "Mlt--gkrek_saishu_gakureki", "Mlt--gkrek_saishu_gakureki_cd", "Mlt--sinjo_kihon_saiyou_kbn", "Mlt--sinjo_kihon_saiyou_kbn_cd", "Mlt--commn_sikaku", "Mlt--commn_sikaku_cd", "Mlt--commn_jugyoin_kbn",
			"Mlt--commn_jugyoin_kbn_cd", "Mlt--gkrek_senko", "Mlt--gkrek_senko_cd" );
	public static List<String> shozokuKeyList = Arrays.asList( "Mlt--commn_shozoku", "Mlt--commn_shozoku_cd", "Mlt--commn_shozoku_cmpa", "Mlt--commn_shozoku_cmpa_cd" );
	public static List<String> hyokaKeyList = Arrays.asList( "Sgl--mbohk_taishoki_cd_shoyo", "Mlt--mbohk_shoyo_hyoka", "Mlt--mbohk_shoyo_hyoka_cd", "Sgl--mbohk_taishoki_cd_shokyu", "Mlt--mbohk_shoky_hyoka", "Mlt--mbohk_shoky_hyoka_cd" );
	public static List<String> pastHyokaKeyList = Arrays.asList( "Sgl--mbohk_kako_shoyo_chokkin", "Sgl--mbohk_kako_shoyo_hyoka_joken", "Sgl--mbohk_kako_shoyo_hyoka_cd_etc", "Sgl--mbohk_kako_shoyo_hyoka_kyokaichi", "Sgl--mbohk_kako_shoky_chokkin", "Sgl--mbohk_kako_shoky_hyoka_joken", "Sgl--mbohk_kako_shoky_hyoka_cd_etc", "Sgl--mbohk_kako_shoky_hyoka_kyokaichi" );
	public static List<String> shikakuKeyList = Arrays.asList( "Sgl--toeic_start", "Sgl--toeic_end", "Mlt--sikak_naiyo", "Mlt--sikak_naiyo_cd", "Mlt--kyoik_kyoikukenshu", "Mlt--kyoik_kyoikukenshu_cd" );
	public static List<String> ginouKeyList = Arrays.asList( "Mlt--ginou_hoyu", "Mlt--ginou_hoyu_cd", "Mlt--ginou_hoyu_keiken_nensu", "Mlt--ginou_hoyu_keiken_nensu_cd", "Mlt--ginou_hoyu_level", "Mlt--ginou_hoyu_level_cd", "Sgl--ginou_hoyu_geneki_kbn", "Sgl--ginou_hoyu_tuyomi" );
	public static List<String> shokumuKeyList = Arrays.asList( "Sgl--shokm_theme", "Sgl--shokm_gaiyo", "Sgl--shokm_member", "Sgl--shokm_tool" );
	public static List<String> segmentList = Arrays.asList( "Sgl--segment", "Sgl--segmentlw" );
	// 上記キーリストのセット
	public static List<List<String>> sectionSearchKeyListSet = Arrays.asList(
		registKeyList,
		personalKeyList,
		shozokuKeyList,
		hyokaKeyList,
		pastHyokaKeyList,
		shikakuKeyList,
		ginouKeyList,
		shokumuKeyList,
		segmentList
	);

	public boolean inUse( String key ) {
		if (scMap == null) {
			return false;
		}
		if (!scMap.containsKey( key )) {
			return false;
		}
		String val = scMap.get( key );
		if (val == null || "".equals( val )) {
			return false;
		}
		return true;
	}
	
	public boolean shouldReduce( List<String> keyList ) {
		for (String key : keyList) {
			if (inUse( key )) {
				return true;
			}
		}
		return false;
	}
		
	public boolean isRow1Valid() {
		return row1IsChecked && isDataExists(row1TabId) && isDataExists(row1PzId) && isDataExists(row1Query) && isDataExists(row1Kigo);
	}
	
	public boolean isRow2Valid() {
		return row2IsChecked && isDataExists(row2TabId) && isDataExists(row2PzId) && isDataExists(row2Query) && isDataExists(row2Kigo);
	}
	
	public boolean isRow3Valid() {
		return row3IsChecked && isDataExists(row3TabId) && isDataExists(row3PzId) && isDataExists(row3Query) && isDataExists(row3Kigo);
	}
	
	public boolean isRow4Valid() {
		return row4IsChecked && isDataExists(row4TabId) && isDataExists(row4PzId) && isDataExists(row4Query) && isDataExists(row4Kigo);
	}
	
	public boolean isRow5Valid() {
		return row5IsChecked && isDataExists(row5TabId) && isDataExists(row5PzId) && isDataExists(row5Query) && isDataExists(row5Kigo);
	}
	
	private boolean isDataExists( String str ) {
		return (str != null && !"".equals( str ));
	}
	
	public static Map<String, String> makeHistDtlSglMap( HttpServletRequest req ) {
		Map<String, String> map = new HashMap<String, String>();
		for (List<String> keyList : MysrchCndLgcMold.sectionSearchKeyListSet) {
			for (String key : keyList) {
				if (!key.matches( "^Sgl--.*$" )) {
					continue;
				}
				String paramId = SU.replace( key, "Sgl--", "" );
				String val = AU.getRequestValue( req, key );
				if (SU.isNotBlank( val )) {
					map.put( paramId, val );
				}
			}
		}
		return map;
	}
	
	public static Map<String, Map<Integer, String[]>> makeHistDtlMltMap( HttpServletRequest req ) {
		Map<String, Map<Integer, String[]>> map = new HashMap<String, Map<Integer, String[]>>();
		for (List<String> keyList : MysrchCndLgcMold.sectionSearchKeyListSet) {
			for (String key : keyList) {
				if (!key.matches( "^Mlt--.*$" )) {
					continue;
				}
				String paramId = SU.replace( key, "Mlt--", "" );
				Map<Integer, String[]> innerMap = makeHistDtlMltMapInner( req, key );
				if (innerMap != null) {
					map.put( paramId, innerMap );
				}
			}
		}
		return map;
	}
	
	public static Map<Integer, String[]> makeHistDtlMltMapInner( HttpServletRequest req, String key ) {
		// <PARAM_SEQ, [CODE_VALUE, SEARCH_VALUE]>
		Map<Integer, String[]> innerMap = new LinkedHashMap<Integer, String[]>();
		String codeValueStr = AU.getRequestValue( req, key + "_cd" );
		if (SU.isBlank( codeValueStr )) {
			return null;
		}
		String srchValueStr = AU.getRequestValue( req, key );
		if (SU.isNotBlank( codeValueStr )) {
			String[] codeVals = codeValueStr.split( "," );
			String[] srchVals = srchValueStr.split( "," );
			for (int i = 0; i < codeVals.length; i++) {
				String[] code_srch = { codeVals[i], srchVals[i] };
				innerMap.put( i + 1, code_srch );
			}
		}
		return innerMap;
	}
	
	public static List<JvTrMysrchCndLgcDto> makeHistDtlLegacy( HttpServletRequest req, String guid, String mysrchId ) {
		List<JvTrMysrchCndLgcDto> list = new ArrayList<JvTrMysrchCndLgcDto>();
		for (int i = 1; i <= 5; i++) {
			String row = "row" + i;
			String chk = AU.getRequestValue( req, row + "Checkbox" );
			if (SU.equals( chk, "true" )) {
				String tabId = AU.getRequestValue( req, row + "TabId" );
				String pzId  = AU.getRequestValue( req, row + "PzId" );
				String kigo  = AU.getRequestValue( req, row + "Kigo" );
				if ( SU.isBlank( tabId ) || SU.isBlank( pzId )|| SU.isBlank( kigo ) ) {
					continue;
				}
				JvTrMysrchCndLgcDto dto = new JvTrMysrchCndLgcDto();
				dto.setMysrchId( mysrchId );
				dto.setLgcRowNo( i );
				dto.setTabId( tabId );
				dto.setParamId( pzId );
				dto.setSearchValue( AU.getRequestValue( req, row + "Query" ) );
				dto.setKigoType( kigo );
				list.add( dto );
			}
		}
		return list;
	}
	
	public static MysrchCndLgcMold makePzSearchBean( String party, List<JvTrMysrchCndLgcDto> lgcList ) {
		if (lgcList == null) {
			return null;
		}
		MysrchCndLgcMold bean = new MysrchCndLgcMold();
		bean.party = party;
		// row1
		if ( lgcList.size() > 0 ){
			bean.row1IsChecked = true;
			bean.row1TabId = SU.ntb( lgcList.get(0).getTabId() );
			bean.row1PzId  = SU.ntb( lgcList.get(0).getParamId() );
			bean.row1Query = SU.ntb( lgcList.get(0).getSearchValue() );
			bean.row1Kigo  = SU.ntb( lgcList.get(0).getKigoType() );
		}
		// row2
		if ( lgcList.size() > 1 ){
			bean.row2IsChecked = true;
			bean.row2TabId = SU.ntb( lgcList.get(1).getTabId() );
			bean.row2PzId  = SU.ntb( lgcList.get(1).getParamId() );
			bean.row2Query = SU.ntb( lgcList.get(1).getSearchValue() );
			bean.row2Kigo  = SU.ntb( lgcList.get(1).getKigoType() );
		}
		// row3
		if ( lgcList.size() > 2 ){
			bean.row3IsChecked = true;
			bean.row3TabId = SU.ntb( lgcList.get(2).getTabId() );
			bean.row3PzId  = SU.ntb( lgcList.get(2).getParamId() );
			bean.row3Query = SU.ntb( lgcList.get(2).getSearchValue() );
			bean.row3Kigo  = SU.ntb( lgcList.get(2).getKigoType() );
		}
		// row4
		if ( lgcList.size() > 3 ){
			bean.row4IsChecked = true;
			bean.row4TabId = SU.ntb( lgcList.get(3).getTabId() );
			bean.row4PzId  = SU.ntb( lgcList.get(3).getParamId() );
			bean.row4Query = SU.ntb( lgcList.get(3).getSearchValue() );
			bean.row4Kigo  = SU.ntb( lgcList.get(3).getKigoType() );
		}
		// row5
		if ( lgcList.size() > 4 ){
			bean.row5IsChecked = true;
			bean.row5TabId = SU.ntb( lgcList.get(4).getTabId() );
			bean.row5PzId  = SU.ntb( lgcList.get(4).getParamId() );
			bean.row5Query = SU.ntb( lgcList.get(4).getSearchValue() );
			bean.row5Kigo  = SU.ntb( lgcList.get(4).getKigoType() );
		}
		return bean;
	}
	
	public static void updateLgcKensakuInfo( MysrchCndLgcMold cond, LegacyKensakuDefBean kensakuInfo ) {
		if (cond == null || kensakuInfo == null) {
			return;
		}
		if (cond.row1IsChecked) {
			cond.row1TabName = getKensakuCategoryNameById( kensakuInfo, cond.row1TabId );
			cond.row1PzName = getKensakuKomokuNameById( kensakuInfo, cond.row1TabId, cond.row1PzId );
			cond.row1KigoName = getKensakuKigoNameByKigoType( kensakuInfo, cond.row1PzId, cond.row1Kigo );
			cond.row1ZokuseiId = getKensakuPersonZokuseiIdByKomokuId( kensakuInfo, cond.row1TabId, cond.row1PzId );
		}
		if (cond.row2IsChecked) {
			cond.row2TabName = getKensakuCategoryNameById( kensakuInfo, cond.row2TabId );
			cond.row2PzName = getKensakuKomokuNameById( kensakuInfo, cond.row2TabId, cond.row2PzId );
			cond.row2KigoName = getKensakuKigoNameByKigoType( kensakuInfo, cond.row2PzId, cond.row2Kigo );
			cond.row2ZokuseiId = getKensakuPersonZokuseiIdByKomokuId( kensakuInfo, cond.row2TabId, cond.row2PzId );
		}
		if (cond.row3IsChecked) {
			cond.row3TabName = getKensakuCategoryNameById( kensakuInfo, cond.row3TabId );
			cond.row3PzName = getKensakuKomokuNameById( kensakuInfo, cond.row3TabId, cond.row3PzId );
			cond.row3KigoName = getKensakuKigoNameByKigoType( kensakuInfo, cond.row3PzId, cond.row3Kigo );
			cond.row3ZokuseiId = getKensakuPersonZokuseiIdByKomokuId( kensakuInfo, cond.row3TabId, cond.row3PzId );
		}
		if (cond.row4IsChecked) {
			cond.row4TabName = getKensakuCategoryNameById( kensakuInfo, cond.row4TabId );
			cond.row4PzName = getKensakuKomokuNameById( kensakuInfo, cond.row4TabId, cond.row4PzId );
			cond.row4KigoName = getKensakuKigoNameByKigoType( kensakuInfo, cond.row4PzId, cond.row4Kigo );
			cond.row4ZokuseiId = getKensakuPersonZokuseiIdByKomokuId( kensakuInfo, cond.row4TabId, cond.row4PzId );
		}
		if (cond.row5IsChecked) {
			cond.row5TabName = getKensakuCategoryNameById( kensakuInfo, cond.row5TabId );
			cond.row5PzName = getKensakuKomokuNameById( kensakuInfo, cond.row5TabId, cond.row5PzId );
			cond.row5KigoName = getKensakuKigoNameByKigoType( kensakuInfo, cond.row5PzId, cond.row5Kigo );
			cond.row5ZokuseiId = getKensakuPersonZokuseiIdByKomokuId( kensakuInfo, cond.row5TabId, cond.row5PzId );
		}
	}
	
	private static String getKensakuCategoryNameById( LegacyKensakuDefBean kensakuInfo, String categoryId ) {
		String categoryName = "";
		ArrayList<KensakuCategoryDto> categoryList = kensakuInfo.getKensakuCategoryDtoList();
		for (int i = 0; i < categoryList.size(); i++) {
			KensakuCategoryDto dto = categoryList.get( i );
			if (categoryId.equals( dto.getKensakuCategoryId() )) {
				categoryName = dto.getKensakuCategoryName();
				break;
			}
		}
		return categoryName;
	}
	
	private static String getKensakuKomokuNameById( LegacyKensakuDefBean kensakuInfo, String categoryId, String komokuId ) {
		String komokuName = "";
		ArrayList<KensakuKomokuDto> komokuList = kensakuInfo.getKensakuKomokuDtoList( categoryId );
		for (int i = 0; i < komokuList.size(); i++) {
			KensakuKomokuDto dto = komokuList.get( i );
			if (komokuId.equals( dto.getKensakuKomokuId() )) {
				komokuName = dto.getKensakuKomokuName();
				break;
			}
		}
		return komokuName;
	}
	
	private static String getKensakuPersonZokuseiIdByKomokuId( LegacyKensakuDefBean kensakuInfo, String categoryId, String komokuId ) {
		String personZokuseiId = "";
		ArrayList<KensakuKomokuDto> komokuList = kensakuInfo.getKensakuKomokuDtoList( categoryId );
		for (int i = 0; i < komokuList.size(); i++) {
			KensakuKomokuDto dto = komokuList.get( i );
			if (komokuId.equals( dto.getKensakuKomokuId() )) {
				personZokuseiId = dto.getPersonZokuseiId();
				break;
			}
		}
		return personZokuseiId;
	}
	
	private static String getKensakuKigoNameByKigoType( LegacyKensakuDefBean kensakuInfo, String komokuId, String kigoType ) {
		String kigoName = "";
		ArrayList<KensakuKigoDto> kigoList = kensakuInfo.getKensakuKigoDtoList( komokuId );
		for (int i = 0; i < kigoList.size(); i++) {
			KensakuKigoDto dto = kigoList.get( i );
			if (kigoType.equals( dto.getKigoType() )) {
				kigoName = dto.getHyojiName();
				break;
			}
		}
		return kigoName;
	}
	
}
