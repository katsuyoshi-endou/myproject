package jp.co.hisas.career.app.talent.event;

import java.sql.SQLException;

import jp.co.hisas.career.app.talent.garage.MyFoldGarage;
import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.exception.CareerSQLException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class FolderTalentsEvHdlr extends AbstractEventHandler<FolderTalentsEvArg, FolderTalentsEvRslt> {
	
	public static FolderTalentsEvRslt exec( FolderTalentsEvArg arg ) throws CareerException {
		FolderTalentsEvHdlr handler = new FolderTalentsEvHdlr();
		return handler.call( arg );
	}
	
	public FolderTalentsEvRslt call( FolderTalentsEvArg arg ) throws CareerException {
		return this.callEjb( arg );
	}
	
	protected FolderTalentsEvRslt execute( FolderTalentsEvArg arg ) throws CareerException {
		Log.method( arg.getLoginNo(), "IN", "" );
		arg.validateArg();
		String daoLoginNo = arg.getLoginNo();
		FolderTalentsEvRslt result = new FolderTalentsEvRslt();
		try {
			//TODO: update [JV_TR_MYFOLD] [JV_TR_MYFOLD_LOG]
			if (SU.equals( "ADD", arg.sharp )) {
				
				addTalentsIntoFolder( daoLoginNo, arg );
			}
			else if (SU.equals( "REMOVE", arg.sharp )) {
				
				removeTalentsFromFolder( daoLoginNo, arg );
			}
			
			return result;
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		} finally {
			Log.method( arg.getLoginNo(), "OUT", "" );
		}
	}
	
	private void addTalentsIntoFolder( String daoLoginNo, FolderTalentsEvArg arg ) {
		MyFoldGarage ggMf = new MyFoldGarage( daoLoginNo );
		for (String wkIdx : arg.targets) {
			try {
				ggMf.addTalent( arg.myfoldId, arg.sessionId, wkIdx );
			} catch (CareerSQLException e) {
				// Ignore already exists
			}
		}
	}
	
	private void removeTalentsFromFolder( String daoLoginNo, FolderTalentsEvArg arg ) throws SQLException {
		MyFoldGarage ggMf = new MyFoldGarage( daoLoginNo );
		for (String wkIdx : arg.targets) {
			ggMf.removeTalent( arg.myfoldId, arg.sessionId, wkIdx );
		}
	}
	
}
