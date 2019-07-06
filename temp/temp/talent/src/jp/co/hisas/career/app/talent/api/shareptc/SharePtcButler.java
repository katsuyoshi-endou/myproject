package jp.co.hisas.career.app.talent.api.shareptc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

import jp.co.hisas.career.app.talent.api.Butler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;

public class SharePtcButler extends Butler {
	
	public SharePtcButler(Tray tray) {
		super( tray );
	}
	
	@Override
	public String takeGET() throws CareerException {
		
		SharePtcEvArg arg = new SharePtcEvArg( tray.loginNo );
		arg.sharp = "GET";
		arg.party = tray.party;
		arg.albumMode = AU.getRequestValue( tray.request, "amd" );
		arg.albumId = AU.getRequestValue( tray.request, "aid" );
		SharePtcEvRslt rslt = SharePtcEvHdlr.exec( arg );
		
		Gson gson = new Gson();
		return gson.toJson( rslt );
	}
	
	@Override
	public String takePOST() throws CareerException {
		
		SharePtcEvArg arg = new SharePtcEvArg( tray.loginNo );
		arg.sharp = "POST";
		arg.party = tray.party;
		arg.albumMode = AU.getRequestValue( tray.request, "amd" );
		arg.albumId = AU.getRequestValue( tray.request, "aid" );
		arg.tgtGuid = AU.getRequestValue( tray.request, "guid" );
		SharePtcEvRslt rslt = SharePtcEvHdlr.exec( arg );
		
		Gson gson = new Gson();
		return gson.toJson( rslt );
	}
	
	@Override
	public String takePUT() throws CareerException {
		
		Map<String, String> params = tray.getRequestBodyAsJSON();
		
		SharePtcEvArg arg = new SharePtcEvArg( tray.loginNo );
		arg.sharp = "PUT";
		arg.action = params.get( "action" );
		arg.party = tray.party;
		arg.albumMode = params.get( "amd" );
		arg.albumId = params.get( "aid" );
		arg.editableMap = makeEditableMap( params );
		arg.deletedList = makeDeletedList( params );
		arg.prevOwner = tray.loginNo;
		arg.nextOwner = params.get( "next_owner" );
		SharePtcEvRslt rslt = SharePtcEvHdlr.exec( arg );
		
		Gson gson = new Gson();
		return gson.toJson( rslt );
	}
	
	private Map<String, String> makeEditableMap( Map<String, String> params ) {
		Map<String, String> editableMap = new HashMap<String, String>();
		for (Map.Entry<String, String> entry : params.entrySet()) {
			String key = entry.getKey();
			String val = entry.getValue();
			if (SU.matches( key, "^editable__\\w+$" )) {
				String guid = SU.extract( key, "^editable__(\\w+)$" );
				String flg = SU.judge( val ) ? "1" : "0";
				editableMap.put( guid, flg );
			}
		}
		return editableMap;
	}
	
	private List<String> makeDeletedList( Map<String, String> params ) {
		List<String> list = new ArrayList<String>();
		for (Map.Entry<String, String> entry : params.entrySet()) {
			String key = entry.getKey();
			if (SU.matches( key, "^deleted__\\w+$" )) {
				String guid = SU.extract( key, "^deleted__(\\w+)$" );
				list.add( guid );
			}
		}
		return list;
	}
	
}
