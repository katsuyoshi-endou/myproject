package jp.co.hisas.career.app.talent.api.search;

import com.google.gson.Gson;

import jp.co.hisas.career.app.talent.api.Butler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;

public class SearchButler extends Butler {
	
	public SearchButler(Tray tray) {
		super( tray );
	}
	
	@Override
	public String takeGET() throws CareerException {
		
		String query = AU.getRequestValue( tray.request, "query" );
		
		SearchEvArg arg = new SearchEvArg( tray.loginNo );
		arg.sharp = "GET";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.sessionId = tray.session.getId();
		arg.query = SU.trim( SU.replaceAll( query, "　", " " ) );
		SearchEvRslt rslt = SearchEvHdlr.exec( arg );
		
		Gson gson = new Gson();
		return gson.toJson( rslt );
	}
	
}
