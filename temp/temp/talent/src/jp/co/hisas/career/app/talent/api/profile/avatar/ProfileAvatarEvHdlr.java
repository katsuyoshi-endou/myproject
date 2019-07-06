package jp.co.hisas.career.app.talent.api.profile.avatar;

import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class ProfileAvatarEvHdlr extends AbstractEventHandler<ProfileAvatarEvArg, ProfileAvatarEvRslt> {
	
	public static ProfileAvatarEvRslt exec( ProfileAvatarEvArg arg ) throws CareerException {
		ProfileAvatarEvHdlr handler = new ProfileAvatarEvHdlr();
		return handler.call( arg );
	}
	
	public ProfileAvatarEvRslt call( ProfileAvatarEvArg arg ) throws CareerException {
		ProfileAvatarEvRslt result = null;
		Log.method( arg.getLoginNo(), "IN", "" );
		if (Log.isDebugMode()) {
			result = this.execute( arg );
		} else {
			result = this.callEjb( arg );
		}
		Log.method( arg.getLoginNo(), "OUT", "" );
		return result;
	}
	
	protected ProfileAvatarEvRslt execute( ProfileAvatarEvArg arg ) throws CareerException {
		arg.validateArg();
		ProfileAvatarEvRslt result = new ProfileAvatarEvRslt();
		try {
			
			if (SU.equals( "GET", arg.sharp )) {
				
				ProfileAvatarLogicGet logic = new ProfileAvatarLogicGet();
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
