package jp.co.hisas.career.app.talent.api.profile.avatar;

import java.io.IOException;

import javax.servlet.ServletOutputStream;

import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.ResponsedServlet;
import jp.co.hisas.career.util.Tray;

public class ProfileAvatarAPI extends ResponsedServlet {
	
	private static final long serialVersionUID = 1L;
	
	@Override
	public void serviceMain( Tray tray ) throws CareerException, IOException {
		
		ProfileAvatarButler butler = new ProfileAvatarButler( tray );
		String ctxRealPath = this.ctx.getRealPath( "" );
		ProfileAvatarEvRslt rslt = butler.takeProfileAvatar( ctxRealPath );
		
		tray.response.setContentType( rslt.contentType );
		tray.response.setHeader( "Content-disposition", "inline; " );
		
		final ServletOutputStream sout = tray.response.getOutputStream();
		sout.write( rslt.picture );
		sout.close();
	}
	
}
