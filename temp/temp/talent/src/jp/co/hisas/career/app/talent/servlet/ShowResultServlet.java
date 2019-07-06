package jp.co.hisas.career.app.talent.servlet;

import jp.co.hisas.career.app.talent.api.mold.TalentsPageState;
import jp.co.hisas.career.app.talent.deliver.MyFolderDeliver;
import jp.co.hisas.career.app.talent.deliver.MySearchDeliver;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.app.talent.vm.VmVTLHOM;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.NewTokenServlet;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class ShowResultServlet extends NewTokenServlet {

	private static final long serialVersionUID = 1L;
	private static final String KINOU_ID = "ShowResult";
	private static final String FORWARD_PAGE = "/app/list/index.jsp";

	public String serviceMain( Tray tray ) throws CareerException {

		// Renew page state
		tray.session.setAttribute( JvSessionKey.TALENTS_PAGE_STATE, new TalentsPageState() );

		if (SU.equals( "ALL", tray.state )) {
			tray.session.removeAttribute( JvSessionKey.MY_SEARCH_ID );
			tray.session.removeAttribute( JvSessionKey.MY_FOLDER_ID );
			MySearchDeliver.loadAllTalents( tray );
			VmVTLHOM.updateVmState( tray, "ALL", "" );
		}
		else if (SU.equals( "STAR", tray.state )) {
			tray.session.removeAttribute( JvSessionKey.MY_SEARCH_ID );
			tray.session.removeAttribute( JvSessionKey.MY_FOLDER_ID );
			MySearchDeliver.loadStarredTalents( tray );
			VmVTLHOM.updateVmState( tray, "STAR", "" );
		}
		else if (SU.equals( "SEARCH", tray.state )) {
			tray.session.removeAttribute( JvSessionKey.MY_FOLDER_ID );
			String mysrchId = tray.getSessionAttr( JvSessionKey.MY_SEARCH_ID );
			VmVTLHOM.updateVmState( tray, "SEARCH", mysrchId );
		}
		else if (SU.equals( "FOLDER", tray.state )) {
			tray.session.removeAttribute( JvSessionKey.MY_SEARCH_ID );
			String myfoldId = AU.getRequestValue( tray.request, "myid" );
			myfoldId = SU.nvl( myfoldId, tray.getSessionAttr( JvSessionKey.MY_FOLDER_ID ) );
			MyFolderDeliver.loadFromMyFolder( tray, myfoldId );
			tray.session.setAttribute( JvSessionKey.MY_FOLDER_ID, myfoldId );
			VmVTLHOM.updateVmState( tray, "FOLDER", myfoldId );
		}
		else if (SU.equals( "INSTANT", tray.state )) {
			VmVTLHOM.updateVmState( tray, "INSTANT", "" );
		}

		OutLogBean.outputLogSousa( tray.request, KINOU_ID, null, tray.state );

		return SU.bvl( tray.forwardUrl, FORWARD_PAGE );
	}

}
