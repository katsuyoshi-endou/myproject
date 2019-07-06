package jp.co.hisas.career.app.talent.deliver;

import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.api.myfolder.MyFolderEvArg;
import jp.co.hisas.career.app.talent.api.myfolder.MyFolderEvHdlr;
import jp.co.hisas.career.app.talent.api.myfolder.MyFolderEvRslt;
import jp.co.hisas.career.app.talent.event.FetchTalentsEvArg;
import jp.co.hisas.career.app.talent.event.FetchTalentsEvHdlr;
import jp.co.hisas.career.app.talent.event.FolderTalentsEvArg;
import jp.co.hisas.career.app.talent.event.FolderTalentsEvHdlr;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.Tray;

public class MyFolderDeliver {
	
	public static List<Map<String, String>> getPickupFolders( Tray tray ) throws CareerException {
		MyFolderEvArg arg = new MyFolderEvArg( tray.loginNo );
		arg.sharp = "GET_LIST";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		MyFolderEvRslt result = MyFolderEvHdlr.exec( arg );
		return result.pickupFolders;
	}
	
	public static void addTalents( Tray tray, String[] targetList ) throws CareerException {
		FolderTalentsEvArg arg = new FolderTalentsEvArg( tray.loginNo );
		arg.sharp = "ADD";
		arg.sessionId = tray.session.getId();
		arg.myfoldId = AU.getRequestValue( tray.request, JvSessionKey.MY_FOLDER_ID );
		arg.targets = targetList;
		FolderTalentsEvHdlr.exec( arg );
	}
	
	public static void removeTalents( Tray tray, String[] targets ) throws CareerException {
		FolderTalentsEvArg arg = new FolderTalentsEvArg( tray.loginNo );
		arg.sharp = "REMOVE";
		arg.sessionId = tray.session.getId();
		arg.myfoldId = tray.getSessionAttr( JvSessionKey.MY_FOLDER_ID );
		arg.targets = targets;
		FolderTalentsEvHdlr.exec( arg );
	}
	
	public static void loadFromMyFolder( Tray tray, String myfoldId ) throws CareerException {
		FetchTalentsEvArg arg = new FetchTalentsEvArg( tray.loginNo );
		arg.sharp = "RENEW";
		arg.sessionId = tray.session.getId();
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.myfoldId = myfoldId;
		FetchTalentsEvHdlr.exec( arg );
	}
	
	public static boolean canTalEdit( Tray tray ) throws CareerException {
		MyFolderEvArg arg = new MyFolderEvArg( tray.loginNo );
		arg.sharp = "CAN_TAL_EDIT";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		arg.myfoldId = tray.getSessionAttr( JvSessionKey.MY_FOLDER_ID );
		MyFolderEvRslt result = MyFolderEvHdlr.exec( arg );
		return result.canTalEdit;
	}
	
}
