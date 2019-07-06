package jp.co.hisas.career.app.talent.api.search.starred;

import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class SearchStarredEvHdlr extends AbstractEventHandler<SearchStarredEvArg, SearchStarredEvRslt> {
	
	public static SearchStarredEvRslt exec( SearchStarredEvArg arg ) throws CareerException {
		SearchStarredEvHdlr handler = new SearchStarredEvHdlr();
		return handler.call( arg );
	}
	
	public SearchStarredEvRslt call( SearchStarredEvArg arg ) throws CareerException {
		SearchStarredEvRslt result = null;
		Log.method( arg.getLoginNo(), "IN", "" );
		if (Log.isDebugMode()) {
			result = this.execute( arg );
		} else {
			result = this.callEjb( arg );
		}
		Log.method( arg.getLoginNo(), "OUT", "" );
		return result;
	}
	
	protected SearchStarredEvRslt execute( SearchStarredEvArg arg ) throws CareerException {
		arg.validateArg();
		SearchStarredEvRslt result = new SearchStarredEvRslt();
		try {
			
			if (SU.equals( "GET", arg.sharp )) {
				
				SearchStarredLogicGet logic = new SearchStarredLogicGet( arg.getLoginNo() );
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
