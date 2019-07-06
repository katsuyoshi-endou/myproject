package jp.co.hisas.career.app.talent.api.profile.avatar;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;

import jp.co.hisas.career.app.talent.bean.PersonalPictureBean;
import jp.co.hisas.career.app.talent.garage.ProfileGarage;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dto.CaRegistDto;

public class ProfileAvatarLogicGet {
	
	private ProfileAvatarEvRslt evRslt;
	
	public ProfileAvatarLogicGet() {
		this.evRslt = new ProfileAvatarEvRslt();
	}
	
	protected ProfileAvatarEvRslt main( ProfileAvatarEvArg arg ) throws CareerException, IOException {
		
		boolean hasPicture = false;
		String contentType = "";
		PersonalPictureBean bean = null;
		byte[] picture = null;
		String ctxRealPath = arg.ctxRealPath;
		
		String tgtGuid = detectTargetGuid( arg );
		
		if (SU.isNotBlank( tgtGuid )) {
			ProfileGarage ggPr = new ProfileGarage( arg.getLoginNo() );
			bean = ggPr.getProfileAvatar( tgtGuid );
			hasPicture = (bean != null && bean.getPicture() != null);
		}
		
		if (hasPicture) {
			contentType = bean.getContent_type();
			picture = bean.getPicture();
		}
		else {
			final ByteArrayOutputStream baos = new ByteArrayOutputStream();
			final byte[] buffer = new byte[4096];
			final FileInputStream fin = new FileInputStream( ctxRealPath + "/assets/img/photo/dummy.gif" );
			int size;
			while ((size = fin.read( buffer )) != -1) {
				baos.write( buffer, 0, size );
			}
			fin.close();
			baos.close();
			contentType = "image/gif";
			picture = baos.toByteArray();
		}
		
		evRslt.contentType = contentType;
		evRslt.picture = picture;
		
		return evRslt;
	}

	private String detectTargetGuid( ProfileAvatarEvArg arg ) {
		String tgtGuid = null;
		if (SU.isNotBlank( arg.tgtGuid )) {
			tgtGuid = arg.tgtGuid;
		} else {
			ProfileGarage ggPr = new ProfileGarage( arg.getLoginNo() );
			CaRegistDto registDto = ggPr.getByCmpaStf( arg.tgtCmpaCd, arg.tgtStfNo );
			tgtGuid = registDto == null ? null : registDto.getGuid();
		}
		return tgtGuid;
	}
	
}
