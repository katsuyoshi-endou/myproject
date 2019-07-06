package jp.co.hisas.career.app.talent.api.history.profile;

import java.util.Map;

import com.google.gson.Gson;

import jp.co.hisas.career.app.talent.api.Butler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.Tray;

public class HistoryProfileButler extends Butler {
	
	public HistoryProfileButler(Tray tray) {
		super( tray );
	}
	
	@Override
	public String takeGET() throws CareerException {
		
		HistoryProfileEvArg arg = new HistoryProfileEvArg( tray.loginNo );
		arg.sharp = "GET";
		arg.sessionId = tray.session.getId();
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		HistoryProfileEvRslt rslt = HistoryProfileEvHdlr.exec( arg );
		
		Gson gson = new Gson();
		return gson.toJson( rslt );
	}
	
	@Override
	public String takePOST() throws CareerException {
		
		Map<String, String> params = tray.convertPostRequestBodyToMap();
		
		HistoryProfileEvArg arg = new HistoryProfileEvArg( tray.loginNo );
		arg.sharp = "POST";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.tgtCmpaCd = params.get( "c" );
		arg.tgtStfNo = params.get( "s" );
		HistoryProfileEvRslt rslt = HistoryProfileEvHdlr.exec( arg );
		
		Gson gson = new Gson();
		return gson.toJson( rslt );
	}
	
}
