package jp.co.hisas.career.app.talent.api.history.profile;

import java.sql.SQLException;

import jp.co.hisas.career.app.talent.garage.HistoryProfileGarage;

public class HistoryProfileLogicPost {
	
	private HistoryProfileEvRslt evRslt;
	
	public HistoryProfileLogicPost() {
		this.evRslt = new HistoryProfileEvRslt();
	}
	
	protected HistoryProfileEvRslt main( HistoryProfileEvArg arg ) throws SQLException {
		
		HistoryProfileGarage gg = new HistoryProfileGarage( arg.getLoginNo() );
		
		gg.insertProfileViewHistory( arg.party, arg.guid, arg.tgtCmpaCd, arg.tgtStfNo );
		
		return evRslt;
	}
	
}
