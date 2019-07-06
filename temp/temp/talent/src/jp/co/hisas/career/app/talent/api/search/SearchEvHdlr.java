package jp.co.hisas.career.app.talent.api.search;

import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class SearchEvHdlr extends AbstractEventHandler<SearchEvArg, SearchEvRslt> {
	
	public static SearchEvRslt exec( SearchEvArg arg ) throws CareerException {
		SearchEvHdlr handler = new SearchEvHdlr();
		return handler.call( arg );
	}
	
	public SearchEvRslt call( SearchEvArg arg ) throws CareerException {
		SearchEvRslt result = null;
		Log.method( arg.getLoginNo(), "IN", "" );
		if (Log.isDebugMode()) {
			result = this.execute( arg );
		} else {
			result = this.callEjb( arg );
		}
		Log.method( arg.getLoginNo(), "OUT", "" );
		return result;
	}
	
	protected SearchEvRslt execute( SearchEvArg arg ) throws CareerException {
		arg.validateArg();
		SearchEvRslt result = new SearchEvRslt();
		try {
			
			if (SU.equals( "GET", arg.sharp )) {
				
				SearchLogicGet logic = new SearchLogicGet( arg.getLoginNo() );
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
