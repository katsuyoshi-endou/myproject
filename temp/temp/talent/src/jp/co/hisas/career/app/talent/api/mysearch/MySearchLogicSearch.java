package jp.co.hisas.career.app.talent.api.mysearch;

import java.sql.SQLException;

import jp.co.hisas.career.app.talent.garage.MySrchCndLgcGarage;
import jp.co.hisas.career.app.talent.garage.MySrchCndSglMltGarage;
import jp.co.hisas.career.app.talent.garage.MySrchCndSlfGarage;
import jp.co.hisas.career.app.talent.garage.SrchRsltWkGarage;

public class MySearchLogicSearch {
	
	private String daoLoginNo;
	private MySearchEvRslt evRslt;
	
	public MySearchLogicSearch(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new MySearchEvRslt();
	}
	
	protected MySearchEvRslt main( MySearchEvArg arg ) throws SQLException {
		
		SrchRsltWkGarage ggWk = new SrchRsltWkGarage( daoLoginNo );
		MySrchCndLgcGarage ggLg = new MySrchCndLgcGarage( daoLoginNo );
		MySrchCndSglMltGarage ggSm = new MySrchCndSglMltGarage( daoLoginNo );
		MySrchCndSlfGarage ggSf = new MySrchCndSlfGarage( daoLoginNo );
		
		/* Clear Work Data */
		ggWk.clearResultWk( arg.getLoginNo() );
		
		/* Condition search (LGC) */
		ggLg.execLegacySearch( arg.guid, arg.sessionId, arg.pzSearchBean, arg.isShared );
		
		/* Except Retire/Remove */
		if (arg.exceptRetire) {
			ggWk.reduceWkExceptRetireSBAW( arg.guid );
		}
		if (arg.exceptRemove) {
			ggWk.reduceWkExceptRemoveSBAW( arg.guid );
		}
		
		/* Condition search (SGL MLT) */
		ggSm.reduceByCondSglMlt( arg.guid, arg.pzSearchBean );
		
		/* Condition search (SLF) */
		ggSf.reduceByShelfCond( arg.guid, arg.shelfCondMap );
		
		/* Update WK_IDX for sort and separated fetch */
		ggWk.updateWkIdx( arg.sessionId, arg.party, arg.guid );
		
		return evRslt;
	}
	
}
