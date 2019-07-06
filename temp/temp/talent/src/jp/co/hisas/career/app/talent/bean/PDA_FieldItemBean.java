package jp.co.hisas.career.app.talent.bean;

import java.io.Serializable;
import java.util.ArrayList;

import jp.co.hisas.career.util.property.CommonParameter;

/**
 * 検索条件フィールドのBean.
 */
public class PDA_FieldItemBean implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	/** カテゴリフィールドBeanのリスト */
	private ArrayList<PDA_FieldCategoryBean> pdaFieldCategoryBeanList;
	
	/** 条件間接続句 */
	private String connectedPhrase;
	
	/**
	 * コンストラクタ.
	 */
	public PDA_FieldItemBean() {
		// 検索項目・カテゴリの接続条件
		String itemSelect = CommonParameter.getValue( CommonParameter.BUNRUI_BASE, "ITEM_SELECT" );
		String categorySelect = CommonParameter.getValue( CommonParameter.BUNRUI_BASE, "CATEGORY_SELECT" );
		
		this.pdaFieldCategoryBeanList = new ArrayList<PDA_FieldCategoryBean>();
		
		// カテゴリフィールドの接続条件が"選択"以外
		if (!"3".equals( categorySelect )) {
			// カテゴリフィールド追加可能件数
			String catMaxSize = CommonParameter.getValue( CommonParameter.BUNRUI_BASE, "CATEGORY_MAX_SIZE" );
			boolean isInt = (catMaxSize == null) ? false : catMaxSize.matches( "[0-9]+" );
			int categorySize = (isInt) ? Integer.parseInt( catMaxSize ) : 0;
			// 最大追加件数まで作成
			for (int cnt = 0; cnt < categorySize; cnt++) {
				this.pdaFieldCategoryBeanList.add( new PDA_FieldCategoryBean() );
			}
		} else {
			// 初期データ分作成
			this.pdaFieldCategoryBeanList.add( new PDA_FieldCategoryBean() );
		}
		
		// 検索項目の接続条件が"AND"
		if ("1".equals( itemSelect )) {
			connectedPhrase = "AND";
		}
		// 検索項目の接続条件が"OR"
		else if ("2".equals( itemSelect )) {
			connectedPhrase = "OR";
		}
	}
	
	public String getConnectedPhrase() {
		return connectedPhrase;
	}
	
	public void setConnectedPhrase( String connectedPhrase ) {
		this.connectedPhrase = connectedPhrase;
	}
	
	public ArrayList<PDA_FieldCategoryBean> getPdaFieldCategoryBeanList() {
		return pdaFieldCategoryBeanList;
	}
	
	public void setPdaFieldCategoryBeanList( ArrayList<PDA_FieldCategoryBean> pdaFieldCategoryBeanList ) {
		this.pdaFieldCategoryBeanList = pdaFieldCategoryBeanList;
	}
	
	public void addPdaFieldCategoryBeanList( PDA_FieldCategoryBean bean ) {
		this.pdaFieldCategoryBeanList.add( bean );
	}
	
}
