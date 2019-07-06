package jp.co.hisas.career.app.talent.api.mysearch;

import java.sql.SQLException;

import jp.co.hisas.career.app.talent.garage.MySrchGarage;
import jp.co.hisas.career.util.SU;

public class MySearchLogicSave {
	
	private String daoLoginNo;
	private MySearchEvRslt evRslt;
	
	public MySearchLogicSave(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new MySearchEvRslt();
	}
	
	protected MySearchEvRslt main( MySearchEvArg arg ) throws SQLException {
		
		MySrchGarage ggMs = new MySrchGarage( daoLoginNo );
		String mysrchId;
		
		if (SU.isBlank( arg.mysrchId )) {
			// Create
			mysrchId = "MYS" + System.currentTimeMillis();
			ggMs.deleteMysrch( mysrchId );
			ggMs.insertMysrch( mysrchId, arg.mysrchNm, arg.guid, arg.isShared );
			ggMs.deleteMysrchPtc( mysrchId, arg.party, arg.guid );
			ggMs.insertMysrchPtc( mysrchId, arg.party, arg.guid );
			ggMs.deleteMysrchCndSgl( mysrchId );
			ggMs.insertMysrchCndSgl( mysrchId, arg.saveHistDtlSglMap );
			ggMs.deleteMysrchCndMlt( mysrchId );
			ggMs.insertMysrchCndMlt( mysrchId, arg.saveHistDtlMltMap );
			ggMs.deleteMysrchCndLgc( mysrchId );
			ggMs.insertMysrchCndLgc( mysrchId, arg.saveHistDtlLgcList );
			ggMs.deleteMysrchCndSlf( mysrchId );
			ggMs.insertMysrchCndSlf( mysrchId, arg.saveHistShelftypeMap );
			ggMs.insertMysrchLog( mysrchId, arg.guid, "create", "" );
		}
		else {
			// Update
			mysrchId = arg.mysrchId;
			ggMs.updateMysrch( mysrchId, arg.mysrchNm, arg.guid );
			ggMs.deleteMysrchCndSgl( mysrchId );
			ggMs.insertMysrchCndSgl( mysrchId, arg.saveHistDtlSglMap );
			ggMs.deleteMysrchCndMlt( mysrchId );
			ggMs.insertMysrchCndMlt( mysrchId, arg.saveHistDtlMltMap );
			ggMs.deleteMysrchCndLgc( mysrchId );
			ggMs.insertMysrchCndLgc( mysrchId, arg.saveHistDtlLgcList );
			ggMs.deleteMysrchCndSlf( mysrchId );
			ggMs.insertMysrchCndSlf( mysrchId, arg.saveHistShelftypeMap );
			ggMs.insertMysrchLog( mysrchId, arg.guid, "update", "" );
		}
		
		evRslt.savedMysrchId = mysrchId;
		
		return evRslt;
	}
	
}
