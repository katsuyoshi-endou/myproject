package jp.co.hisas.career.app.talent.api.shareptc;

import jp.co.hisas.career.app.talent.dao.JvTrMyfoldPtcDao;
import jp.co.hisas.career.app.talent.dao.JvTrMysrchPtcDao;
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldPtcDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchPtcDto;
import jp.co.hisas.career.app.talent.garage.MyFoldGarage;
import jp.co.hisas.career.app.talent.garage.MySrchGarage;
import jp.co.hisas.career.util.SU;

public class SharePtcLogicPost {
	
	private String daoLoginNo;
	private SharePtcEvRslt evRslt;
	
	public SharePtcLogicPost(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new SharePtcEvRslt();
	}
	
	protected SharePtcEvRslt main( SharePtcEvArg arg ) {
		
		MySrchGarage ggMs = new MySrchGarage( daoLoginNo );
		MyFoldGarage ggMf = new MyFoldGarage( daoLoginNo );
		
		if (SU.equals( arg.albumMode, "SEARCH" )) {
			insertMysrchSharePtc( arg.albumId, arg.party, arg.tgtGuid );
			ggMs.insertMysrchLog( arg.albumId, arg.getLoginNo(), "ptc_add", arg.tgtGuid );
		}
		else if (SU.equals( arg.albumMode, "FOLDER" )) {
			insertMyfoldSharePtc( arg.albumId, arg.party, arg.tgtGuid );
			ggMf.insertMyfoldLog( arg.albumId, arg.getLoginNo(), "ptc_add", "" );
		}
		
		return evRslt;
	}
	
	private void insertMysrchSharePtc( String mysrchId, String party, String guid ) {
		
		JvTrMysrchPtcDto dto = new JvTrMysrchPtcDto();
		dto.setMysrchId( mysrchId );
		dto.setParty( party );
		dto.setGuid( guid );
		dto.setOwnerFlg( 0 );
		dto.setCndEditFlg( 0 );
		
		JvTrMysrchPtcDao dao = new JvTrMysrchPtcDao( daoLoginNo );
		dao.insert( dto );
	}
	
	private void insertMyfoldSharePtc( String myfoldId, String party, String guid ) {
		
		JvTrMyfoldPtcDto dto = new JvTrMyfoldPtcDto();
		dto.setMyfoldId( myfoldId );
		dto.setParty( party );
		dto.setGuid( guid );
		dto.setOwnerFlg( 0 );
		dto.setTalEditFlg( 0 );
		
		JvTrMyfoldPtcDao dao = new JvTrMyfoldPtcDao( daoLoginNo );
		dao.insert( dto );
	}
	
}
