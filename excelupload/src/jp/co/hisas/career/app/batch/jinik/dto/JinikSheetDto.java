package jp.co.hisas.career.app.batch.jinik.dto;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class JinikSheetDto implements Serializable {
	
	/**
	 * 運用コード
	 */
	private String operationCd;
	
	/**
	 * シートID
	 */
	private String sheetId;

	/**
	 * シートステータス
	 */
	private String sheetStatus;

	/**
	 * 所有者GUID
	 */
	private String ownGuid;
	
	/**
	 * 所有者氏名
	 */
	private String ownPersonName;
	
	/**
	 * 所有者会社コード
	 */
	private String ownCmpaCd;
	
	/**
	 * 所有者所属名称
	 */
	private String ownDeptFullName;
	
	/**
	 * 回答データ
	 */
	private Map<String, String> fillDataMap;

	/**
	 * 運用コードを返す
	 * 
	 * @return 運用コード
	 */
	public String getOperationCd() {
		return operationCd;
	}

	/**
	 * 運用コードを設定する
	 * 
	 * @param operationCd 運用コード
	 */
	public void setOperationCd( String operationCd ) {
		this.operationCd = operationCd;
	}

	/**
	 * シートIDを返す
	 * 
	 * @return シートID
	 */
	public String getSheetId() {
		return sheetId;
	}

	/**
	 * シートIDを設定する
	 * 
	 * @param sheetId シートID
	 */
	public void setSheetId( String sheetId ) {
		this.sheetId = sheetId;
	}

	/**
	 * シートステータスを返す
	 * 
	 * @return シートステータス
	 */
	public String getSheetStatus() {
		return sheetStatus;
	}

	/**
	 * シートステータスを設定する
	 * 
	 * @param sheetStatus シートステータス
	 */
	public void setSheetStatus( String sheetStatus ) {
		this.sheetStatus = sheetStatus;
	}

	/**
	 * 所有者GUIDを返す
	 * 
	 * @return 所有者GUID
	 */
	public String getOwnGuid() {
		return ownGuid;
	}

	/**
	 * 所有者GUIDを設定する
	 * 
	 * @param ownGuid 所有者GUID
	 */
	public void setOwnGuid( String ownGuid ) {
		this.ownGuid = ownGuid;
	}

	/**
	 * 所有者氏名を返す
	 * 
	 * @return 所有者氏名
	 */
	public String getOwnPersonName() {
		return ownPersonName;
	}

	/**
	 * 所有者氏名を設定する
	 * 
	 * @param ownPersonName 所有者氏名
	 */
	public void setOwnPersonName( String ownPersonName ) {
		this.ownPersonName = ownPersonName;
	}

	/**
	 * 所有者会社コードを返す
	 * 
	 * @return 所有者会社コード
	 */
	public String getOwnCmpaCd() {
		return ownCmpaCd;
	}

	/**
	 * 所有者会社コードを設定する
	 * 
	 * @param ownCmpaCd 所有者会社コード
	 */
	public void setOwnCmpaCd( String ownCmpaCd ) {
		this.ownCmpaCd = ownCmpaCd;
	}

	/**
	 * 所有者所属名称を返す
	 * 
	 * @return 所有者所属名称
	 */
	public String getOwnDeptFullName() {
		return ownDeptFullName;
	}

	/**
	 * 所有者所属名称を設定する
	 * 
	 * @param ownDeptFullName 所有者所属名称
	 */
	public void setOwnDeptFullName( String ownDeptFullName ) {
		this.ownDeptFullName = ownDeptFullName;
	}

	/**
	 * 回答データを返す
	 * 
	 * @return 回答データ
	 */
	public Map<String, String> getFillDataMap() {
		return fillDataMap;
	}

	/**
	 * 回答データを設定する
	 * 
	 * @param fillDataMap 回答データ
	 */
	public void setFillDataMap( Map<String, String> fillDataMap ) {
		this.fillDataMap = fillDataMap;
	}

	public JinikSheetDto() {
		fillDataMap = new HashMap<String, String>();
	}
	
	/**
	 * 回答データを追加する
	 * 
	 * @param key 回答ID
	 * @param value 回答データ
	 */
	public void putFillData( String key, String value ) {
		this.fillDataMap.put( key, value );
	}
	
}
