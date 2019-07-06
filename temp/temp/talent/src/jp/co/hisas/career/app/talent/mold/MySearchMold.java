package jp.co.hisas.career.app.talent.mold;

import java.io.Serializable;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.api.mysearch.MySearchEvRslt;
import jp.co.hisas.career.app.talent.bean.LegacyKensakuDefBean;
import jp.co.hisas.career.app.talent.deliver.MySearchDeliver;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndLgcDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndMltDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndSglDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchDto;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;

public class MySearchMold implements Serializable {
	
	public static final String SESSION_KEY = "mySearchMold";
	
	/** マイサーチすべて */
	public List<JvTrMysrchDto> mysrchList = null;
	
	/** 選択したマイサーチ 連番 */
	public String mysrchId;
	
	/** 選択したマイサーチ */
	public JvTrMysrchDto mySearch = null;
	
	/** マイサーチ 単一 */
	public HashMap<String, JvTrMysrchCndSglDto> sglMap = null;
	
	/** マイサーチ 複数 */
	public HashMap<String, JvTrMysrchCndMltDto> mltMap = null;
	
	/** マイサーチ Legacy */
	public List<JvTrMysrchCndLgcDto> lgcList = null;
	
	/** マイサーチ Shelf */
	public Map<String, Map<String, String>> slfMap = null;
	
	/** 検索フォーム定義 Legacy */
	public LegacyKensakuDefBean cndLgcDef;
	
	public MySearchMold( Tray tray ) throws CareerException {
		try {
			this.mysrchId = tray.getSessionAttr( JvSessionKey.MY_SEARCH_ID );
			
			MySearchEvRslt rslt = MySearchDeliver.getMySearchCond( tray, mysrchId );
			this.mySearch  = rslt.mySearch;
			this.cndLgcDef = rslt.cndLgcDef;
			this.lgcList   = rslt.lgcList;
			this.sglMap    = rslt.sglMap;
			this.mltMap    = rslt.mltMap;
			this.slfMap    = rslt.slfMap;
			
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		}
	}
	
	public MysrchCndLgcMold getPzSearchBean( String party, String loginNo ) throws CareerException {
		MysrchCndLgcMold cndLgcMold = MysrchCndLgcMold.makePzSearchBean( party, this.lgcList );
		LegacyKensakuDefBean def = this.cndLgcDef;
		MysrchCndLgcMold.updateLgcKensakuInfo( cndLgcMold, def );
		return cndLgcMold;
	}
	
	public static Map<String, Map<String, String>> makeShelfCondMap( Tray tray ) {
		// Map<SectId, Map<PzId, Val>>
		Map<String, Map<String, String>> map = new LinkedHashMap<String, Map<String, String>>();
		Map<String, String> reqs  = AU.getRequestsWithRegex( tray.request, "^qsf--" );
		Map<String, String> kigos = AU.getRequestsWithRegex( tray.request, "^qsfk--" );
		for (Map.Entry<String, String> entry : reqs.entrySet()) {
			if (SU.isBlank( entry.getValue() )) {
				continue;
			}
			String key = entry.getKey();
			String reqKey = SU.extract( key, "^qsf--(.*?--\\w+)$" );
			String crrSectId = SU.extract( key, "^qsf--(.*?)--\\w+$" );
			String crrPzId   = SU.extract( key, "^qsf--.*?--(\\w+)$" );
			String kigo = kigos.get( "qsfk--" + reqKey );
			String val = String.format( "%s[%s]", entry.getValue(), kigo );
			if (map.containsKey( crrSectId )) {
				Map<String, String> m = map.get( crrSectId );
				m.put( crrPzId, val );
			} else {
				Map<String, String> m = new LinkedHashMap<String, String>();
				m.put( crrPzId, val );
				map.put( crrSectId, m );
			}
		}
		return map;
	}
}
