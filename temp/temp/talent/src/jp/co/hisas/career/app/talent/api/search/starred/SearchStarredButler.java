package jp.co.hisas.career.app.talent.api.search.starred;

import com.google.gson.Gson;

import jp.co.hisas.career.app.talent.api.Butler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.Tray;

public class SearchStarredButler extends Butler {
	
	public SearchStarredButler(Tray tray) {
		super( tray );
	}
	
	@Override
	public String takeGET() throws CareerException {
		
		SearchStarredEvArg arg = new SearchStarredEvArg( tray.loginNo );
		arg.sharp = "GET";
		arg.sessionId = tray.session.getId();
		arg.party = AU.getParty( tray.session );
		arg.guid = tray.loginNo;
		SearchStarredEvRslt rslt = SearchStarredEvHdlr.exec( arg );
		
		Gson gson = new Gson();
		return gson.toJson( rslt );
	}
	
}
