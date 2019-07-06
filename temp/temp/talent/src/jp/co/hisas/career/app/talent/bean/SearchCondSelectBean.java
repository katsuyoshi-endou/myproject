package jp.co.hisas.career.app.talent.bean;

import java.io.Serializable;
import java.util.List;


public class SearchCondSelectBean implements Serializable {

	/**
	 *
	 */
	private static final long	serialVersionUID	= 1L;

	/** マスターID */
	public String masterID = null; 

	/** マスター名 */
	public String masterName = null; 

	/** 子ノード */
	public List<String> childNodeList = null;

	/** 子ノードHIDDEN */
	public List<String> childNodeHiddenList = null;

	/**
	 * コンストラクタ
	 */
	public SearchCondSelectBean() {
	}

	/**
	 * マスターIDを取得します。
	 *
	 * @return マスターID
	 */
	public String getMasterID() {
		return masterID;
	}

	/**
	 * マスターIDを設定します。
	 *
	 * @param masterID マスターID
	 */
	public void setMasterID( String masterID ) {
		this.masterID = masterID;
	}

	/**
	 * マスター名を取得します。
	 *
	 * @return マスター名
	 */
	public String getMasterName() {
		return masterName;
	}

	/**
	 * マスター名を設定します。
	 *
	 * @param masterName マスター名
	 */
	public void setMasterName( String masterName ) {
		this.masterName = masterName;
	}

	/**
	 * 子ノードを取得します。
	 *
	 * @return 子ノード
	 */
	public List<String> getChildNodeList() {
		return childNodeList;
	}

	/**
	 * 子ノードを設定します。
	 *
	 * @param childNodeList 子ノード
	 */
	public void setChildNodeList( List<String> childNodeList ) {
		this.childNodeList = childNodeList;
	}
	
	/**
	 * 子ノードHIDDENを取得します。
	 *
	 * @return 子ノードHIDDEN
	 */
	public List<String> getChildNodeHiddenList() {
		return childNodeHiddenList;
	}

	/**
	 * 子ノードHIDDENを設定します。
	 *
	 * @param childNodeHiddenList 子ノードHIDDEN
	 */
	public void setChildNodeHiddenList( List<String> childNodeHiddenList ) {
		this.childNodeHiddenList = childNodeHiddenList;
	}
}