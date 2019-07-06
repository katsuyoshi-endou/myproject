package jp.co.hisas.career.app.talent.bean;

import java.io.Serializable;

import jp.co.hisas.career.util.property.CommonParameter;

/**
 * 詳細条件フィールドのBean.
 */
public class PDA_FieldConditionBean implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 条件間接続句 */
    private String connectedPhrase;

    /** 検索項目ID */
    private String kensakuKomokuId;

    /** 検索対象人属性ID */
    private String personZokuseiId;

    /** 検索条件１ */
    private String searchCondition1;

    /** 検索条件１(タイプタイプ／1:ﾃｷｽﾄﾎﾞｯｸｽ、2:ﾌﾟﾙﾀﾞｳﾝ) */
    private String searchCondition1Type;

    /** 検索条件２ */
    private String searchCondition2;

    /** 検索条件２(タイプタイプ／1:ﾃｷｽﾄﾎﾞｯｸｽ、2:ﾌﾟﾙﾀﾞｳﾝ) */
    private String searchCondition2Type;

    /** 記号タイプ */
    private String kigoType;

// ADD 2011/10/15 人材ビューア t-kondo START
    /** マスタID */
    private String masterId;   
// ADD 2011/10/15 人材ビューア t-kondo END

    /**
     * コンストラクタ.
     */
    public PDA_FieldConditionBean() {
        // 詳細条件の接続条件
        String conditionSelect = CommonParameter.getValue( CommonParameter.BUNRUI_BASE, "CONDITION_SELECT" );

        // 詳細条件の接続条件が"AND"
        if ( "1".equals( conditionSelect ) ) {
            connectedPhrase = "AND";
        }
        // 詳細条件の接続条件が"OR"
        else if ( "2".equals( conditionSelect ) ) {
            connectedPhrase = "OR";
        }
    }

    /**
     * 記号タイプを取得。
     * 
     * @return kigoType 記号タイプ
     */
    public String getKigoType() {
        return kigoType;
    }

    /**
     * 記号タイプを設定する。
     * 
     * @param kigoType 記号タイプ
     */
    public void setKigoType( String kigoType ) {
        this.kigoType = kigoType;
    }

    /**
     * 検索対象人属性IDを取得。
     * 
     * @return personZokuseiId 検索対象人属性ID
     */
    public String getPersonZokuseiId() {
        return personZokuseiId;
    }

    /**
     * 検索対象人属性IDを設定する。
     * 
     * @param personZokuseiId 検索対象人属性ID
     */
    public void setPersonZokuseiId( String personZokuseiId ) {
        this.personZokuseiId = personZokuseiId;
    }

    /**
     * 検索条件１を取得。
     * 
     * @return searchCondition1 検索条件１
     */
    public String getSearchCondition1() {
        return searchCondition1;
    }

    /**
     * 検索条件１を設定する。
     * 
     * @param searchCondition1 検索条件１
     */
    public void setSearchCondition1( String searchCondition1 ) {
        this.searchCondition1 = searchCondition1;
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
     * 検索項目IDを取得。
     * 
     * @return kensakuKomokuId 検索項目ID
     */
    public String getKensakuKomokuId() {
        return kensakuKomokuId;
    }

    /**
     * 検索項目IDを設定する。
     * 
     * @param kensakuKomokuId 検索項目ID
     */
    public void setKensakuKomokuId( String kensakuKomokuId ) {
        this.kensakuKomokuId = kensakuKomokuId;
    }

    /**
     * 検索条件１(タイプタイプ／1:ﾃｷｽﾄﾎﾞｯｸｽ、2:ﾌﾟﾙﾀﾞｳﾝ)を取得。
     * 
     * @return searchCondition1Type 検索条件１(タイプタイプ／1:ﾃｷｽﾄﾎﾞｯｸｽ、2:ﾌﾟﾙﾀﾞｳﾝ)
     */
    public String getSearchCondition1Type() {
        return searchCondition1Type;
    }

    /**
     * 検索条件１(タイプタイプ／1:ﾃｷｽﾄﾎﾞｯｸｽ、2:ﾌﾟﾙﾀﾞｳﾝ)を設定する。
     * 
     * @param searchCondition1Type 検索条件１(タイプタイプ／1:ﾃｷｽﾄﾎﾞｯｸｽ、2:ﾌﾟﾙﾀﾞｳﾝ)
     */
    public void setSearchCondition1Type( String searchCondition1Type ) {
        this.searchCondition1Type = searchCondition1Type;
    }

    /**
     * 検索条件２を取得。
     * 
     * @return searchCondition2 検索条件２
     */
    public String getSearchCondition2() {
        return searchCondition2;
    }

    /**
     * 検索条件２を設定する。
     * 
     * @param searchCondition2 検索条件２
     */
    public void setSearchCondition2( String searchCondition2 ) {
        this.searchCondition2 = searchCondition2;
    }

    /**
     * 検索条件２(タイプタイプ／1:ﾃｷｽﾄﾎﾞｯｸｽ、2:ﾌﾟﾙﾀﾞｳﾝ)を取得。
     * 
     * @return searchCondition2Type 検索条件２(タイプタイプ／1:ﾃｷｽﾄﾎﾞｯｸｽ、2:ﾌﾟﾙﾀﾞｳﾝ)
     */
    public String getSearchCondition2Type() {
        return searchCondition2Type;
    }

    /**
     * 検索条件２(タイプタイプ／1:ﾃｷｽﾄﾎﾞｯｸｽ、2:ﾌﾟﾙﾀﾞｳﾝ)を設定する。
     * 
     * @param searchCondition2Type 検索条件２(タイプタイプ／1:ﾃｷｽﾄﾎﾞｯｸｽ、2:ﾌﾟﾙﾀﾞｳﾝ)
     */
    public void setSearchCondition2Type( String searchCondition2Type ) {
        this.searchCondition2Type = searchCondition2Type;
    }

// ADD 2011/10/15 人材ビューア t-kondo START
    /**
     * マスタIDを取得。
     * 
     * @return masterId マスタID
     */
    public String getMasterId() {
        return masterId;
    }

    /**
     * マスタIDを設定する。
     * 
     * @param masterId マスタID
     */
    public void setMasterId(String masterId) {
        this.masterId = masterId;
    }
// ADD 2011/10/15 人材ビューア t-kondo END

}
