package jp.co.hisas.career.app.talent.bean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

import jp.co.hisas.career.app.talent.dto.JvProfTabSectFilterDto;
import jp.co.hisas.career.app.talent.dto.JvTabJsDto;
import jp.co.hisas.career.app.talent.dto.extra.JvProfTabSectionLayoutDto;

public class JvProfileBean implements Serializable {
	
	/** 顔写真 */
	public PersonalPictureBean jvPictureBean = null;
	
	/** ロールID */
	public String roleId = null;
	
	/** タブリスト */
	public List<String> tabList = null;
	
	/** セクションリスト */
	public List<JvProfTabSectFilterDto> sectList;
	
	/** 項目フィルタ */
	public KomokuFilterBean komokuFilter = null;
	
	/** PZ Box Value Map <PZID, PZVAL> */
	public Map<String, String> pzBoxValMap = new HashMap<String, String>();
	
	/** PZ List Value Map <PZID, <ROWNO, PZVAL>> */
	public Map<String, Map<Integer, String>> pzListValMap = new HashMap<String, Map<Integer, String>>();
	
	/** 会社コード */
	private String companyCode;
	
	/** Tab Layout Map */
	public Map<String, List<JvProfTabSectionLayoutDto>> jvTabLayoutMap = null;
	
	/** タブスクリプトリスト */
	public List<JvTabJsDto> jvTabJsList = null;
	
	/**
	 * コンストラクタ
	 */
	public JvProfileBean() {
	}
	
	/**
	 * 項目フィルタを取得します。
	 * 
	 * @return 項目フィルタ
	 */
	public KomokuFilterBean getKomokuFilter() {
		return komokuFilter;
	}
	
	/**
	 * 項目フィルタを設定します。
	 * 
	 * @param komokuFilter 項目フィルタ
	 */
	public void setKomokuFilter( KomokuFilterBean komokuFilter ) {
		this.komokuFilter = komokuFilter;
	}
	
	/**
	 * 項目フィルタ済みの値（C）を取得する。
	 * 
	 * @param komokuId
	 * @return
	 */
	public String getCValue( String komokuId ) {
		String value = getNoFilterCValue( komokuId );
		if (this.komokuFilter != null) {
			value = this.komokuFilter.getFilterValue( komokuId, value );
		} else {
			value = null;
		}
		return value;
	}
	
	/**
	 * 項目フィルタなしの値（C）を取得する。
	 * 
	 * @param komokuId
	 * @return
	 */
	public String getNoFilterCValue( String komokuId ) {
		String value = "";
		if (this.pzBoxValMap.containsKey( komokuId )) {
			value = this.pzBoxValMap.get( komokuId );
		}
		return value;
	}
	
	/**
	 * 値（TC）の最大行番号を取得する
	 * 
	 * @param komokuIdArr
	 * @return
	 */
	public int getMaxNumberTcValue( String[] komokuIdArr ) {
		int maxNumber = 0;
		for (String komokuId : komokuIdArr) {
			if (this.pzListValMap.containsKey( komokuId )) {
				Map<Integer, String> tcMap = this.pzListValMap.get( komokuId );
				
				Iterator<Integer> tcMapIte = tcMap.keySet().iterator();
				while (tcMapIte.hasNext()) {
					Integer rowNo = tcMapIte.next();
					if (rowNo.intValue() > maxNumber) {
						maxNumber = rowNo.intValue();
					}
				}
			}
		}
		return maxNumber;
	}
	
	/**
	 * 値（TC）の行番号が存在するか取得する
	 * 
	 * @param komokuIdArr
	 * @param index
	 * @return
	 */
	public boolean isExistsNumber( String[] komokuIdArr, int index ) {
		for (String komokuId : komokuIdArr) {
			if (this.pzListValMap.containsKey( komokuId )) {
				Map<Integer, String> tcMap = this.pzListValMap.get( komokuId );
				if (tcMap.containsKey( new Integer( index ) )) {
					return true;
				}
			}
		}
		return false;
	}
	
	/**
	 * 項目フィルタ済みの値（TC）を取得する。
	 * 
	 * @param komokuId
	 * @param index
	 * @return
	 */
	public String getTcValue( String komokuId, int index ) {
		String value = getNoFilterTcValue( komokuId, index );
		if (this.komokuFilter != null) {
			value = this.komokuFilter.getFilterValue( komokuId, value );
		}
		return value;
	}
	
	/**
	 * 項目フィルタなしの値（TC）を取得する。
	 * 
	 * @param komokuId
	 * @param index
	 * @return
	 */
	public String getNoFilterTcValue( String komokuId, int index ) {
		String value = "";
		if (this.pzListValMap.containsKey( komokuId )) {
			Map<Integer, String> tcMap = this.pzListValMap.get( komokuId );
			Integer rowNo = new Integer( index );
			if (tcMap.containsKey( rowNo )) {
				value = tcMap.get( rowNo );
			}
		}
		return value;
	}
	
	/**
	 * 個人属性を設定する（単一項目）
	 * 
	 * @param key
	 * @param value
	 */
	public void setPersonZokusei( String key, String value ) {
		this.pzBoxValMap.put( key, value );
	}
	
	/**
	 * 個人属性を設定する（複数項目）
	 * 
	 * @param key
	 * @param index
	 * @param value
	 */
	public void setPersonZokusei( String key, Integer rowNo, String value ) {
		Map<Integer, String> tcMap = null;
		if (this.pzListValMap.containsKey( key )) {
			tcMap = this.pzListValMap.get( key );
		} else {
			tcMap = new HashMap<Integer, String>();
		}
		tcMap.put( rowNo, value );
		this.pzListValMap.put( key, tcMap );
	}
	
	/**
	 * 会社コードを取得します。
	 * 
	 * @return 会社コード
	 */
	public String getCompanyCode() {
		return companyCode;
	}
	
	/**
	 * 会社コードを設定します。
	 * 
	 * @param companyCode 会社コード
	 */
	public void setCompanyCode( String companyCode ) {
		this.companyCode = companyCode;
	}

	/**
	 * Shelfタイプの項目ID配列を渡してJSON形式で返します。
	 */
	public String getShelfJsonByPzIds( String[] pzIds ) {
		// RowList - <PzId, PzVal>
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		int max = this.getMaxNumberTcValue( pzIds );
		for (int i=0; i<=max; i++) {
			if (this.isExistsNumber(pzIds, i)) {
				Map<String, String> map = new HashMap<String, String>();
				for (int j=0; j<pzIds.length; j++) {
					String pzV = this.getTcValue(pzIds[j], i);
					map.put( pzIds[j], pzV );
				}
				list.add( map );
			}
		}
		Gson gson = new Gson();
		return gson.toJson( list );
	}
}
