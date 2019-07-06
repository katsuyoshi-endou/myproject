package jp.co.hisas.career.app.talent.servlet;

import jp.co.hisas.career.app.talent.deliver.MyFolderDeliver;
import jp.co.hisas.career.app.talent.vm.VmVTLSRL;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.NewTokenServlet;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class FolderTalentsServlet extends NewTokenServlet {
	
	private static final long serialVersionUID = 1L;
	private static final String KINOU_ID = "FolTal";
	private static final String FORWARD_PAGE = "";
	
	public String serviceMain( Tray tray ) throws CareerException {
		
		VmVTLSRL vm = tray.getSessionAttr( VmVTLSRL.VMID );
		
		if (SU.equals( "ADD", tray.state )) {
			
			String[] targets = AU.getRequestValues( tray.request, "tgt_idx" );
			if (targets != null) {
				MyFolderDeliver.addTalents( tray, targets );
			}
		}
		else if (SU.equals( "REMOVE", tray.state )) {
			
			String[] targets = AU.getRequestValues( tray.request, "tgt_idx" );
			if (targets != null) {
				MyFolderDeliver.removeTalents( tray, targets );
			}
		}
		
		if (SU.equals( vm.crrMode, "SEARCH" )) {
			tray.request.setAttribute( "UseSavedConditions", "yes" );
			tray.forwardUrl = "/servlet/SearchTalentsServlet";
		}
		else if (SU.equals( vm.crrMode, "FOLDER" )) {
			tray.forwardUrl = "/servlet/ShowResultServlet?state=FOLDER";
		}
		else {
			tray.forwardUrl = "/servlet/ShowResultServlet?state=RESTORE";
		}
		
		OutLogBean.outputLogSousa( tray.request, KINOU_ID, null, tray.state );
		
		return SU.bvl( tray.forwardUrl, FORWARD_PAGE );
	}
	
}
