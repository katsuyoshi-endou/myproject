package jp.co.hisas.career.app.talent.command;

import jp.co.hisas.career.app.talent.vm.VmVTLHOM;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.trans.AbstractCommand;
import jp.co.hisas.career.framework.trans.StateTransitionEvent;
import jp.co.hisas.career.util.Tray;

public class PTLMENCommand extends AbstractCommand {
	
	public static final String KINOU_ID = "VTLMEN";
	private Tray tray;
	
	public PTLMENCommand() {
		super( PTLMENCommand.class, KINOU_ID, null );
	}
	
	public void init( StateTransitionEvent e ) {
		try {
			this.tray = new Tray( e );
			main();
		} catch (CareerException ex) {
			throw new CareerRuntimeException( ex );
		}
	}
	
	public void main() throws CareerException {
		
		VmVTLHOM vm = tray.getSessionAttr( VmVTLHOM.VMID );
		if (vm == null) {
			tray.session.setAttribute( VmVTLHOM.VMID, new VmVTLHOM( tray ) );
		} else {
			vm.refresh( tray );
		}
	}
	
}
