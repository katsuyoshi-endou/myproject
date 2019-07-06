package jp.co.hisas.career.app.talent.api.shareptc.find;

import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class SharePtcFindEvHdlr extends AbstractEventHandler<SharePtcFindEvArg, SharePtcFindEvRslt> {
	
	public static SharePtcFindEvRslt exec( SharePtcFindEvArg arg ) throws CareerException {
		SharePtcFindEvHdlr handler = new SharePtcFindEvHdlr();
		return handler.call( arg );
	}
	
	public SharePtcFindEvRslt call( SharePtcFindEvArg arg ) throws CareerException {
		return this.callEjb( arg );
	}
	
	protected SharePtcFindEvRslt execute( SharePtcFindEvArg arg ) throws CareerException {
		Log.method( arg.getLoginNo(), "IN", "" );
		arg.validateArg();
		String daoLoginNo = arg.getLoginNo();
		SharePtcFindEvRslt result = new SharePtcFindEvRslt();
		try {
			
			if (SU.equals( "GET", arg.sharp )) {
				
				SharePtcFindLogicGet logic = new SharePtcFindLogicGet( daoLoginNo );
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
