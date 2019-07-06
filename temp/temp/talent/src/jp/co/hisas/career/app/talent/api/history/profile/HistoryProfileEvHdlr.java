package jp.co.hisas.career.app.talent.api.history.profile;

import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class HistoryProfileEvHdlr extends AbstractEventHandler<HistoryProfileEvArg, HistoryProfileEvRslt> {
	
	public static HistoryProfileEvRslt exec( HistoryProfileEvArg arg ) throws CareerException {
		HistoryProfileEvHdlr handler = new HistoryProfileEvHdlr();
		return handler.call( arg );
	}
	
	public HistoryProfileEvRslt call( HistoryProfileEvArg arg ) throws CareerException {
		HistoryProfileEvRslt result = null;
		Log.method( arg.getLoginNo(), "IN", "" );
		if (Log.isDebugMode()) {
			result = this.execute( arg );
		} else {
			result = this.callEjb( arg );
		}
		Log.method( arg.getLoginNo(), "OUT", "" );
		return result;
	}
	
	protected HistoryProfileEvRslt execute( HistoryProfileEvArg arg ) throws CareerException {
		arg.validateArg();
		HistoryProfileEvRslt result = new HistoryProfileEvRslt();
		try {
			
			if (SU.equals( "GET", arg.sharp )) {
				
				HistoryProfileLogicGet logic = new HistoryProfileLogicGet();
				result = logic.main( arg );
			}
			if (SU.equals( "POST", arg.sharp )) {
				
				HistoryProfileLogicPost logic = new HistoryProfileLogicPost();
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
