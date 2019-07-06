package jp.co.hisas.career.app.talent.api.mysearch;

import jp.co.hisas.career.app.talent.dto.JvTrMysrchPtcDto;
import jp.co.hisas.career.app.talent.garage.LegacySrchCndGarage;
import jp.co.hisas.career.app.talent.garage.MySrchGarage;
import jp.co.hisas.career.app.talent.garage.SharePtcGarage;
import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class MySearchEvHdlr extends AbstractEventHandler<MySearchEvArg, MySearchEvRslt> {
	
	public static MySearchEvRslt exec( MySearchEvArg arg ) throws CareerException {
		MySearchEvHdlr handler = new MySearchEvHdlr();
		return handler.call( arg );
	}
	
	public MySearchEvRslt call( MySearchEvArg arg ) throws CareerException {
		return this.callEjb( arg );
	}
	
	protected MySearchEvRslt execute( MySearchEvArg arg ) throws CareerException {
		Log.method( arg.getLoginNo(), "IN", "" );
		arg.validateArg();
		String daoLoginNo = arg.getLoginNo();
		MySearchEvRslt result = new MySearchEvRslt();
		try {
			
			if (SU.equals( "SEARCH", arg.sharp )) {
				
				MySearchLogicSearch logic = new MySearchLogicSearch( daoLoginNo );
				result = logic.main( arg );
			}
			else if (SU.equals( "GET_BY_ID", arg.sharp )) {
				
				MySrchGarage ggMs = new MySrchGarage( daoLoginNo );
				result.mySearch = ggMs.getJvTrMysrch( arg.mysrchId );
			}
			else if (SU.equals( "SAVE", arg.sharp )) {
				
				MySearchLogicSave logic = new MySearchLogicSave( daoLoginNo );
				result = logic.main( arg );
			}
			else if (SU.equals( "DELETE", arg.sharp )) {
				
				MySearchLogicDelete logic = new MySearchLogicDelete( daoLoginNo );
				result = logic.main( arg );
			}
			else if (SU.equals( "GET_DEF", arg.sharp )) {
				
				LegacySrchCndGarage ggLc = new LegacySrchCndGarage( daoLoginNo );
				result.cndLgcDef = ggLc.getSrchCndLgcDef( arg.party, arg.guid, arg.isShared );
			}
			else if (SU.equals( "GET_CND", arg.sharp )) {
				
				MySearchLogicGetCond logic = new MySearchLogicGetCond( daoLoginNo );
				result = logic.main( arg );
			}
			else if (SU.equals( "CAN_CND_EDIT", arg.sharp )) {
				
				SharePtcGarage ggSp = new SharePtcGarage( daoLoginNo );
				JvTrMysrchPtcDto dto = ggSp.getMySearchPtc( arg.mysrchId, arg.party, arg.guid );
				result.canCndEdit = (dto != null) ? SU.judge( dto.getCndEditFlg() ) : false;
			}
			
			
			return result;
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		} finally {
			Log.method( arg.getLoginNo(), "OUT", "" );
		}
	}
	
}
