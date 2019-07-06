package jp.co.hisas.career.app.talent.api.profile.avatar;

import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;

@SuppressWarnings("serial")
public class ProfileAvatarEvArg extends AbstractEventArg {
	
	public String sharp = null;
	public String party;
	public String guid;
	public String tgtGuid;
	public String tgtCmpaCd;
	public String tgtStfNo;
	public String ctxRealPath;
	
	public ProfileAvatarEvArg(String loginNo) throws CareerException {
		if (loginNo == null) {
			throw new CareerException( "Invalid Arg: loginNo is null." );
		}
		this.setLoginNo( loginNo );
	}
	
	public void validateArg() throws CareerException {
		if (SU.isBlank( sharp )) {
			throw new CareerException( "Invalid ProfileAvatarEvArg: sharp is null." );
		}
	}
	
}
