package jp.co.hisas.career.app.talent.bean;

import java.io.Serializable;
import java.util.ArrayList;

import jp.co.hisas.career.util.property.CommonParameter;

/**
 * カテゴリフィールドのBean.
 */
public class PDA_FieldCategoryBean implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 詳細条件フィールドBeanのリスト */
    private ArrayList<PDA_FieldConditionBean> pdaFieldConditionBeanList;

    /** 条件間接続句 */
    private String connectedPhrase;

    /** 検索カテゴリID */
    private String kensakuCategoryId;

    /**
     * コンストラクタ.
     */
    public PDA_FieldCategoryBean() {
        this.pdaFieldConditionBeanList = new ArrayList<PDA_FieldConditionBean>();
        // カテゴリ・詳細条件の接続条件
        String categorySelect = CommonParameter.getValue( CommonParameter.BUNRUI_BASE, "CATEGORY_SELECT" );
        String conditionSelect = CommonParameter.getValue( CommonParameter.BUNRUI_BASE, "CONDITION_SELECT" );

        // 詳細条件の接続条件が"選択"以外
        if ( !"3".equals( conditionSelect ) ) {
            // 詳細条件フィールド追加可能件数
            int conditionSize = Integer.parseInt( CommonParameter.getValue( CommonParameter.BUNRUI_BASE, "CONDITION_MAX_SIZE" ) );
            // 最大追加件数まで作成
            for ( int cnt = 0; cnt < conditionSize; cnt++ ) {
                this.pdaFieldConditionBeanList.add( new PDA_FieldConditionBean() );
            }
        } else {
            // 初期データ分作成
            this.pdaFieldConditionBeanList.add( new PDA_FieldConditionBean() );
        }

        // カテゴリの接続条件が"AND"
        if ( "1".equals( categorySelect ) ) {
            connectedPhrase = "AND";
        }
        // カテゴリの接続条件が"OR"
        else if ( "2".equals( categorySelect ) ) {
            connectedPhrase = "OR";
        }
    }

    /**
     * 条件間接続句を取得。
     * 
     * @return connectedPhrase 条件間接続句
     */
    public String getConnectedPhrase() {
        return connectedPhrase;
    }

    /**
     * 条件間接続句を設定する。
     * 
     * @param connectedPhrase 条件間接続句
     */
    public void setConnectedPhrase( String connectedPhrase ) {
        this.connectedPhrase = connectedPhrase;
    }

    /**
     * 詳細条件フィールドBeanのリストを取得。
     * 
     * @return pdaFieldConditionBeanList 詳細条件フィールドBeanのリスト
     */
    public ArrayList<PDA_FieldConditionBean> getPdaFieldConditionBeanList() {
        return pdaFieldConditionBeanList;
    }

    /**
     * 詳細条件フィールドBeanのリストを設定する。
     * 
     * @param pdaFieldConditionBeanList 詳細条件フィールドBeanのリスト
     */
    public void setPdaFieldConditionBeanList( ArrayList<PDA_FieldConditionBean> pdaFieldItemBeanList ) {
        this.pdaFieldConditionBeanList = pdaFieldItemBeanList;
    }

    /**
     * 詳細条件フィールドBeanを設定する。
     * 
     * @param pdaFieldConditionBean 詳細条件フィールドBean
     */
    public void addPdaFieldConditionBeanList( PDA_FieldConditionBean bean ) {
        this.pdaFieldConditionBeanList.add( bean );
    }

    /**
     * 検索カテゴリIDを取得。
     * 
     * @return kensakuCategoryId 検索カテゴリID
     */
    public String getKensakuCategoryId() {
        return kensakuCategoryId;
    }

    /**
     * 検索カテゴリIDを設定する。
     * 
     * @param kensakuCategoryId 検索カテゴリID
     */
    public void setKensakuCategoryId( String kensakuCategoryId ) {
        this.kensakuCategoryId = kensakuCategoryId;
    }

}
