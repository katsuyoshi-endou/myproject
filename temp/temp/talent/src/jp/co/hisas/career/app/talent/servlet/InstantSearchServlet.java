package jp.co.hisas.career.app.talent.servlet;

import jp.co.hisas.career.app.talent.deliver.InstantSearchDeliver;
import jp.co.hisas.career.app.talent.event.InstantSearchEvRslt;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.NewTokenServlet;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class InstantSearchServlet extends NewTokenServlet {
	
	private static final long serialVersionUID = 1L;
	private static final String KINOU_ID = "Instant";
	private static final String FORWARD_PAGE = "/servlet/ShowResultServlet?state=INSTANT";
	
	public String serviceMain( Tray tray ) throws CareerException {
		
		if (SU.equals( "SEARCH", tray.state )) {
			InstantSearchEvRslt rslt = InstantSearchDeliver.execSearch( tray );
			AU.setReqAttr( tray.request, "InstantQueryWords", rslt.queryWords );
			AU.setReqAttr( tray.request, "InstantScopeList", rslt.scopeList );
		}
		else if (SU.equals( "MLTSTFNO", tray.state )) {
			InstantSearchDeliver.execMltstfnoSearch( tray );
		}
		
		// 操作ログ
		OutLogBean.outputLogSousa( tray.request, KINOU_ID, null, tray.state );
		
		return SU.bvl( tray.forwardUrl, FORWARD_PAGE );
	}
	
}
