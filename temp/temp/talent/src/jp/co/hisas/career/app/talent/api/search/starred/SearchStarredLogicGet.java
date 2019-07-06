package jp.co.hisas.career.app.talent.api.search.starred;

import java.sql.SQLException;
import java.util.List;

import jp.co.hisas.career.app.talent.dto.extra.JvSrchRsltWkDtoEx;
import jp.co.hisas.career.app.talent.garage.ProfileGarage;
import jp.co.hisas.career.app.talent.garage.SrchRsltWkGarage;

public class SearchStarredLogicGet {
	
	private SearchStarredEvRslt evRslt;
	
	public SearchStarredLogicGet(String daoLoginNo) {
		this.evRslt = new SearchStarredEvRslt();
	}
	
	protected SearchStarredEvRslt main( SearchStarredEvArg arg ) throws SQLException {
		
		SrchRsltWkGarage ggWk = new SrchRsltWkGarage( arg.getLoginNo() );
		ProfileGarage ggPr = new ProfileGarage( arg.getLoginNo() );
		
		/* Clear Work Data */
		ggWk.clearResultWk( arg.getLoginNo() );
		
		/* Make Work Data */
		ggWk.makeWorkStarred( arg.sessionId, arg.party, arg.guid );
		
		/* Update WK_IDX for sort and separated fetch */
		ggWk.updateWkIdx( arg.sessionId, arg.party, arg.guid );
		
		/* Get Work Hit Count */
		evRslt.hitCount = ggWk.getWorkCount( arg.sessionId );
		
		/* Get Profile List from Work Data */
		List<JvSrchRsltWkDtoEx> targetList = ggWk.getTargetList( arg.sessionId, arg.party );
		evRslt.profiles = ggPr.getProfiles( arg.party, arg.guid, targetList );
		
		return evRslt;
	}
	
}
