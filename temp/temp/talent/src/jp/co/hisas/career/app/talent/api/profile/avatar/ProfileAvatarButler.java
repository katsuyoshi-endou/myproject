package jp.co.hisas.career.app.talent.api.profile.avatar;

import jp.co.hisas.career.app.talent.api.Butler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.Tray;

public class ProfileAvatarButler extends Butler {
	
	public ProfileAvatarButler(Tray tray) {
		super( tray );
	}
	
	public ProfileAvatarEvRslt takeProfileAvatar(String ctxRealPath) throws CareerException {
		
		ProfileAvatarEvArg arg = new ProfileAvatarEvArg( tray.loginNo );
		arg.sharp = "GET";
		arg.party = tray.party;
		arg.tgtGuid = AU.getRequestValue( tray.request, "g" );
		arg.tgtCmpaCd = AU.getRequestValue( tray.request, "c" );
		arg.tgtStfNo = AU.getRequestValue( tray.request, "s" );
		arg.ctxRealPath = ctxRealPath;
		ProfileAvatarEvRslt rslt = ProfileAvatarEvHdlr.exec( arg );
		
		return rslt;
	}
	
}
