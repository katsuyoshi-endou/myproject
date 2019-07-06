package jp.co.hisas.career.app.talent.event;

import java.sql.SQLException;

import jp.co.hisas.career.app.talent.garage.SrchRsltWkGarage;

public class InstantSearchLogicMltsearch {
	
	private String daoLoginNo;
	private InstantSearchEvRslt evRslt;
	
	public InstantSearchLogicMltsearch(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new InstantSearchEvRslt();
	}
	
	protected InstantSearchEvRslt main( InstantSearchEvArg arg ) throws SQLException {
		
		SrchRsltWkGarage ggWk = new SrchRsltWkGarage( daoLoginNo );
		
		/* Clear Work Data */
		ggWk.clearResultWk( daoLoginNo );
		
		/* Reduce by Multi StfNo List */
		if (arg.multiStfnoList.size() > 0) {
			ggWk.insertWkMultiStfnoListSBAW( arg.sessionId, arg.party, arg.guid, arg.multiStfnoList );
		}
		
		/* Update WK_IDX for sort and separated fetch */
		ggWk.updateWkIdx( arg.sessionId, arg.party, arg.guid );
		
		return evRslt;
	}
	
}
