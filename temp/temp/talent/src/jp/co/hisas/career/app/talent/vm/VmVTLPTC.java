package jp.co.hisas.career.app.talent.vm;

import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.deliver.MySearchDeliver;
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchDto;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.ViewModel;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.Tray;

public class VmVTLPTC extends ViewModel {
	
	public static String VMID = VmVTLPTC.class.getSimpleName();
	public String albumMode;
	public String albumId;
	public JvTrMysrchDto mySearch;
	public JvTrMyfoldDto myFolder;
	
	public VmVTLPTC(Tray tray) throws CareerException {
		super( tray );
		this.prepareLabels();
		
		this.albumMode = AU.getRequestValue( tray.request, "amd" );
		this.albumId   = AU.getRequestValue( tray.request, "aid" );
		
		this.mySearch = MySearchDeliver.getCurrentMySearch( tray );
		this.myFolder = MySearchDeliver.getMyFolder( tray );
	}
	
	private void prepareLabels() {
		List<String> l = new ArrayList<String>();
		l.add( "LTLAPP_SHARE_CHIP" );
		l.add( "LTLPTC_BTN_BACK" );
		l.add( "LTLPTC_OWNER" );
		l.add( "LTLPTC_LIST_KENMU" );
		l.add( "LTLPTC_LIST_DEPT" );
		l.add( "LTLPTC_LIST_YKSK" );
		l.add( "LTLPTC_OWNER_BTN_GIVE" );
		l.add( "LTLPTC_OWNER_BTN_CANCEL" );
		l.add( "LTLPTC_PTC" );
		l.add( "LTLPTC_PTC_BTN_EDIT" );
		l.add( "LTLPTC_PTC_BTN_CANCEL" );
		l.add( "LTLPTC_PTC_BTN_ADD" );
		l.add( "LTLPTC_PTC_BTN_OK" );
		l.add( "LTLPTC_PTC_BTN_GIVE" );
		l.add( "LTLPTC_PTC_EDITABLE" );
		l.add( "LTLPTC_PTC_BTN_DEL" );
		l.add( "LTLPTC_PTC_BTN_DEL_CANCEL" );
		l.add( "LTLPTC_PTC_BTN_LEAVE" );
		l.add( "LTLPTC_FIND_TITLE" );
		l.add( "LTLPTC_FIND_NAME" );
		l.add( "LTLPTC_FIND_DEPT" );
		l.add( "LTLPTC_FIND_YKSK" );
		l.add( "LTLPTC_FIND_BTN" );
		l.add( "LTLPTC_FIND_GUIDE" );
		l.add( "LTLPTC_FIND_BTN_ADD" );
		l.add( "LTLPTC_FIND_PTC_ING" );
		l.add( "LTLPTC_MSG_LEAVE_CONFIRM" );
		registerCommonLabels( l );
	}
	
}
