package jp.co.hisas.career.app.talent.api.pool;

import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class PoolEvHdlr extends AbstractEventHandler<PoolEvArg, PoolEvRslt> {
	
	public static PoolEvRslt exec( PoolEvArg arg ) throws CareerException {
		PoolEvHdlr handler = new PoolEvHdlr();
		return handler.call( arg );
	}
	
	public PoolEvRslt call( PoolEvArg arg ) throws CareerException {
		return this.callEjb( arg );
	}
	
	protected PoolEvRslt execute( PoolEvArg arg ) throws CareerException {
		Log.method( arg.getLoginNo(), "IN", "" );
		arg.validateArg();
		String daoLoginNo = arg.getLoginNo();
		PoolEvRslt result = new PoolEvRslt();
		try {
			
			if (SU.equals( "GET", arg.sharp )) {
				
				PoolLogicGet logic = new PoolLogicGet( daoLoginNo );
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
