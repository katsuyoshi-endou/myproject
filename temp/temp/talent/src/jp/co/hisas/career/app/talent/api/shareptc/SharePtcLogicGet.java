package jp.co.hisas.career.app.talent.api.shareptc;

import jp.co.hisas.career.app.talent.garage.SharePtcGarage;
import jp.co.hisas.career.util.SU;

public class SharePtcLogicGet {
	
	private String daoLoginNo;
	private SharePtcEvRslt evRslt;
	
	public SharePtcLogicGet(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new SharePtcEvRslt();
	}
	
	protected SharePtcEvRslt main( SharePtcEvArg arg ) {
		
		if (SU.equals( arg.albumMode, "SEARCH" )) {
			SharePtcGarage ggSp = new SharePtcGarage( daoLoginNo );
			evRslt.ptcList = ggSp.getMysrchPtcList( arg.albumId, arg.party );
		}
		else if (SU.equals( arg.albumMode, "FOLDER" )) {
			SharePtcGarage ggSp = new SharePtcGarage( daoLoginNo );
			evRslt.ptcList = ggSp.getMyfoldPtcList( arg.albumId, arg.party );
		}
		
		return evRslt;
	}
	
}
