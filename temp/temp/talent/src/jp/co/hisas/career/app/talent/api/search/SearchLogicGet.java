package jp.co.hisas.career.app.talent.api.search;

import java.sql.SQLException;
import java.util.List;

import jp.co.hisas.career.app.talent.dto.JvDfQuickRegexDto;
import jp.co.hisas.career.app.talent.dto.JvDfQuickWordDto;
import jp.co.hisas.career.app.talent.dto.extra.JvSrchRsltWkDtoEx;
import jp.co.hisas.career.app.talent.garage.ProfileGarage;
import jp.co.hisas.career.app.talent.garage.QuickSearchGarage;
import jp.co.hisas.career.app.talent.garage.SrchBindGarage;
import jp.co.hisas.career.app.talent.garage.SrchRsltWkGarage;
import jp.co.hisas.career.util.SU;

public class SearchLogicGet {
	
	private String daoLoginNo;
	private SearchEvRslt evRslt;
	
	public SearchLogicGet( String daoLoginNo ) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new SearchEvRslt();
	}
	
	protected SearchEvRslt main( SearchEvArg arg ) throws SQLException {
		
		SrchRsltWkGarage ggWk = new SrchRsltWkGarage( daoLoginNo );
		QuickSearchGarage ggQs = new QuickSearchGarage( daoLoginNo );
		ProfileGarage ggPr = new ProfileGarage( daoLoginNo );
		SrchBindGarage ggBd = new SrchBindGarage( daoLoginNo );
		
		/* Clear Work Data */
		ggWk.clearResultWk( arg.getLoginNo() );
		
		/* Make Work Data */
		ggWk.makeWorkAll( arg.sessionId, arg.party, arg.guid );
		
		/* Query Log */
		ggQs.insertQuickSearchLog( arg.party, arg.guid, arg.query );
		
		/* Query Split */
		String[] queries = SU.split( arg.query, " " );
		
		/* Role List */
		List<String> roleList = ggBd.getRoleList( arg.party, arg.getLoginNo() );
		
		for (String roleId : roleList) {
			execQuickSearchByRole( arg.sessionId, arg.party, arg.guid, roleId, queries );
		}
		
		/* Get Work Hit Count */
		evRslt.hitCount = ggWk.getWorkCount( arg.sessionId );
		
		/* Get Search Result Profiles */
		List<JvSrchRsltWkDtoEx> targetList = ggWk.getTargetList( arg.sessionId, arg.party );
		evRslt.profiles = ggPr.getProfiles( arg.party, arg.guid, targetList );
		
		return evRslt;
	}

	private void execQuickSearchByRole( String sessionId, String party, String loginGuid, String roleId, String[] queries ) {
		
		QuickSearchGarage ggQs = new QuickSearchGarage( daoLoginNo );
		SrchRsltWkGarage ggWk = new SrchRsltWkGarage( daoLoginNo );
		
		List<JvDfQuickRegexDto> dfRegexList = ggQs.getDfQuickRegex( party, roleId );
		List<JvDfQuickWordDto> dfWordList = ggQs.getDfQuickWord( party, roleId );
		
		nextquery: for (String q : queries) {
			
			/* Phase.1 - Delete by Regex */
			for (JvDfQuickRegexDto dfRegex : dfRegexList) {
				if (SU.matches( q, dfRegex.getRegexPtn() )) {
					String searchVal = SU.extractWithRegex( q, dfRegex.getRegexPtn() );
					ggWk.deleteByQuickRegex( sessionId, party, loginGuid, roleId, dfRegex.getPzId(), dfRegex.getOperator(), searchVal );
					if (SU.judge( dfRegex.getOverFlg() )) { continue nextquery; }
				}
			}
			
			/* Phase.2 - Delete by Word */
			for (JvDfQuickWordDto dfWord : dfWordList) {
				if (SU.equals( q, dfWord.getWord() )) {
					ggWk.deleteByQuickRegex( sessionId, party, loginGuid, roleId, dfWord.getPzId(), "eq", q );
					if (SU.judge( dfWord.getOverFlg() )) { continue nextquery; }
				}
			}
			
			/* Phase.3 - Delete by All */
			ggWk.deleteByQuickAll( sessionId, party, loginGuid, roleId, q );
		}
	}
	
}
