package jp.co.hisas.career.app.talent.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import jp.co.hisas.career.app.talent.event.SearchCondSelectEvArg;
import jp.co.hisas.career.app.talent.event.SearchCondSelectEvHdlr;
import jp.co.hisas.career.app.talent.event.SearchCondSelectEvRslt;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.trans.AbstractCommand;
import jp.co.hisas.career.framework.trans.StateTransitionEvent;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class PDA110Command extends AbstractCommand {
	
	public static final String KINOU_ID = "VDA110";
	private HttpServletRequest request;
	private HttpSession session;
	private String state;
	
	public PDA110Command() {
		super( PDA110Command.class, KINOU_ID, null );
	}
	
	public void init( StateTransitionEvent e ) {
		try {
			request = e.getRequest();
			session = request.getSession( false );
			state = AU.getRequestValue( request, "state" );
			main();
		} catch (CareerException ex) {
			throw new CareerRuntimeException( ex );
		}
	}
	
	private void main() throws CareerException {
		
		if (SU.matches( state, "INIT" )) {
			execEventInit();
		}
		
		/* 操作ログ */
		OutLogBean.outputLogSousa( request, KINOU_ID, state + ", マスタ：" + AU.getRequestValue( request, "masterId" ) );
	}
	
	private void execEventInit() throws CareerException {
		
		/* Set Args */
		SearchCondSelectEvArg arg = new SearchCondSelectEvArg( super.getLoginNo() );
		
		arg.masterId = AU.getRequestValue( request, "masterId" );
		arg.masterName = AU.getRequestValue( request, "masterName" );
		arg.searchCondSelectBean = AU.getSessionAttr( session, JvSessionKey.VDA110 );
		
		/* Execute Event */
		SearchCondSelectEvRslt result = SearchCondSelectEvHdlr.exec( arg );
		
		/* Return to session */
		session.setAttribute( JvSessionKey.VDA110, result.searchCondSelectBean );
	}
	
}