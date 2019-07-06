package jp.co.hisas.career.app.talent.command;

import jp.co.hisas.career.app.talent.event.DeptTreeEvArg;
import jp.co.hisas.career.app.talent.event.DeptTreeEvHdlr;
import jp.co.hisas.career.app.talent.event.DeptTreeEvRslt;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.trans.AbstractCommand;
import jp.co.hisas.career.framework.trans.StateTransitionEvent;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class PDA100Command extends AbstractCommand {
	
	public static final String KINOU_ID = "VDA100";
	private Tray tray;
	
	public PDA100Command() {
		super( PDA100Command.class, KINOU_ID, null );
	}
	
	public void init( StateTransitionEvent e ) {
		try {
			this.tray = new Tray( e );
			/* Not Update Token on Child Window.
			CSRFTokenUtil.setNewTokenNo( tray.request, tray.response ); */
			main();
		} catch (CareerException ex) {
			throw new CareerRuntimeException( ex );
		}
	}
	
	private void main() throws CareerException {
		
		if (SU.matches( tray.state, "INIT" )) {
			execEventInit();
		} else {
			execEventInit();
		}
		
		/* 操作ログ */
		OutLogBean.outputLogSousa( tray.request, KINOU_ID, tray.state );
	}
	
	private void execEventInit() throws CareerException {
		
		/* Set Args */
		DeptTreeEvArg arg = new DeptTreeEvArg( super.getLoginNo() );
		
		arg.state = tray.state;
		arg.party = tray.party;
		arg.companyCode = AU.getRequestValue( tray.request, "companyCode" );
		arg.searchGroupBean = AU.getSessionAttr( tray.session, JvSessionKey.VDA100 );
		
		/* Execute Event */
		DeptTreeEvRslt result = DeptTreeEvHdlr.exec( arg );
		
		/* Return to session */
		tray.session.setAttribute( JvSessionKey.VDA100, result.deptTreeBean );
	}
	
}