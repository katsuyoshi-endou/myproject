package jp.co.hisas.career.app.talent.api.shareptc.find;

import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jp.co.hisas.career.app.talent.api.Butler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;

public class SharePtcFindButler extends Butler {
	
	public SharePtcFindButler(Tray tray) {
		super( tray );
	}
	
	@Override
	public String takeGET() throws CareerException {
		
		SharePtcFindEvArg arg = new SharePtcFindEvArg( tray.loginNo );
		arg.sharp = "GET";
		arg.party = tray.party;
		arg.queryMap = makeQueryMap();
		SharePtcFindEvRslt rslt = SharePtcFindEvHdlr.exec( arg );
		
		Gson gson = new Gson();
		return gson.toJson( rslt );
	}
	
	private Map<String, String> makeQueryMap() {
		Map<String, String> map = new HashMap<String, String>();
		//TODO: Security Check
		map.put( "name", SU.ntb( AU.getRequestValue( tray.request, "name" ) ) );
		map.put( "dept", SU.ntb( AU.getRequestValue( tray.request, "dept" ) ) );
		map.put( "yksk", SU.ntb( AU.getRequestValue( tray.request, "yksk" ) ) );
		return map;
	}
}
