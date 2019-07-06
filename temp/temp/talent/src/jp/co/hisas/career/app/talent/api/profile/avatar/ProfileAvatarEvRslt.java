package jp.co.hisas.career.app.talent.api.profile.avatar;

import jp.co.hisas.career.ejb.AbstractEventResult;

@SuppressWarnings("serial")
public class ProfileAvatarEvRslt extends AbstractEventResult {
	
	public String contentType;
	public byte[] picture;
	
}
