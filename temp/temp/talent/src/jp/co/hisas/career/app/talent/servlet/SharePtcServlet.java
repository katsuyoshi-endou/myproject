package jp.co.hisas.career.app.talent.servlet;

import jp.co.hisas.career.app.talent.vm.VmVTLPTC;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.NewTokenServlet;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class SharePtcServlet extends NewTokenServlet {
	
	private static final long serialVersionUID = 1L;
	private static final String KINOU_ID = "SharePtc";
	private static final String FORWARD_PAGE = "/view/talent/search/VTLPTC_SharePtc.jsp";
	
	public String serviceMain( Tray tray ) throws CareerException {
		
		if (SU.equals( "INIT", tray.state )) {
			VmVTLPTC vm = new VmVTLPTC( tray );
			AU.setReqAttr( tray.request, VmVTLPTC.VMID, vm );
		}
		
		// 操作ログ
		OutLogBean.outputLogSousa( tray.request, KINOU_ID, null, tray.state );
		
		return SU.bvl( tray.forwardUrl, FORWARD_PAGE );
	}
	
}
