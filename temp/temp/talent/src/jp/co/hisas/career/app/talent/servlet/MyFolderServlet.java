package jp.co.hisas.career.app.talent.servlet;

import jp.co.hisas.career.app.AppDef;
import jp.co.hisas.career.app.talent.api.myfolder.MyFolderEvArg;
import jp.co.hisas.career.app.talent.api.myfolder.MyFolderEvHdlr;
import jp.co.hisas.career.app.talent.api.myfolder.MyFolderEvRslt;
import jp.co.hisas.career.app.talent.event.FetchTalentsEvArg;
import jp.co.hisas.career.app.talent.event.FetchTalentsEvHdlr;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.NewTokenServlet;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class MyFolderServlet extends NewTokenServlet {
	
	private static final long serialVersionUID = 1L;
	private static final String KINOU_ID = "JvSrchHist";
	private static final String FORWARD_PAGE = "/servlet/ShowResultServlet?state=FOLDER";
	
	public String serviceMain( Tray tray ) throws CareerException {
		
		if (SU.equals( "SAVE", tray.state )) {
			String myfoldId = execMyFolderSave( tray );
			execFetchTalentsRenew( tray, myfoldId );
			tray.session.setAttribute( JvSessionKey.MY_FOLDER_ID, myfoldId );
		}
		if (SU.equals( "DELETE", tray.state )) {
			execEventDelete( tray );
			tray.forwardUrl = AppDef.HOME_URL;
		}
		
		// 操作ログ
		OutLogBean.outputLogSousa( tray.request, KINOU_ID, null, tray.state );
		
		return SU.bvl( tray.forwardUrl, FORWARD_PAGE );
	}
	
	private String execMyFolderSave( Tray tray ) throws CareerException {
		MyFolderEvArg arg = new MyFolderEvArg( tray.loginNo );
		arg.sharp = "SAVE";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.myfoldId = tray.getSessionAttr( JvSessionKey.MY_FOLDER_ID );
		arg.foldNm = AU.getRequestValue( tray.request, "new_folder_name" );
		arg.isShared = SU.judge( tray.getSessionAttr( JvSessionKey.VTLFDE_IS_SHARED ) );
		MyFolderEvRslt rslt = MyFolderEvHdlr.exec( arg );
		return rslt.myfoldId;
	}
	
	private void execFetchTalentsRenew( Tray tray, String myfoldId ) throws CareerException {
		FetchTalentsEvArg arg = new FetchTalentsEvArg( tray.loginNo );
		arg.sharp = "RENEW";
		arg.sessionId = tray.session.getId();
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.myfoldId = myfoldId;
		FetchTalentsEvHdlr.exec( arg );
	}
	
	private void execEventDelete( Tray tray ) throws CareerException {
		MyFolderEvArg arg = new MyFolderEvArg( tray.loginNo );
		arg.sharp = "DELETE";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.myfoldId = tray.getSessionAttr( JvSessionKey.MY_FOLDER_ID );
		MyFolderEvHdlr.exec( arg );
	}
	
}
