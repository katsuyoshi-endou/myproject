package jp.co.hisas.career.app.talent.api.mysearch;

import java.sql.SQLException;

import jp.co.hisas.career.app.talent.garage.MySrchGarage;

public class MySearchLogicDelete {
	
	private String daoLoginNo;
	private MySearchEvRslt evRslt;
	
	public MySearchLogicDelete(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new MySearchEvRslt();
	}
	
	protected MySearchEvRslt main( MySearchEvArg arg ) throws SQLException {
		
		MySrchGarage ggMs = new MySrchGarage( daoLoginNo );
		String mysrchId = arg.mysrchId;
		
		ggMs.deleteMysrch( mysrchId );
		ggMs.deleteMysrchPtc( mysrchId, arg.party, arg.guid );
		ggMs.deleteMysrchCndSgl( mysrchId );
		ggMs.deleteMysrchCndMlt( mysrchId );
		ggMs.deleteMysrchCndLgc( mysrchId );
		ggMs.deleteMysrchCndSlf( mysrchId );
		
		return evRslt;
	}
	
}
