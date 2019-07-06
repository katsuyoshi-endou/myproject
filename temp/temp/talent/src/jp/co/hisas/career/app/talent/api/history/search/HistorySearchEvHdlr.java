package jp.co.hisas.career.app.talent.api.history.search;

import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class HistorySearchEvHdlr extends AbstractEventHandler<HistorySearchEvArg, HistorySearchEvRslt> {
	
	public static HistorySearchEvRslt exec( HistorySearchEvArg arg ) throws CareerException {
		HistorySearchEvHdlr handler = new HistorySearchEvHdlr();
		return handler.call( arg );
	}
	
	public HistorySearchEvRslt call( HistorySearchEvArg arg ) throws CareerException {
		HistorySearchEvRslt result = null;
		Log.method( arg.getLoginNo(), "IN", "" );
		if (Log.isDebugMode()) {
			result = this.execute( arg );
		} else {
			result = this.callEjb( arg );
		}
		Log.method( arg.getLoginNo(), "OUT", "" );
		return result;
	}
	
	protected HistorySearchEvRslt execute( HistorySearchEvArg arg ) throws CareerException {
		arg.validateArg();
		HistorySearchEvRslt result = new HistorySearchEvRslt();
		try {
			
			if (SU.equals( "GET", arg.sharp )) {
				
				HistorySearchLogicGet logic = new HistorySearchLogicGet( arg.getLoginNo() );
				result = logic.main( arg );
			}
			
			return result;
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		} finally {
			Log.method( arg.getLoginNo(), "OUT", "" );
		}
	}
	
}
