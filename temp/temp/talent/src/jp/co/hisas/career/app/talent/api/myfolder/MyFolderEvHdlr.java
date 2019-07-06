package jp.co.hisas.career.app.talent.api.myfolder;

import jp.co.hisas.career.app.talent.dto.JvTrMyfoldPtcDto;
import jp.co.hisas.career.app.talent.garage.MyFoldGarage;
import jp.co.hisas.career.app.talent.garage.SharePtcGarage;
import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class MyFolderEvHdlr extends AbstractEventHandler<MyFolderEvArg, MyFolderEvRslt> {
	
	public static MyFolderEvRslt exec( MyFolderEvArg arg ) throws CareerException {
		MyFolderEvHdlr handler = new MyFolderEvHdlr();
		return handler.call( arg );
	}
	
	public MyFolderEvRslt call( MyFolderEvArg arg ) throws CareerException {
		return this.callEjb( arg );
	}
	
	protected MyFolderEvRslt execute( MyFolderEvArg arg ) throws CareerException {
		Log.method( arg.getLoginNo(), "IN", "" );
		arg.validateArg();
		String daoLoginNo = arg.getLoginNo();
		MyFolderEvRslt result = new MyFolderEvRslt();
		try {
			
			if (SU.equals( "GET", arg.sharp )) {
				
				MyFoldGarage ggMf = new MyFoldGarage( daoLoginNo );
				result.myFolder = ggMf.getMyfold( arg.myfoldId );
			}
			else if (SU.equals( "SAVE", arg.sharp )) {
				
				MyFolderLogicSave logic = new MyFolderLogicSave( daoLoginNo );
				result = logic.main( arg );
			}
			else if (SU.equals( "DELETE", arg.sharp )) {
				
				MyFolderLogicDelete logic = new MyFolderLogicDelete( daoLoginNo );
				result = logic.main( arg );
			}
			else if (SU.equals( "GET_LIST", arg.sharp )) {
				
				MyFoldGarage ggMf = new MyFoldGarage( daoLoginNo );
				result.pickupFolders = ggMf.getMyFolderListForPickup( arg.party, arg.guid );
			}
			else if (SU.equals( "CAN_TAL_EDIT", arg.sharp )) {
				
				SharePtcGarage ggSp = new SharePtcGarage( daoLoginNo );
				JvTrMyfoldPtcDto dto = ggSp.getMyFolderPtc( arg.myfoldId, arg.party, arg.guid );
				result.canTalEdit = (dto != null) ? SU.judge( dto.getTalEditFlg() ) : false;
			}
			
			return result;
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		} finally {
			Log.method( arg.getLoginNo(), "OUT", "" );
		}
	}
	
}
