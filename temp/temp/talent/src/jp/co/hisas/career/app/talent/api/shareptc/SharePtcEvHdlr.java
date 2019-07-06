package jp.co.hisas.career.app.talent.api.shareptc;

import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class SharePtcEvHdlr extends AbstractEventHandler<SharePtcEvArg, SharePtcEvRslt> {
	
	public static SharePtcEvRslt exec( SharePtcEvArg arg ) throws CareerException {
		SharePtcEvHdlr handler = new SharePtcEvHdlr();
		return handler.call( arg );
	}
	
	public SharePtcEvRslt call( SharePtcEvArg arg ) throws CareerException {
		return this.callEjb( arg );
	}
	
	protected SharePtcEvRslt execute( SharePtcEvArg arg ) throws CareerException {
		Log.method( arg.getLoginNo(), "IN", "" );
		arg.validateArg();
		String daoLoginNo = arg.getLoginNo();
		SharePtcEvRslt result = new SharePtcEvRslt();
		try {
			
			if (SU.equals( "GET", arg.sharp )) {
				
				SharePtcLogicGet logic = new SharePtcLogicGet( daoLoginNo );
				result = logic.main( arg );
			}
			else if (SU.equals( "POST", arg.sharp )) {
				
				SharePtcLogicPost logic = new SharePtcLogicPost( daoLoginNo );
				result = logic.main( arg );
			}
			else if (SU.equals( "PUT", arg.sharp )) {
				
				SharePtcLogicPut logic = new SharePtcLogicPut( daoLoginNo );
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
