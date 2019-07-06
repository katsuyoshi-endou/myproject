package jp.co.hisas.career.app.talent.servlet;

import java.util.Map;

import com.google.gson.Gson;

import jp.co.hisas.career.app.talent.api.mysearch.MySearchEvRslt;
import jp.co.hisas.career.app.talent.deliver.MySearchDeliver;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndMltDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndSglDto;
import jp.co.hisas.career.app.talent.mold.MySearchMold;
import jp.co.hisas.career.app.talent.mold.MysrchCndLgcMold;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.NewTokenServlet;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.bean.OutLogBean;
import jp.co.hisas.career.util.log.bean.OutSousaLogArg;

public class SearchTalentsServlet extends NewTokenServlet {
	
	private static final long serialVersionUID = 1L;
	private static final String KINOU_ID = "VDD010";
	private static final String FORWARD_PAGE = "/servlet/ShowResultServlet?state=SEARCH";
	
	public String serviceMain( Tray tray ) throws Exception {
		
		/* This Logic to be MySearchButler */
		takeGET( tray );
		
		// 操作ログ
		OutSousaLogArg sousaLogArg = new OutSousaLogArg();
		sousaLogArg.setLogonShimeiNo( tray.userinfo.getLogin_no() );
		sousaLogArg.setSousa( "INIT" );
		OutLogBean.outputLogSousa( KINOU_ID, sousaLogArg );
		
		return SU.bvl( tray.forwardUrl, FORWARD_PAGE );
	}
	
	private String takeGET( Tray tray ) throws CareerException {
		
		boolean useSavedConditions = false;
		
		// From Sidebar Menu
		String myid = AU.getRequestValue( tray.request, "myid" );
		if (myid != null) {
			useSavedConditions = true;
			tray.session.setAttribute( JvSessionKey.MY_SEARCH_ID, myid );
		}
		else {
			myid = tray.getSessionAttr( JvSessionKey.MY_SEARCH_ID );
		}
		
		// From Adding to Folder on SearchResult
		String usc = AU.getRequestAttr( tray.request, "UseSavedConditions" );
		if (SU.judge( usc )) {
			useSavedConditions = true;
		}
		
		MySearchMold msMold = new MySearchMold( tray );
		MysrchCndLgcMold pzSearchBean = msMold.getPzSearchBean( tray.party, tray.loginNo );
		
		Map<String, Map<String, String>> shelfCondMap = null;
		
		if (useSavedConditions) {
			// 保存された条件から復元
			putSrchCondMapFromDB( msMold, pzSearchBean );
			shelfCondMap = msMold.slfMap;
		} else {
			// リクエストのパラメータを検索条件のマップに保持
			putSrchCondMapFromRequest( tray, pzSearchBean );
			shelfCondMap = MySearchMold.makeShelfCondMap( tray );
		}
		tray.session.setAttribute( MySearchMold.SESSION_KEY, msMold );
		
		MySearchEvRslt rslt = MySearchDeliver.search( tray, msMold, pzSearchBean, shelfCondMap );
		
		Gson gson = new Gson();
		return gson.toJson( rslt );
	}
	
	private static void putSrchCondMapFromDB( MySearchMold msMold, MysrchCndLgcMold pzSearchBean ) {
		
		// 在籍情報 (SGL)
		for (String key : MysrchCndLgcMold.registKeyList) {
			String code = SU.extract( key, "...--(.+)" );
			JvTrMysrchCndSglDto s = msMold.sglMap.get( code );
			if (s != null) {
				pzSearchBean.scMap.put( key, s.getSearchValue() );
			}
		}
		// 基本情報 (MLT)
		for (String key : MysrchCndLgcMold.personalKeyList) {
			String code = SU.extract( key, "...--(.+)" );
			JvTrMysrchCndMltDto d = msMold.mltMap.get( code );
			if (d == null) {
				continue;
			}
			pzSearchBean.scMap.put( key, d.getCodeValue() );
		}
		// 所属 (MLT -> _cd)
		for (String key : MysrchCndLgcMold.shozokuKeyList) {
			String code = SU.extract( key, "...--(.+)" );
			JvTrMysrchCndMltDto d = msMold.mltMap.get( code );
			if (d == null) {
				continue;
			}
			pzSearchBean.scMap.put( key + "_cd", d.getCodeValue() );
		}
	}
	
	private static void putSrchCondMapFromRequest( Tray tray, MysrchCndLgcMold pzSearchBean ) {
		
		// 在籍情報
		for (String key : MysrchCndLgcMold.registKeyList) {
			pzSearchBean.scMap.put( key, AU.getRequestValue( tray.request, key ) );
		}
		// 基本情報
		for (String key : MysrchCndLgcMold.personalKeyList) {
			pzSearchBean.scMap.put( key, AU.getRequestValue( tray.request, key ) );
		}
		// 所属
		for (String key : MysrchCndLgcMold.shozokuKeyList) {
			pzSearchBean.scMap.put( key, AU.getRequestValue( tray.request, key ) );
		}
		// 評価
		for (String key : MysrchCndLgcMold.hyokaKeyList) {
			pzSearchBean.scMap.put( key, AU.getRequestValue( tray.request, key ) );
		}
		// 過去を含む評価
		for (String key : MysrchCndLgcMold.pastHyokaKeyList) {
			pzSearchBean.scMap.put( key, AU.getRequestValue( tray.request, key ) );
		}
		// 取得資格・教育・研修
		for (String key : MysrchCndLgcMold.shikakuKeyList) {
			pzSearchBean.scMap.put( key, AU.getRequestValue( tray.request, key ) );
		}
		// 技能専門分野
		for (String key : MysrchCndLgcMold.ginouKeyList) {
			pzSearchBean.scMap.put( key, AU.getRequestValue( tray.request, key ) );
		}
		// 職務履歴
		for (String key : MysrchCndLgcMold.shokumuKeyList) {
			pzSearchBean.scMap.put( key, AU.getRequestValue( tray.request, key ) );
		}
	}
	
}
