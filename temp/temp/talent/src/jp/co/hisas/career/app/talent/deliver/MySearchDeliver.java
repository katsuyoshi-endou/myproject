package jp.co.hisas.career.app.talent.deliver;

import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.api.myfolder.MyFolderEvArg;
import jp.co.hisas.career.app.talent.api.myfolder.MyFolderEvHdlr;
import jp.co.hisas.career.app.talent.api.myfolder.MyFolderEvRslt;
import jp.co.hisas.career.app.talent.api.mysearch.MySearchEvArg;
import jp.co.hisas.career.app.talent.api.mysearch.MySearchEvHdlr;
import jp.co.hisas.career.app.talent.api.mysearch.MySearchEvRslt;
import jp.co.hisas.career.app.talent.bean.LegacyKensakuDefBean;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectListtypeDto;
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchDto;
import jp.co.hisas.career.app.talent.event.MySearchFormEvArg;
import jp.co.hisas.career.app.talent.event.MySearchFormEvHdlr;
import jp.co.hisas.career.app.talent.event.MySearchFormEvRslt;
import jp.co.hisas.career.app.talent.event.ResultListEvArg;
import jp.co.hisas.career.app.talent.event.ResultListEvHdlr;
import jp.co.hisas.career.app.talent.event.ResultListEvRslt;
import jp.co.hisas.career.app.talent.event.SearchTalentsEvArg;
import jp.co.hisas.career.app.talent.event.SearchTalentsEvHdlr;
import jp.co.hisas.career.app.talent.mold.MySearchMold;
import jp.co.hisas.career.app.talent.mold.MysrchCndLgcMold;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;

public class MySearchDeliver {
	
	public static void loadAllTalents( Tray tray ) throws CareerException {
		SearchTalentsEvArg arg = new SearchTalentsEvArg( tray.loginNo );
		arg.sharp = "ALL";
		arg.sessionId = tray.session.getId();
		arg.party = AU.getParty( tray.session );
		arg.guid = tray.loginNo;
		SearchTalentsEvHdlr.exec( arg );
	}
	
	public static void loadStarredTalents( Tray tray ) throws CareerException {
		SearchTalentsEvArg arg = new SearchTalentsEvArg( tray.loginNo );
		arg.sharp = "STAR";
		arg.sessionId = tray.session.getId();
		arg.party = AU.getParty( tray.session );
		arg.guid = tray.loginNo;
		SearchTalentsEvHdlr.exec( arg );
	}
	
	public static MySearchEvRslt search( Tray tray, MySearchMold msMold, MysrchCndLgcMold pzSearchBean, Map<String, Map<String, String>> shelfCondMap ) throws CareerException {
		MySearchEvArg arg = new MySearchEvArg( tray.loginNo );
		arg.sharp = "SEARCH";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.sessionId = tray.session.getId();
		arg.mySearchMold = msMold;
		arg.pzSearchBean = pzSearchBean;
		arg.shelfCondMap = shelfCondMap;
		arg.exceptRetire = pzSearchBean.inUse( "Sgl--currentstatus_except_retire" );
		arg.exceptRemove = pzSearchBean.inUse( "Sgl--currentstatus_except_remove" );
		arg.isShared = SU.judge( msMold.mySearch.getSharedFlg() );
		return MySearchEvHdlr.exec( arg );
	}
	
	public static String save( Tray tray ) throws CareerException {
		MySearchEvArg arg = new MySearchEvArg( tray.loginNo );
		arg.sharp = "SAVE";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.mysrchId = AU.getRequestValue( tray.request, "mysrch_id" );
		arg.mysrchNm = AU.getRequestValue( tray.request, "mysrch_nm" );
		arg.isShared = SU.judge( tray.getSessionAttr( JvSessionKey.VTLSCE_IS_SHARED ) );
		arg.saveHistDtlSglMap = MysrchCndLgcMold.makeHistDtlSglMap( tray.request );
		arg.saveHistDtlMltMap = MysrchCndLgcMold.makeHistDtlMltMap( tray.request );
		arg.saveHistDtlLgcList = MysrchCndLgcMold.makeHistDtlLegacy( tray.request, tray.loginNo, arg.mysrchId );
		arg.saveHistShelftypeMap = MySearchMold.makeShelfCondMap( tray );
		MySearchEvRslt result = MySearchEvHdlr.exec( arg );
		return result.savedMysrchId;
	}
	
	public static void delete( Tray tray ) throws CareerException {
		MySearchEvArg arg = new MySearchEvArg( tray.loginNo );
		arg.sharp = "DELETE";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.mysrchId = tray.getSessionAttr( JvSessionKey.MY_SEARCH_ID );
		MySearchEvHdlr.exec( arg );
	}
	
	public static MySearchEvRslt getMySearchCond( Tray tray, String mysrchId ) throws CareerException {
		MySearchEvArg arg = new MySearchEvArg( tray.loginNo );
		arg.sharp = "GET_CND";
		arg.mysrchId = mysrchId;
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		MySearchEvRslt rslt = MySearchEvHdlr.exec( arg );
		return rslt;
	}
	
	public static JvTrMysrchDto getCurrentMySearch( Tray tray ) throws CareerException {
		MySearchEvArg arg = new MySearchEvArg( tray.loginNo );
		arg.sharp = "GET_BY_ID";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.mysrchId = tray.getSessionAttr( JvSessionKey.MY_SEARCH_ID );
		MySearchEvRslt result = MySearchEvHdlr.exec( arg );
		return result.mySearch;
	}
	
	public static boolean canCndEdit( Tray tray ) throws CareerException {
		MySearchEvArg arg = new MySearchEvArg( tray.loginNo );
		arg.sharp = "CAN_CND_EDIT";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.mysrchId = tray.getSessionAttr( JvSessionKey.MY_SEARCH_ID );
		MySearchEvRslt result = MySearchEvHdlr.exec( arg );
		return result.canCndEdit;
	}
	
	public static LegacyKensakuDefBean getLegacySrchCndDef( Tray tray, boolean isShared ) throws CareerException {
		MySearchEvArg arg = new MySearchEvArg( tray.loginNo );
		arg.sharp = "GET_DEF";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.isShared = isShared;
		MySearchEvRslt result = MySearchEvHdlr.exec( arg );
		return result.cndLgcDef;
	}
	
	public static JvTrMyfoldDto getMyFolder( Tray tray ) throws CareerException {
		String myfoldId = tray.getSessionAttr( JvSessionKey.MY_FOLDER_ID );
		MyFolderEvArg arg = new MyFolderEvArg( tray.loginNo );
		arg.sharp = "GET";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.myfoldId = myfoldId;
		MyFolderEvRslt result = MyFolderEvHdlr.exec( arg );
		return result.myFolder;
	}
	
	public static Map<String, List<JvProfTabSectListtypeDto>> getShelftypeList( Tray tray, boolean isShared ) throws CareerException {
		// 検索条件入力フォーム（Shelftype Only）
		Map<String, List<JvProfTabSectListtypeDto>> shelftypeList;
		MySearchFormEvArg arg = new MySearchFormEvArg( tray.loginNo );
		arg.sharp = "SRCH_FORM_SHELF";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.isShared = isShared;
		MySearchFormEvRslt rslt = MySearchFormEvHdlr.exec( arg );
		shelftypeList = rslt.shelftypeList;
		return shelftypeList;
	}
	
	public static ResultListEvRslt fetchResultList( Tray tray ) throws CareerException {
		ResultListEvArg arg = new ResultListEvArg( tray.loginNo );
		arg.sharp = "SHOW";
		arg.party = tray.party;
		arg.sessionId = tray.session.getId();
		arg.colsPtn = SU.nvl( tray.getSessionAttr( JvSessionKey.SRCH_COLS_PTN ), "X" );
		ResultListEvRslt result = ResultListEvHdlr.exec( arg );
		return result;
	}
	
}
