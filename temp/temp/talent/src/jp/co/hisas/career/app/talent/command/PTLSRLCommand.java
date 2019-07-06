package jp.co.hisas.career.app.talent.command;

import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.app.talent.vm.VmVTLSRL;
import jp.co.hisas.career.framework.CSRFTokenUtil;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.trans.AbstractCommand;
import jp.co.hisas.career.framework.trans.StateTransitionEvent;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class PTLSRLCommand extends AbstractCommand {
	
	public static final String KINOU_ID = "VTLSRL";
	private Tray tray;
	
	public PTLSRLCommand() {
		super( PTLSRLCommand.class, KINOU_ID, null );
	}
	
	public void init( StateTransitionEvent e ) {
		try {
			this.tray = new Tray( e );
			CSRFTokenUtil.setNewTokenNo( tray.request, tray.response );
			main();
		} catch (CareerException ex) {
			throw new CareerRuntimeException( ex );
		}
	}
	
	public void main() throws CareerException {
		
		VmVTLSRL vm = null;
		
		if (SU.equals( tray.state, "ALL" )) {
			vm = new VmVTLSRL( tray, "ALL" );
			vm.putVL( "title-icon", "fa-users" );
			vm.putVL( "listName", vm.gCL( "LTLSRL_NM_ALL" ) );
		}
		else if (SU.equals( tray.state, "STAR" )) {
			vm = new VmVTLSRL( tray, "STAR" );
			vm.putVL( "title-icon", "fa-star" );
			vm.putVL( "listName", vm.gCL( "LTLSRL_NM_STAR" ) );
		}
		else if (SU.equals( tray.state, "SEARCH" )) {
			vm = new VmVTLSRL( tray, "SEARCH" );
			vm.putVL( "title-icon", "fa-search" );
			vm.putVL( "listName", vm.mySearch.getMysrchNm() );
		}
		else if (SU.equals( tray.state, "FOLDER" )) {
			vm = new VmVTLSRL( tray, "FOLDER" );
			vm.putVL( "title-icon", "fa-folder" );
			vm.putVL( "listName", vm.myFolder.getMyfoldNm() );
		}
		else if (SU.equals( tray.state, "INSTANT" )) {
			vm = new VmVTLSRL( tray, "INSTANT" );
			vm.putVL( "title-icon", "fa-search" );
			vm.putVL( "listName", vm.gCL( "LTLSRL_NM_INSTANT" ) );
			vm.loadInstantHitPzItems( tray );
		}
		else if (SU.equals( tray.state, "RESTORE" )) {
			// Restore from session
			vm = tray.getSessionAttr( VmVTLSRL.VMID );
			vm.updateOnRestore( tray );
		}
		
		String reqIsShared = AU.getRequestValue( tray.request, "isshared" );
		tray.session.setAttribute( JvSessionKey.VTLSCE_IS_SHARED, SU.judge( reqIsShared ) ? "true" : "false" );
		
		tray.session.setAttribute( VmVTLSRL.VMID, vm );
		AU.setReqAttr( tray.request, "vm", vm );
		AU.setReqAttr( tray.request, "state", tray.state );
		AU.setReqAttr( tray.request, "FUNC_TITLE", vm.gCL( "LTLSRL_TITLE" ) );
		
		/* 操作ログ */
		OutLogBean.outputLogSousa( tray.request, KINOU_ID, null, tray.state );
	}
	
}
