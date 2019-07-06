package jp.co.hisas.career.app.talent.command;

import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.app.talent.vm.VmVTLSCE;
import jp.co.hisas.career.framework.CSRFTokenUtil;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.trans.AbstractCommand;
import jp.co.hisas.career.framework.trans.StateTransitionEvent;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class PTLSCECommand extends AbstractCommand {
	
	public static final String KINOU_ID = "VTLSCE";
	private Tray tray;
	
	public PTLSCECommand() {
		super( PTLSCECommand.class, KINOU_ID, null );
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
		
		// 検索条件入力画面の表示で列切り替えをリセット
		tray.session.removeAttribute( JvSessionKey.SRCH_COLS_PTN );
		
		VmVTLSCE vm = new VmVTLSCE( tray );
		
		AU.setReqAttr( tray.request, "vm", vm );
		
		/* 操作ログ */
		OutLogBean.outputLogSousa( tray.request, KINOU_ID, tray.state );
	}
	
}
