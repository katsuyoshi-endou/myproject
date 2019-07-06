package jp.co.hisas.career.app.talent.api.history.profile;

import java.sql.SQLException;
import java.util.List;

import jp.co.hisas.career.app.talent.dto.extra.JvSrchRsltWkDtoEx;
import jp.co.hisas.career.app.talent.garage.ProfileGarage;
import jp.co.hisas.career.app.talent.garage.SrchRsltWkGarage;

public class HistoryProfileLogicGet {
	
	private HistoryProfileEvRslt evRslt;
	
	public HistoryProfileLogicGet() {
		this.evRslt = new HistoryProfileEvRslt();
	}
	
	protected HistoryProfileEvRslt main( HistoryProfileEvArg arg ) throws SQLException {
		
		SrchRsltWkGarage ggWk = new SrchRsltWkGarage( arg.getLoginNo() );
		ProfileGarage ggPr = new ProfileGarage( arg.getLoginNo() );
		
		/* Clear Work Data */
		ggWk.clearResultWk( arg.getLoginNo() );
		
		/* Make Work Data */
		ggWk.makeWorkViewHistory( arg.sessionId, arg.party, arg.guid );
		
		/* Update WK_IDX for sort and separated fetch */
		ggWk.updateWkIdx( arg.sessionId, arg.party, arg.guid );
		
		/* Get Profile List from Work Data */
		List<JvSrchRsltWkDtoEx> targetList = ggWk.getProfileHistoryTargetList( arg.sessionId, arg.party );
		evRslt.profiles = ggPr.getProfiles( arg.party, arg.guid, targetList );
		
		return evRslt;
	}
	
}
