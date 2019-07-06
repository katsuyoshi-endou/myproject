package jp.co.hisas.career.app.talent.vm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.bean.LegacyKensakuDefBean;
import jp.co.hisas.career.app.talent.deliver.MySearchDeliver;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectListtypeDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndMltDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndSglDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchDto;
import jp.co.hisas.career.app.talent.mold.MySearchMold;
import jp.co.hisas.career.app.talent.mold.MysrchCndLgcMold;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.ViewModel;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;

public class VmVTLSCE extends ViewModel {
	
	public static String VMID = VmVTLSCE.class.getSimpleName();
	
	public boolean showBackBtn = true;
	public boolean isNew = false;
	
	/** Myサーチ プライベート・シェアード */
	public boolean isShared = false;
	
	/** Myサーチ 保存情報 */
	public JvTrMysrchDto mySearch;
	public MysrchCndLgcMold cndLgcMold;
	public HashMap<String, JvTrMysrchCndSglDto> savedSglMap;
	public HashMap<String, JvTrMysrchCndMltDto> savedMltMap;
	public Map<String, Map<String, String>> savedShelfCond;
	
	/** Myサーチ 検索枠マスタ */
	public LegacyKensakuDefBean legacyKensakuDefBean;
	public Map<String, List<JvProfTabSectListtypeDto>> shelftypeMap;
	
	public VmVTLSCE(Tray tray) throws CareerException {
		super( tray );
		
		String seqno = tray.getSessionAttr( JvSessionKey.MY_SEARCH_ID );
		if (seqno == null) {
			this.showBackBtn = false;
		}
		
		if (SU.equals( tray.state, "NEW" )) {
			this.isNew = true;
			this.showBackBtn = false;
			resetSessionState( tray );
			initializeTLSCE();
		}
		else if (SU.equals( tray.state, "EDIT" )) {
			MySearchMold mySearchMold = tray.getSessionAttr( MySearchMold.SESSION_KEY );
			this.mySearch = MySearchDeliver.getCurrentMySearch( tray );
			this.savedSglMap = mySearchMold.sglMap;
			this.cndLgcMold = mySearchMold.getPzSearchBean( tray.party, tray.loginNo );
			if (this.savedSglMap == null) {
				this.savedSglMap = new HashMap<String, JvTrMysrchCndSglDto>();
			}
			this.savedMltMap = mySearchMold.mltMap;
			if (this.savedMltMap == null) {
				this.savedMltMap = new HashMap<String, JvTrMysrchCndMltDto>();
			}
			this.savedShelfCond = mySearchMold.slfMap;
		}
		else if (SU.equals( tray.state, "CLEAR" )) {
			if (seqno == null) {
				initializeTLSCE();
			}
			else {
				this.mySearch = MySearchDeliver.getCurrentMySearch( tray );
				
				this.cndLgcMold = new MysrchCndLgcMold();
				this.savedSglMap = new HashMap<String, JvTrMysrchCndSglDto>();
				this.savedMltMap = new HashMap<String, JvTrMysrchCndMltDto>();
				this.savedShelfCond = new HashMap<String, Map<String, String>>();
			}
		}
		
		this.isShared = judgeIsShared( tray );
		this.legacyKensakuDefBean = MySearchDeliver.getLegacySrchCndDef( tray, this.isShared );
		this.shelftypeMap = MySearchDeliver.getShelftypeList( tray, this.isShared );
	}
	
	private boolean judgeIsShared( Tray tray ) {
		boolean result = false;
		String sesParam = tray.getSessionAttr( JvSessionKey.VTLSCE_IS_SHARED );
		String reqParam = AU.getRequestValue( tray.request, "isshared" );
		if (SU.isNotBlank( reqParam )) {
			result = SU.judge( reqParam );
			tray.session.setAttribute( JvSessionKey.VTLSCE_IS_SHARED, result ? "true" : "false" );
		}
		else if (SU.isNotBlank( sesParam ) ) {
			result = SU.judge( sesParam );
		}
		else {
			result = SU.judge( this.mySearch.getSharedFlg() + "" );
		}
		return result;
	}
	
	private void initializeTLSCE() {
		JvTrMysrchDto mySearch = new JvTrMysrchDto();
		mySearch.setMysrchNm( "" );
		mySearch.setMysrchId( "" );
		this.mySearch = mySearch;
		this.cndLgcMold = new MysrchCndLgcMold();
	}
	
	private void resetSessionState( Tray tray ) {
		tray.session.removeAttribute( JvSessionKey.MY_SEARCH_ID );
		tray.session.removeAttribute( JvSessionKey.MY_FOLDER_ID );
		tray.session.removeAttribute( JvSessionKey.VTLSCE_IS_SHARED );
		tray.session.removeAttribute( JvSessionKey.VTLFDE_IS_SHARED );
	}
	
	private JvTrMysrchCndSglDto sglDto = new JvTrMysrchCndSglDto();
	private JvTrMysrchCndMltDto mltDto = new JvTrMysrchCndMltDto();
	
	public String getSglSearchValue( String paramId ) {
		if (savedSglMap == null) {
			return "";
		}
		return SU.ntb( ((JvTrMysrchCndSglDto)this.getMap( savedSglMap, paramId, sglDto )).getSearchValue() );
	}
	
	public String getMltSearchValue( String paramId ) {
		if (savedMltMap == null) {
			return "";
		}
		return SU.ntb( ((JvTrMysrchCndMltDto)this.getMap( savedMltMap, paramId, mltDto )).getSearchValue() );
	}
	
	public String getMltCodeValue( String paramId ) {
		if (savedMltMap == null) {
			return "";
		}
		return SU.ntb( ((JvTrMysrchCndMltDto)this.getMap( savedMltMap, paramId, mltDto )).getCodeValue() );
	}
	
	@SuppressWarnings("rawtypes")
	private Object getMap( HashMap map, String key, Object obj ) {
		if (map.get( key ) == null) {
			return obj;
		}
		else {
			return map.get( key );
		}
	}
}
