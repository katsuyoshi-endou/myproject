package jp.co.hisas.career.app.talent.deliver;

import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.dto.extra.JvWkInstantHitExDto;
import jp.co.hisas.career.app.talent.event.InstantSearchEvArg;
import jp.co.hisas.career.app.talent.event.InstantSearchEvHdlr;
import jp.co.hisas.career.app.talent.event.InstantSearchEvRslt;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;

public class InstantSearchDeliver {
	
	public static InstantSearchEvRslt execSearch( Tray tray ) throws CareerException {
		String instantQuery = AU.getRequestValue( tray.request, "instant_query" );
		InstantSearchEvArg arg = new InstantSearchEvArg( tray.loginNo );
		arg.sharp = "SEARCH";
		arg.party = tray.party;
		arg.sessionId = tray.session.getId();
		arg.guid = tray.loginNo;
		arg.query = SU.trim( SU.replaceAll( instantQuery, "　", " " ) );
		arg.scopes = AU.getRequestValues( tray.request, "scopes" );
		arg.exceptRetire = SU.equals( "on", AU.getRequestValue( tray.request, "currentstatus_except_retire" ) );
		arg.exceptRemove = SU.equals( "on", AU.getRequestValue( tray.request, "currentstatus_except_remove" ) );
		return InstantSearchEvHdlr.exec( arg );
	}
	
	public static void execMltstfnoSearch( Tray tray ) throws CareerException {
		InstantSearchEvArg arg = new InstantSearchEvArg( tray.loginNo );
		arg.sharp = "MLTSTFNO";
		arg.party = tray.party;
		arg.sessionId = tray.session.getId();
		arg.guid = tray.loginNo;
		arg.multiStfnoList = makeMultiStfnoList( tray );
		InstantSearchEvHdlr.exec( arg );
	}
	
	private static List<String> makeMultiStfnoList( Tray tray ) {
		List<String> list = new ArrayList<String>();
		String reqMultiStfnoList = AU.getRequestValue( tray.request, "multi_stfno_list" );
		String[] arr = SU.split( reqMultiStfnoList, '\n' );
		if (SU.isBlank( arr )) {
			return list;
		}
		for (String raw : arr) {
			String s = SU.trim( raw );
			if (SU.isNotBlank( s )) {
				list.add( s );
			}
		}
		SU.allowsOnlyCode( list );
		return list;
	}
	
	public static List<JvWkInstantHitExDto> loadInstantHitPzItems( Tray tray ) throws CareerException {
		InstantSearchEvArg arg = new InstantSearchEvArg( tray.loginNo );
		arg.sharp = "LOAD_HIT";
		arg.party = tray.party;
		arg.sessionId = tray.session.getId();
		InstantSearchEvRslt rslt = InstantSearchEvHdlr.exec( arg );
		return rslt.hitPzList;
	}
	
}
