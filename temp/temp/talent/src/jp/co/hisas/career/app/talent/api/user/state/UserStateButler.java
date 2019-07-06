package jp.co.hisas.career.app.talent.api.user.state;

import java.util.Map;

import com.google.gson.Gson;

import jp.co.hisas.career.app.talent.api.Butler;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.Tray;

public class UserStateButler extends Butler {
	
	public UserStateButler(Tray tray) {
		super( tray );
	}
	
	@Override
	public String takePUT() throws CareerException {
		Map<String, String> params = tray.getRequestBodyAsJSON();
		if (params != null && params.size() > 0) {
			updateUserState( params );
		}
		Gson gson = new Gson();
		return gson.toJson( null );
	}
	
	private void updateUserState( Map<String, String> params ) {
		updateSessionAttr( params, JvSessionKey.VTLSRL_LIST_MODE );
	}
	
	private void updateSessionAttr( Map<String, String> params, String sessionKey ) {
		if (params.containsKey( sessionKey )) {
			tray.session.setAttribute( sessionKey, params.get( sessionKey ) );
		}
	}
	
}
