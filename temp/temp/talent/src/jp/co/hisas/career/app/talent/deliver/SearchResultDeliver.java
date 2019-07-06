package jp.co.hisas.career.app.talent.deliver;

import jp.co.hisas.career.app.talent.event.JvProfileEvArg;
import jp.co.hisas.career.app.talent.event.JvProfileEvHdlr;
import jp.co.hisas.career.app.talent.event.JvProfileEvRslt;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.Tray;

public class SearchResultDeliver {
	
	public static JvProfileEvRslt getRsltWkByWkIdx( Tray tray, int wkIdx ) throws CareerException {
		JvProfileEvArg arg = new JvProfileEvArg( tray.loginNo );
		arg.sharp = "GET_RSLT_WK_BY_WKIDX";
		arg.sessionId = tray.session.getId();
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.wkIdx = wkIdx + "";
		JvProfileEvRslt rslt = JvProfileEvHdlr.exec( arg );
		return rslt;
	}
	
}
