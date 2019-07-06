package jp.co.hisas.career.app.talent.bean;

import java.io.Serializable;
import java.util.List;


public class DeptTreeBean implements Serializable {

	/**
	 *
	 */
	private static final long	serialVersionUID	= 1L;

	/** 所属コード */
	public String deptCd = null;

	/** 所属名 */
	public String deptName = null;

	/** 会社リスト */
	public List<DeptTreeBean> companyList = null;

	/** 所属ノードリスト */
	public List<String> groupNodeList = null;

	/** 所属ノードHIDDENリスト */
	public List<String> groupNodeHiddenList = null;

	/** 選択された会社コード */
	public String companyCode = null;

	/**
	 * コンストラクタ
	 */
	public DeptTreeBean() {
	}

	public DeptTreeBean(String sectionID, String sectionName) {
		this.deptCd = sectionID;
		this.deptName = sectionName;
	}

	/**
	 * 所属コードを取得します。
	 *
	 * @return 所属コード
	 */
	public String getDeptCd() {
		return deptCd;
	}

	/**
	 * 所属コードを設定します。
	 *
	 * @param deptCd 所属コード
	 */
	public void setDeptCd( String deptCd ) {
		this.deptCd = deptCd;
	}

	/**
	 * 所属名を取得します。
	 *
	 * @return 所属名
	 */
	public String getDeptName() {
		return deptName;
	}

	/**
	 * 所属名を設定します。
	 *
	 * @param deptName 所属名
	 */
	public void setDeptName( String deptName ) {
		this.deptName = deptName;
	}

	/**
	 * 会社リストを取得します。
	 *
	 * @return 会社リスト
	 */
	public List<DeptTreeBean> getCompanyList() {
		return companyList;
	}

	/**
	 * 会社リストを設定します。
	 *
	 * @param companyList 会社リスト
	 */
	public void setCompanyList( List<DeptTreeBean> companyList ) {
		this.companyList = companyList;
	}

	/**
	 * 所属ノードリストを取得します。
	 *
	 * @return 所属ノードリスト
	 */
	public List<String> getGroupNodeList() {
		return groupNodeList;
	}

	/**
	 * 所属ノードリストを設定します。
	 *
	 * @param groupNodeList 所属ノードリスト
	 */
	public void setGroupNodeList( List<String> groupNodeList ) {
		this.groupNodeList = groupNodeList;
	}

	   /**
	 * 所属ノードHIDDENリストを取得します。
	 *
	 * @return 所属ノードHIDDENリスト
	 */
	public List<String> getGroupNodeHiddenList() {
		return groupNodeHiddenList;
	}

	/**
	 * 所属ノードHIDDENリストを設定します。
	 *
	 * @param groupNodeHiddenList 所属ノードHIDDENリスト
	 */
	public void setGroupNodeHiddenList( List<String> groupNodeHiddenList ) {
		this.groupNodeHiddenList = groupNodeHiddenList;
	}

	/**
	 * 選択された会社コードを取得します。
	 *
	 * @return 選択された会社コード
	 */
	public String getCompanyCode() {
		return companyCode;
	}

	/**
	 * 選択された会社コードを設定します。
	 *
	 * @param companyCode 選択された会社コード
	 */
	public void setCompanyCode( String companyCode ) {
		this.companyCode = companyCode;
	}

}