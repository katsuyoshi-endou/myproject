package jp.co.hisas.career.app.talent.command;

import jp.co.hisas.career.app.AppState;
import jp.co.hisas.career.framework.CSRFTokenUtil;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.trans.AbstractCommand;
import jp.co.hisas.career.framework.trans.StateTransitionEvent;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class PTLHOMCommand extends AbstractCommand {
	
	public static final String KINOU_ID = "VTLHOM";
	private Tray tray;
	
	public PTLHOMCommand() {
		super( PTLHOMCommand.class, KINOU_ID, null );
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
		
		AppState as = new AppState( tray );
		as.initialize();
		
		/* 操作ログ */
		String state = SU.nvl( tray.state, "INIT" );
		OutLogBean.outputLogSousa( tray.request, KINOU_ID, null, state );
	}
	
}
