package jp.co.hisas.career.app.talent.vm;

import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.ViewModel;
import jp.co.hisas.career.util.Tray;

public class VmVTLSDP extends ViewModel {
	
	public static String VMID = VmVTLSDP.class.getSimpleName();
	
	public VmVTLSDP(Tray tray) throws CareerException {
		super( tray );
	}
	
}
