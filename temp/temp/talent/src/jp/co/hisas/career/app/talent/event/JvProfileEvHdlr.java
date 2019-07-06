package jp.co.hisas.career.app.talent.event;

import jp.co.hisas.career.app.talent.garage.ProfileGarage;
import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class JvProfileEvHdlr extends AbstractEventHandler<JvProfileEvArg, JvProfileEvRslt> {
	
	public static JvProfileEvRslt exec( JvProfileEvArg arg ) throws CareerException {
		JvProfileEvHdlr handler = new JvProfileEvHdlr();
		return handler.call( arg );
	}
	
	public JvProfileEvRslt call( JvProfileEvArg arg ) throws CareerException {
		return this.callEjb( arg );
	}
	
	protected JvProfileEvRslt execute( JvProfileEvArg arg ) throws CareerException {
		Log.method( arg.getLoginNo(), "IN", "" );
		arg.validateArg();
		String daoLoginNo = arg.getLoginNo();
		JvProfileEvRslt result = new JvProfileEvRslt();
		try {
			
			if (SU.matches( arg.sharp, "LOAD" )) {
				
				JvProfileLogicLoad logic = new JvProfileLogicLoad( arg.getLoginNo() );
				result = logic.main( arg );
			}
			else if (SU.equals( arg.sharp, "GET_RSLT_WK_BY_WKIDX" )) {
				
				ProfileGarage ggPf = new ProfileGarage( daoLoginNo );
				result.wkProfile = ggPf.getSrchRsltWkByWkIdx( arg.sessionId, arg.wkIdx );
				result.wkIdxMax  = ggPf.getSrchRsltWkIdxMax( arg.sessionId );
			}
			
			return result;
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		} finally {
			Log.method( arg.getLoginNo(), "OUT", "" );
		}
	}
	
}
