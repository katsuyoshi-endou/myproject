package jp.co.hisas.career.app.talent.api.star;

import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class StarEvHdlr extends AbstractEventHandler<StarEvArg, StarEvRslt> {
	
	public static StarEvRslt exec( StarEvArg arg ) throws CareerException {
		StarEvHdlr handler = new StarEvHdlr();
		return handler.call( arg );
	}
	
	public StarEvRslt call( StarEvArg arg ) throws CareerException {
		StarEvRslt result = null;
		Log.method( arg.getLoginNo(), "IN", "" );
		if (Log.isDebugMode()) {
			result = this.execute( arg );
		} else {
			result = this.callEjb( arg );
		}
		Log.method( arg.getLoginNo(), "OUT", "" );
		return result;
	}
	
	protected StarEvRslt execute( StarEvArg arg ) throws CareerException {
		arg.validateArg();
		StarEvRslt result = new StarEvRslt();
		try {
			
			if (SU.equals( "POST", arg.sharp )) {
				
				StarLogicPost logic = new StarLogicPost( arg.getLoginNo() );
				result = logic.main( arg );
			}
			else if (SU.equals( "DELETE", arg.sharp )) {
				
				StarLogicDelete logic = new StarLogicDelete( arg.getLoginNo() );
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
