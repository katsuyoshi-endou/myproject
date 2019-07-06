package jp.co.hisas.career.app.talent.api.star;

import java.util.Map;

import com.google.gson.Gson;

import jp.co.hisas.career.app.talent.api.Butler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.Tray;

public class StarButler extends Butler {
	
	public StarButler(Tray tray) {
		super( tray );
	}
	
	@Override
	public String takePOST() throws CareerException {
		
		Map<String, String> params = tray.convertPostRequestBodyToMap();
		
		StarEvArg arg = new StarEvArg( tray.loginNo );
		arg.sharp = "POST";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.tgtCmpaCd = params.get( "c" );
		arg.tgtStfNo = params.get( "s" );
		StarEvRslt rslt = StarEvHdlr.exec( arg );
		
		Gson gson = new Gson();
		return gson.toJson( rslt );
	}
	
	@Override
	public String takeDELETE() throws CareerException {
		
		StarEvArg arg = new StarEvArg( tray.loginNo );
		arg.sharp = "DELETE";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.tgtCmpaCd = AU.getRequestValue( tray.request, "c" );
		arg.tgtStfNo = AU.getRequestValue( tray.request, "s" );
		StarEvRslt rslt = StarEvHdlr.exec( arg );
		
		Gson gson = new Gson();
		return gson.toJson( rslt );
	}
	
}
