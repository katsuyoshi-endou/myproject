package jp.co.hisas.career.app.talent.command;

import jp.co.hisas.career.app.talent.vm.VmVTLPRF;
import jp.co.hisas.career.framework.CSRFTokenUtil;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.trans.AbstractCommand;
import jp.co.hisas.career.framework.trans.StateTransitionEvent;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class PTLPRFCommand extends AbstractCommand {
	
	public static final String KINOU_ID = "VTLPRF";
	private Tray tray;
	
	public PTLPRFCommand() {
		super( PTLPRFCommand.class, KINOU_ID, null );
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
	
	private void main() throws CareerException {
		
		VmVTLPRF vm = null;
		
		if (SU.equals( tray.state, "SELF" )) {
			vm = new VmVTLPRF( tray );
			vm.isFromSelf = true;
		}
		else if (SU.equals( tray.state, "RESTORE" )) {
			vm = tray.getSessionAttr( VmVTLPRF.VMID );
			vm.updateOnRestore( tray );
		}
		else {
			vm = new VmVTLPRF( tray );
		}
		tray.session.setAttribute( VmVTLPRF.VMID, vm );
		AU.setReqAttr( tray.request, "vm", vm );
		
		/* 操作ログ */
		OutLogBean.outputLogSousa( tray.request, KINOU_ID, null, tray.state );
	}
	
}
