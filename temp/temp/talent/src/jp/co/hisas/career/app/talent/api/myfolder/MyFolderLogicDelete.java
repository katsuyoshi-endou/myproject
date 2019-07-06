package jp.co.hisas.career.app.talent.api.myfolder;

import java.sql.SQLException;

import jp.co.hisas.career.app.talent.garage.MyFoldGarage;

public class MyFolderLogicDelete {
	
	private String daoLoginNo;
	private MyFolderEvRslt evRslt;
	
	public MyFolderLogicDelete(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new MyFolderEvRslt();
	}
	
	protected MyFolderEvRslt main( MyFolderEvArg arg ) throws SQLException {
		
		MyFoldGarage ggMf = new MyFoldGarage( daoLoginNo );
		
		ggMf.deleteMyfold( arg.myfoldId );
		ggMf.deleteMyfoldPtc( arg.myfoldId );
		ggMf.deleteMyfoldTalent( arg.myfoldId );
		
		return evRslt;
	}
	
}
