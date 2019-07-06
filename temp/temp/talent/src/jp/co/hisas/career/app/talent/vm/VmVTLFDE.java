package jp.co.hisas.career.app.talent.vm;

import jp.co.hisas.career.app.talent.api.myfolder.MyFolderEvArg;
import jp.co.hisas.career.app.talent.api.myfolder.MyFolderEvHdlr;
import jp.co.hisas.career.app.talent.api.myfolder.MyFolderEvRslt;
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldDto;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.ViewModel;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;

public class VmVTLFDE extends ViewModel {
	
	public static String VMID = VmVTLFDE.class.getSimpleName();
	public boolean isNew = false;
	public String myfoldId;
	public JvTrMyfoldDto myFolder;
	public boolean isShared;
	
	public VmVTLFDE(Tray tray) throws CareerException {
		super( tray );
		
		this.myfoldId = tray.getSessionAttr( JvSessionKey.MY_FOLDER_ID );
		
		if (SU.equals( tray.state, "NEW" )) {
			resetSessionState( tray );
			this.isNew = true;
			// Clear MyfolderId on session for SAVE
			tray.session.setAttribute( JvSessionKey.MY_FOLDER_ID, null );
			
			JvTrMyfoldDto dto = new JvTrMyfoldDto();
			dto.setMyfoldNm( "" );
			this.myFolder = dto;
		}
		else if (SU.equals( tray.state, "EDIT" )) {
			MyFolderEvArg arg = new MyFolderEvArg( tray.loginNo );
			arg.sharp = "GET";
			arg.party = tray.party;
			arg.guid = tray.loginNo;
			arg.myfoldId = this.myfoldId;
			MyFolderEvRslt result = MyFolderEvHdlr.exec( arg );
			this.myFolder = result.myFolder;
		}
		
		this.isShared = judgeIsShared( tray );
	}
	
	private void resetSessionState( Tray tray ) {
		tray.session.removeAttribute( JvSessionKey.MY_SEARCH_ID );
		tray.session.removeAttribute( JvSessionKey.MY_FOLDER_ID );
		tray.session.removeAttribute( JvSessionKey.VTLSCE_IS_SHARED );
		tray.session.removeAttribute( JvSessionKey.VTLFDE_IS_SHARED );
	}
	
	private boolean judgeIsShared( Tray tray ) {
		boolean result = false;
		String sesParam = tray.getSessionAttr( JvSessionKey.VTLFDE_IS_SHARED );
		String reqParam = AU.getRequestValue( tray.request, "isshared" );
		if (SU.isNotBlank( reqParam )) {
			result = SU.judge( reqParam );
			tray.session.setAttribute( JvSessionKey.VTLFDE_IS_SHARED, result ? "true" : "false" );
		}
		else if (SU.isNotBlank( sesParam )) {
			result = SU.judge( sesParam );
		}
		else {
			result = SU.judge( this.myFolder.getSharedFlg() + "" );
		}
		return result;
	}
	
}
