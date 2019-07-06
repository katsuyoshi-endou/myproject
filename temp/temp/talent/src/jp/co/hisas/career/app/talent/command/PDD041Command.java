package jp.co.hisas.career.app.talent.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import jp.co.hisas.career.app.talent.event.SearchTalentsEvArg;
import jp.co.hisas.career.app.talent.event.SearchTalentsEvHdlr;
import jp.co.hisas.career.app.talent.event.SearchTalentsEvRslt;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.CSRFTokenUtil;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.framework.trans.AbstractCommand;
import jp.co.hisas.career.framework.trans.StateTransitionEvent;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class PDD041Command extends AbstractCommand {
	
	public static final String KINOU_ID = "VDD041";
	private HttpServletRequest request;
	private HttpSession session;
	private String state;
	
	public PDD041Command() {
		super( PDD041Command.class, KINOU_ID, null );
	}
	
	public void init( StateTransitionEvent e ) {
		try {
			request = e.getRequest();
			session = request.getSession( false );
			CSRFTokenUtil.setNewTokenNo( request, e.getResponse() );
			state = request.getParameter( "state" );
			main();
		} catch (CareerException ex) {
			throw new CareerRuntimeException( ex );
		}
	}
	
	public void main() throws CareerException {
		
		String party = AU.getParty( session );
		
		if (!SU.equals( state, "RESTORE" )) {
			execEventPickupAll( party );
		}
		
		/* 操作ログ */
		OutLogBean.outputLogSousa( request, KINOU_ID, null, state );
	}
	
	private void execEventPickupAll( String party ) throws CareerException {
		
		/* Set Args */
		SearchTalentsEvArg arg = new SearchTalentsEvArg( super.getLoginNo() );
		arg.sharp = "CSV_PREPARE";
		arg.party = party;
		arg.sessionId = session.getId();
		
		/* Execute Event */
		SearchTalentsEvRslt result = SearchTalentsEvHdlr.exec( arg );
		
		/* Return to session */
		session.setAttribute( JvSessionKey.SRCH_VISIBLE_TAB_SECTS, result.tabSects );
		session.setAttribute( JvSessionKey.SRCH_SECT_TBL_MAP, result.sectTblMap );
	}
}