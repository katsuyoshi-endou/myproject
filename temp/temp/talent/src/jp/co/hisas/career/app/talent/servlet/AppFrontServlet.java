package jp.co.hisas.career.app.talent.servlet;

import jp.co.hisas.career.app.AppDef;
import jp.co.hisas.career.app.AppState;
import jp.co.hisas.career.framework.CSRFTokenUtil;
import jp.co.hisas.career.framework.trans.NoTokenRedirectServlet;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;

public class AppFrontServlet extends NoTokenRedirectServlet {
	
	private static final long serialVersionUID = 1L;
	
	@Override
	public String serviceMain( Tray tray ) throws Exception {
		
		if (isMobileMode( tray )) {
			AppState as = new AppState( tray );
			as.initialize();
			CSRFTokenUtil.setNewTokenNo( tray.request, tray.response );
			return "/sp/";
		}
		
		return AppDef.HOME_JSP;
	}
	
	private boolean isMobileMode( Tray tray ) {
		if (AU.matchesCareerProperty( "USE_MOBILE", "YES" )) {
			String ua = tray.request.getHeader( "user-agent" );
			if (SU.contains( ua, "iPhone" )) {
				return true;
			}
		}
		return false;
	}
	
}
