package jp.co.hisas.career.app.talent.api.pool;

import com.google.gson.Gson;

import jp.co.hisas.career.app.talent.api.Butler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;

public class PoolButler extends Butler {
	
	public PoolButler(Tray tray) {
		super( tray );
	}
	
	@Override
	public String takeGET() throws CareerException {
		
		PoolEvArg arg = new PoolEvArg( tray.loginNo );
		arg.sharp = "GET";
		arg.sessionId = tray.session.getId();
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.wkIdxBetweenA = SU.toInt( AU.getRequestValue( tray.request, "wkidx_between_a" ), 0 );
		arg.wkIdxBetweenB = SU.toInt( AU.getRequestValue( tray.request, "wkidx_between_b" ), 0 );
		PoolEvRslt rslt = PoolEvHdlr.exec( arg );
		
		Gson gson = new Gson();
		return gson.toJson( rslt );
	}
}