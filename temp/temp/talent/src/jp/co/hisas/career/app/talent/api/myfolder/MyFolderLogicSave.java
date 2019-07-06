package jp.co.hisas.career.app.talent.api.myfolder;

import java.sql.SQLException;

import jp.co.hisas.career.app.talent.dto.JvTrMyfoldDto;
import jp.co.hisas.career.app.talent.garage.MyFoldGarage;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;

public class MyFolderLogicSave {
	
	private String daoLoginNo;
	private MyFolderEvRslt evRslt;
	
	public MyFolderLogicSave(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new MyFolderEvRslt();
	}
	
	protected MyFolderEvRslt main( MyFolderEvArg arg ) throws SQLException {
		
		MyFoldGarage ggMf = new MyFoldGarage( daoLoginNo );
		String myfoldId;
		
		if (SU.isBlank( arg.myfoldId )) {
			// Create
			myfoldId = "MYF" + System.currentTimeMillis();
			ggMf.insertMyfold( makeDtoForNew( myfoldId, arg.foldNm, arg.guid, arg.isShared ) );
			ggMf.insertMyfoldPtc( myfoldId, arg.party, arg.guid );
			ggMf.insertMyfoldLog( myfoldId, arg.getLoginNo(), "create", "" );
		}
		else {
			// Update
			myfoldId = arg.myfoldId;
			ggMf.updateMyfold( myfoldId, arg.foldNm, arg.guid );
			ggMf.insertMyfoldLog( myfoldId, arg.getLoginNo(), "update", "" );
		}
		
		evRslt.myfoldId = myfoldId;
		
		return evRslt;
	}
	
	private JvTrMyfoldDto makeDtoForNew( String myfoldId, String foldNm, String guid, boolean isShared ) {
		String timestamp = AU.getTimestamp( "yyyy/MM/dd HH:mm:ss" );
		JvTrMyfoldDto dto = new JvTrMyfoldDto();
		dto.setMyfoldId( myfoldId );
		dto.setMyfoldNm( foldNm );
		dto.setSharedFlg( isShared ? 1 : 0 );
		dto.setBindOnlyFlg( 1 );
		dto.setMadeBy( guid );
		dto.setMadeAt( timestamp );
		dto.setUpdBy( guid );
		dto.setUpdAt( timestamp );
		return dto;
	}
	
}
