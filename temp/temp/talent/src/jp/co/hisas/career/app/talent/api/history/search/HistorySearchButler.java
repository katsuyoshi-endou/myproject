package jp.co.hisas.career.app.talent.api.history.search;

import com.google.gson.Gson;

import jp.co.hisas.career.app.talent.api.Butler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.Tray;

public class HistorySearchButler extends Butler {
	
	public HistorySearchButler(Tray tray) {
		super( tray );
	}
	
	@Override
	public String takeGET() throws CareerException {
		
		HistorySearchEvArg arg = new HistorySearchEvArg( tray.loginNo );
		arg.sharp = "GET";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		HistorySearchEvRslt rslt = HistorySearchEvHdlr.exec( arg );
		
		Gson gson = new Gson();
		return gson.toJson( rslt );
	}
	
}
