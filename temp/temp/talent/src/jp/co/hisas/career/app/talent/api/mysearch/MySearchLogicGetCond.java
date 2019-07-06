package jp.co.hisas.career.app.talent.api.mysearch;

import jp.co.hisas.career.app.talent.garage.LegacySrchCndGarage;
import jp.co.hisas.career.app.talent.garage.MySrchCndLgcGarage;
import jp.co.hisas.career.app.talent.garage.MySrchCndSglMltGarage;
import jp.co.hisas.career.app.talent.garage.MySrchCndSlfGarage;
import jp.co.hisas.career.app.talent.garage.MySrchGarage;
import jp.co.hisas.career.util.SU;

public class MySearchLogicGetCond {
	
	private String daoLoginNo;
	private MySearchEvRslt evRslt;
	
	public MySearchLogicGetCond(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new MySearchEvRslt();
	}
	
	protected MySearchEvRslt main( MySearchEvArg arg ) throws Exception {
		
		MySrchGarage ggMs = new MySrchGarage( daoLoginNo );
		LegacySrchCndGarage ggLc = new LegacySrchCndGarage( daoLoginNo );
		MySrchCndLgcGarage ggLg = new MySrchCndLgcGarage( daoLoginNo );
		MySrchCndSglMltGarage ggSm = new MySrchCndSglMltGarage( daoLoginNo );
		MySrchCndSlfGarage ggSf = new MySrchCndSlfGarage( daoLoginNo );
		
		evRslt.mySearch  = ggMs.getJvTrMysrch( arg.mysrchId );
		boolean isShared = SU.judge( evRslt.mySearch.getSharedFlg() );
		evRslt.cndLgcDef = ggLc.getSrchCndLgcDef( arg.party, arg.guid, isShared );
		evRslt.lgcList   = ggLg.selectMysrchCndLgcList( arg.mysrchId );
		evRslt.sglMap    = ggSm.getSavedMySearchSglMap( arg.mysrchId );
		evRslt.mltMap    = ggSm.getSavedMySearchMltMap( arg.mysrchId );
		evRslt.slfMap    = ggSf.getSavedMySearchSlfMap( arg.mysrchId );
		
		return evRslt;
	}
	
}
