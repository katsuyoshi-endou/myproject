package jp.co.hisas.career.app.talent.event;

import jp.co.hisas.career.app.talent.garage.MyFoldGarage;
import jp.co.hisas.career.app.talent.garage.SrchRsltWkGarage;
import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class FetchTalentsEvHdlr extends AbstractEventHandler<FetchTalentsEvArg, FetchTalentsEvRslt> {
	
	public static FetchTalentsEvRslt exec( FetchTalentsEvArg arg ) throws CareerException {
		FetchTalentsEvHdlr handler = new FetchTalentsEvHdlr();
		return handler.call( arg );
	}
	
	public FetchTalentsEvRslt call( FetchTalentsEvArg arg ) throws CareerException {
		return this.callEjb( arg );
	}
	
	protected FetchTalentsEvRslt execute( FetchTalentsEvArg arg ) throws CareerException {
		Log.method( arg.getLoginNo(), "IN", "" );
		arg.validateArg();
		String daoLoginNo = arg.getLoginNo();
		FetchTalentsEvRslt result = new FetchTalentsEvRslt();
		try {
			
			if (SU.equals( "RENEW", arg.sharp )) {
				
				SrchRsltWkGarage ggWk = new SrchRsltWkGarage( daoLoginNo );
				MyFoldGarage ggMf = new MyFoldGarage( daoLoginNo );
				
				ggWk.clearResultWk( arg.getLoginNo() );
				ggMf.insertFromFolder( arg.sessionId, arg.party, arg.guid, arg.myfoldId );
				ggWk.updateWkIdx( arg.sessionId, arg.party, arg.guid );
			}
			
			return result;
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		} finally {
			Log.method( arg.getLoginNo(), "OUT", "" );
		}
	}
	
}
