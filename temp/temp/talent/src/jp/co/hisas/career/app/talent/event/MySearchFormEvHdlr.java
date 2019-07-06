package jp.co.hisas.career.app.talent.event;

import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class MySearchFormEvHdlr extends AbstractEventHandler<MySearchFormEvArg, MySearchFormEvRslt> {
	
	public static MySearchFormEvRslt exec( MySearchFormEvArg arg ) throws CareerException {
		MySearchFormEvHdlr handler = new MySearchFormEvHdlr();
		return handler.call( arg );
	}
	
	public MySearchFormEvRslt call( MySearchFormEvArg arg ) throws CareerException {
		return this.callEjb( arg );
	}
	
	protected MySearchFormEvRslt execute( MySearchFormEvArg arg ) throws CareerException {
		Log.method( arg.getLoginNo(), "IN", "" );
		arg.validateArg();
		String daoLoginNo = arg.getLoginNo();
		MySearchFormEvRslt result = new MySearchFormEvRslt();
		try {
			
			if (SU.equals( "SRCH_FORM_SHELF", arg.sharp )) {
				
				MySearchFormLogicShelf logic = new MySearchFormLogicShelf( daoLoginNo );
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
