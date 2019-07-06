package jp.co.hisas.career.app.talent.api.shareptc;

import java.util.Map.Entry;

import jp.co.hisas.career.app.talent.dao.JvTrMyfoldPtcDao;
import jp.co.hisas.career.app.talent.dao.JvTrMysrchPtcDao;
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldPtcDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchPtcDto;
import jp.co.hisas.career.app.talent.garage.MyFoldGarage;
import jp.co.hisas.career.app.talent.garage.MySrchGarage;
import jp.co.hisas.career.util.SU;

public class SharePtcLogicPut {
	
	private String daoLoginNo;
	private SharePtcEvRslt evRslt;
	
	public SharePtcLogicPut(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new SharePtcEvRslt();
	}
	
	protected SharePtcEvRslt main( SharePtcEvArg arg ) {
		
		MySrchGarage ggMs = new MySrchGarage( daoLoginNo );
		MyFoldGarage ggMf = new MyFoldGarage( daoLoginNo );
		
		if (SU.equals( arg.action, "edit_ptc" )) {
			if (SU.equals( arg.albumMode, "SEARCH" )) {
				for (Entry<String, String> entry : arg.editableMap.entrySet()) {
					String tgtGuid = entry.getKey(), editFlg = entry.getValue();
					updateMysrchSharePtc( arg.albumId, arg.party, tgtGuid, editFlg );
					ggMs.insertMysrchLog( arg.albumId, arg.getLoginNo(), "ptc_edit_flg", tgtGuid + "," + editFlg );
				}
				for (String tgtGuid : arg.deletedList) {
					deleteMysrchSharePtc( arg.albumId, arg.party, tgtGuid );
					ggMs.insertMysrchLog( arg.albumId, arg.getLoginNo(), "ptc_delete", tgtGuid );
				}
			}
			else if (SU.equals( arg.albumMode, "FOLDER" )) {
				for (Entry<String, String> entry : arg.editableMap.entrySet()) {
					String tgtGuid = entry.getKey(), editFlg = entry.getValue();
					updateMyfoldSharePtc( arg.albumId, arg.party, tgtGuid, editFlg );
					ggMf.insertMyfoldLog( arg.albumId, arg.getLoginNo(), "ptc_edit_flg", tgtGuid + "," + editFlg );
				}
				for (String tgtGuid : arg.deletedList) {
					deleteMyfoldSharePtc( arg.albumId, arg.party, tgtGuid );
					ggMf.insertMyfoldLog( arg.albumId, arg.getLoginNo(), "ptc_delete", tgtGuid );
				}
			}
		}
		else if (SU.equals( arg.action, "change_owner" )) {
			if (SU.equals( arg.albumMode, "SEARCH" )) {
				changeMysrchOwner( arg.albumId, arg.party, arg.prevOwner, arg.nextOwner );
				ggMs.insertMysrchLog( arg.albumId, arg.getLoginNo(), "change_owner", arg.nextOwner );
			}
			else if (SU.equals( arg.albumMode, "FOLDER" )) {
				changeMyfoldOwner( arg.albumId, arg.party, arg.prevOwner, arg.nextOwner );
				ggMf.insertMyfoldLog( arg.albumId, arg.getLoginNo(), "change_owner", arg.nextOwner );
			}
		}
		else if (SU.equals( arg.action, "leave_ptc" )) {
			if (SU.equals( arg.albumMode, "SEARCH" )) {
				deleteMysrchSharePtc( arg.albumId, arg.party, arg.getLoginNo() );
				ggMs.insertMysrchLog( arg.albumId, arg.getLoginNo(), "ptc_leave", arg.getLoginNo() );
			}
			else if (SU.equals( arg.albumMode, "FOLDER" )) {
				deleteMyfoldSharePtc( arg.albumId, arg.party, arg.getLoginNo() );
				ggMf.insertMyfoldLog( arg.albumId, arg.getLoginNo(), "ptc_leave", arg.getLoginNo() );
			}
		}
		
		return evRslt;
	}
	
	private void updateMysrchSharePtc( String mysrchId, String party, String tgtGuid, String cndEditFlg ) {
		JvTrMysrchPtcDao dao = new JvTrMysrchPtcDao( daoLoginNo );
		JvTrMysrchPtcDto dto = dao.select( mysrchId, party, tgtGuid );
		dto.setCndEditFlg( SU.toInt( cndEditFlg, 0 ) );
		dao.update( dto );
	}
	
	private void deleteMysrchSharePtc( String mysrchId, String party, String tgtGuid ) {
		JvTrMysrchPtcDao dao = new JvTrMysrchPtcDao( daoLoginNo );
		dao.delete( mysrchId, party, tgtGuid );
	}
	
	private void changeMysrchOwner( String mysrchId, String party, String prevOwner, String nextOwner ) {
		// Prev Owner
		JvTrMysrchPtcDao dao1 = new JvTrMysrchPtcDao( daoLoginNo );
		JvTrMysrchPtcDto dto1 = dao1.select( mysrchId, party, prevOwner );
		dto1.setOwnerFlg( 0 );
		dao1.update( dto1 );
		// Next Owner
		JvTrMysrchPtcDao dao2 = new JvTrMysrchPtcDao( daoLoginNo );
		JvTrMysrchPtcDto dto2 = dao2.select( mysrchId, party, nextOwner );
		dto2.setOwnerFlg( 1 );
		dto2.setCndEditFlg( 1 );
		dao2.update( dto2 );
	}
	
	private void updateMyfoldSharePtc( String myfoldId, String party, String tgtGuid, String talEditFlg ) {
		JvTrMyfoldPtcDao dao = new JvTrMyfoldPtcDao( daoLoginNo );
		JvTrMyfoldPtcDto dto = dao.select( myfoldId, party, tgtGuid );
		dto.setTalEditFlg( SU.toInt( talEditFlg, 0 ) );
		dao.update( dto );
	}
	
	private void deleteMyfoldSharePtc( String myfoldId, String party, String tgtGuid ) {
		JvTrMyfoldPtcDao dao = new JvTrMyfoldPtcDao( daoLoginNo );
		dao.delete( myfoldId, party, tgtGuid );
	}
	
	private void changeMyfoldOwner( String mysrchId, String party, String prevOwner, String nextOwner ) {
		// Prev Owner
		JvTrMyfoldPtcDao dao1 = new JvTrMyfoldPtcDao( daoLoginNo );
		JvTrMyfoldPtcDto dto1 = dao1.select( mysrchId, party, prevOwner );
		dto1.setOwnerFlg( 0 );
		dao1.update( dto1 );
		// Next Owner
		JvTrMyfoldPtcDao dao2 = new JvTrMyfoldPtcDao( daoLoginNo );
		JvTrMyfoldPtcDto dto2 = dao2.select( mysrchId, party, nextOwner );
		dto2.setOwnerFlg( 1 );
		dto2.setTalEditFlg( 1 );
		dao2.update( dto2 );
	}
	
}
