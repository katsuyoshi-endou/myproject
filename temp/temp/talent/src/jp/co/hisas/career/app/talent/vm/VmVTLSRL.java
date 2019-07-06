package jp.co.hisas.career.app.talent.vm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.bean.JvSrchRsltBean;
import jp.co.hisas.career.app.talent.deliver.InstantSearchDeliver;
import jp.co.hisas.career.app.talent.deliver.MyFolderDeliver;
import jp.co.hisas.career.app.talent.deliver.MySearchDeliver;
import jp.co.hisas.career.app.talent.dto.JvSrchRsltListDto;
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchDto;
import jp.co.hisas.career.app.talent.dto.extra.JvWkInstantHitExDto;
import jp.co.hisas.career.app.talent.event.ResultListEvRslt;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.ViewModel;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;

public class VmVTLSRL extends ViewModel {
	
	public static String VMID = VmVTLSRL.class.getSimpleName();
	public int recordCnt;
	public String crrMode;
	public boolean isCardMode = false;
	public String listMode;
	public int colUpto;
	public String headerLabel;
	public JvTrMysrchDto mySearch;
	public JvTrMyfoldDto myFolder;
	public boolean canSrchEdit;
	public boolean canFoldEdit;
	public boolean canCsvDownload;
	public Map<String, List<JvWkInstantHitExDto>> instantHitMap;
	public String[] queryWords;
	public List<String> scopeList;
	public List<Map<String, String>> pickupFolders;
	
	public VmVTLSRL(Tray tray, String mode) throws CareerException {
		super( tray );
		
		this.crrMode = mode;
		
		execEventInit( tray );
		
		if (SU.equals( mode, "INSTANT" )) {
			this.listMode = "instant";
			this.queryWords = AU.getRequestAttr( tray.request, "InstantQueryWords" );
			this.scopeList = AU.getRequestAttr( tray.request, "InstantScopeList" );
			tray.session.setAttribute( JvSessionKey.VTLSRL_LIST_MODE, this.listMode );
		}
		else {
			String listMode = tray.getSessionAttr( JvSessionKey.VTLSRL_LIST_MODE );
			listMode = SU.equals( listMode, "instant" ) ? "card" : listMode;
			listMode = SU.isNotBlank( listMode ) ? listMode : "card";
			this.listMode = listMode;
			tray.session.setAttribute( JvSessionKey.VTLSRL_LIST_MODE, this.listMode );
		}
		
		String colsPtn = SU.nvl( tray.getSessionAttr( JvSessionKey.SRCH_COLS_PTN ), "X" );
		this.colUpto = JvSrchRsltBean.getPtnColLimit( colsPtn );
		this.headerLabel = JvSrchRsltBean.getHeaderLabelTag( tray.party, colsPtn, tray.langNo );
		this.mySearch = MySearchDeliver.getCurrentMySearch( tray );
		this.myFolder = MySearchDeliver.getMyFolder( tray );
		this.canSrchEdit = MySearchDeliver.canCndEdit( tray );
		this.canFoldEdit = MyFolderDeliver.canTalEdit( tray );
		this.pickupFolders = MyFolderDeliver.getPickupFolders( tray );
	}
	
	private void execEventInit( Tray tray ) throws CareerException {
		
		ResultListEvRslt rslt = MySearchDeliver.fetchResultList( tray );
		this.recordCnt      = rslt.recordCnt;
		this.canCsvDownload = rslt.canCsvDownload;
	}
	
	public void updateOnRestore( Tray tray ) throws CareerException {
		
		execEventInit( tray );
		
		// リストモードの保持
		String val = AU.getReqSesVal( tray.request, JvSessionKey.VTLSRL_LIST_MODE );
		this.listMode = val;
		tray.session.setAttribute( JvSessionKey.VTLSRL_LIST_MODE, val );
	}
	
	public String getVal( JvSrchRsltListDto dto, int itemNo ) {
		return JvSrchRsltBean.getVal( dto,  itemNo );
	}
	
	public void loadInstantHitPzItems( Tray tray ) throws CareerException {
		
		List<JvWkInstantHitExDto> hitPzList = InstantSearchDeliver.loadInstantHitPzItems( tray );
		
		List<JvWkInstantHitExDto> list;
		Map<String, List<JvWkInstantHitExDto>> map = new HashMap<String, List<JvWkInstantHitExDto>>();
		for (JvWkInstantHitExDto dto : hitPzList) {
			String labelId = "PZNM_" + SU.upperCase( dto.getPzId() );
			dto.setPzName( AU.getCommonLabel( tray, labelId ) );
			// Key(eid): 1000E800000
			String key = dto.getEid();
			if (map.containsKey( key )) {
				list = map.get( key );
				list.add( dto );
			} else {
				list = new ArrayList<JvWkInstantHitExDto>();
				list.add( dto );
			}
			map.put( key, list );
		}
		
		this.instantHitMap = map;
	}
	
}
