package jp.co.hisas.career.app.talent.vm;

import jp.co.hisas.career.app.talent.event.JvProfileEvArg;
import jp.co.hisas.career.app.talent.event.JvProfileEvHdlr;
import jp.co.hisas.career.app.talent.event.JvProfileEvRslt;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.ViewModel;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.Tray;

public class VmVTLPRF extends ViewModel {
	
	public static String VMID = VmVTLPRF.class.getSimpleName();
	
	public boolean isFromSelf;
	
	public VmVTLPRF(Tray tray) throws CareerException {
		super( tray );
		
		execEventInit( tray );
	}
	
	public void updateOnRestore( Tray tray ) throws CareerException {
		
	}
	
	private void execEventInit( Tray tray ) throws CareerException {
		
		/* Set Args */
		JvProfileEvArg arg = new JvProfileEvArg( tray.loginNo );
		arg.sharp = "LOAD";
		arg.party = AU.getParty( tray.session );
		arg.tgtCmpaCd = AU.getRequestAttr( tray.request, "jvProfileTgtCmpaCd" );
		arg.tgtStfNo  = AU.getRequestAttr( tray.request, "jvProfileTgtStfNo" );
		arg.tgtRoleId = AU.getRequestAttr( tray.request, "jvProfileTgtRoleId" );
		
		/* Execute Event */
		JvProfileEvRslt result = JvProfileEvHdlr.exec( arg );
		
		/* Return to session */
		tray.session.setAttribute( JvSessionKey.JV_PROFILE, result.jvProfileBean );
	}
	
}
