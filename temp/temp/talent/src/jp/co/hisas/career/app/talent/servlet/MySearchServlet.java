package jp.co.hisas.career.app.talent.servlet;

import jp.co.hisas.career.app.AppDef;
import jp.co.hisas.career.app.talent.deliver.MySearchDeliver;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.NewTokenServlet;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class MySearchServlet extends NewTokenServlet {
	
	private static final long serialVersionUID = 1L;
	private static final String KINOU_ID = "JvSrchHist";
	private static final String FORWARD_PAGE = "/servlet/SearchTalentsServlet?state=SEARCH";
	
	public String serviceMain( Tray tray ) throws CareerException {
		
		String mysrchId = "";
		if (SU.equals( "SAVE", tray.state )) {
			// state:SAVE - 検索条件の保存
			mysrchId = MySearchDeliver.save( tray );
			tray.session.setAttribute( JvSessionKey.MY_SEARCH_ID, mysrchId );
		}
		if (SU.equals( "DELETE", tray.state )) {
			// state:DELETE - 検索条件の削除
			MySearchDeliver.delete( tray );
			tray.forwardUrl = AppDef.HOME_URL;
		}
		
		// 操作ログ
		OutLogBean.outputLogSousa( tray.request, KINOU_ID, null, tray.state + ", マイサーチID：" + mysrchId );
		
		return SU.bvl( tray.forwardUrl, FORWARD_PAGE );
	}
	
}
