package jp.co.hisas.career.app.talent.vm;

import java.util.List;

import jp.co.hisas.career.app.talent.dto.JvDfInstantSearchDto;
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchDto;
import jp.co.hisas.career.app.talent.event.MyMenuEvArg;
import jp.co.hisas.career.app.talent.event.MyMenuEvHdlr;
import jp.co.hisas.career.app.talent.event.MyMenuEvRslt;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.ViewModel;
import jp.co.hisas.career.util.Tray;

public class VmVTLHOM extends ViewModel {
	
	public static String VMID = VmVTLHOM.class.getSimpleName();
	
	public boolean hasRoles;
	public String activeState;
	public String activeSeqNo;
	public List<JvDfInstantSearchDto> instantSearchScopeList;
	public boolean canRetireSrch;
	public List<JvTrMysrchDto> mysrchList;
	public List<JvTrMyfoldDto> myfoldList;
	public List<JvTrMysrchDto> sharedMysrchList;
	public List<JvTrMyfoldDto> sharedMyfoldList;
	
	public VmVTLHOM(Tray tray) throws CareerException {
		super( tray );
		refresh( tray );
	}
	
	public void refresh( Tray tray ) throws CareerException {
		updateSrchAndFolderList( tray );
	}
	
	public static void updateVmState( Tray tray, String vmState, String vmSeqNo ) {
		VmVTLHOM vm = tray.getSessionAttr( VmVTLHOM.VMID );
		vm.activeState = vmState;
		vm.activeSeqNo = vmSeqNo;
	}
	
	private void updateSrchAndFolderList( Tray tray ) throws CareerException {
		MyMenuEvArg arg = new MyMenuEvArg( tray.loginNo );
		arg.sharp = "INIT";
		arg.party = tray.party;
		arg.guid = tray.loginNo;
		MyMenuEvRslt rslt = MyMenuEvHdlr.exec( arg );
		
		this.hasRoles = rslt.hasRoles;
		this.mysrchList = rslt.mysrchList;
		this.myfoldList = rslt.myfoldList;
		this.sharedMysrchList = rslt.sharedMysrchList;
		this.sharedMyfoldList = rslt.sharedMyfoldList;
		this.instantSearchScopeList = rslt.instantSearchScopeList;
		this.canRetireSrch = rslt.canRetireSrch;
	}
	
}
