package jp.co.hisas.career.app.talent.bean;

import java.io.Serializable;
import java.sql.Connection;
import java.util.HashMap;
import java.util.List;

import jp.co.hisas.career.app.talent.dao.KomokuFilterDao;
import jp.co.hisas.career.app.talent.dto.KomokuFilterDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.log.Log;
import jp.co.hisas.career.util.property.CommonLabel;

/**
 * 項目フィルタを設定する
 */
public class KomokuFilterBean implements Serializable {

    /** 表示モード：visible */
    private static final String VISIBLE = "visible";

    /** 表示モード：hyphen */
    private static final String HYPHEN = "hyphen";
    
    /** ラベル：HYPHEN */
    private static final String LABEL_HYPHEN = "HYPHEN";
    
    /** 会社コード */
    private String companyCode;
    
    /** 言語No */
    private int langNo = 1;
    
    /** 項目フィルタ */
    private HashMap<String, String> komokuFilterMap;
    
    /**
     * コンストラクタ
     * @param komokuFilterList
     */
    public KomokuFilterBean( String companyCode, String roleId ) {
        
        List<KomokuFilterDto> komokuFilterList = null;
        
        Connection conn = null;
        try {
            conn = PZZ040_SQLUtility.getConnection("");
            KomokuFilterDao dao = new KomokuFilterDao(conn);
            komokuFilterList = dao.selectCompanyAndRole(companyCode, roleId);
        } catch ( final Exception e ) {
            Log.error( "", e );
        } finally {
            PZZ040_SQLUtility.close(conn);
        }
        
        // 会社コードの設定
        this.companyCode = companyCode;
        // 項目フィルタの設定
        this.komokuFilterMap = new HashMap<String, String>();
        for (KomokuFilterDto komokuFilterDto : komokuFilterList) {
            this.komokuFilterMap.put(komokuFilterDto.getKomokuId(), komokuFilterDto.getDisplayMode());
        }
    }
    
    /**
     * コンストラクタ（言語Noを指定して項目フィルタを生成）
     * 
     * @param 会社コード
     * @param ロールID
     * @param 言語No
     */
    public KomokuFilterBean( String companyCode, String roleId, int langNo ) {
        
        List<KomokuFilterDto> komokuFilterList = null;
        
        Connection conn = null;
        try {
            conn = PZZ040_SQLUtility.getConnection("");
            KomokuFilterDao dao = new KomokuFilterDao(conn);
            komokuFilterList = dao.selectCompanyAndRole(companyCode, roleId);
        } catch ( final Exception e ) {
            Log.error( "", e );
        } finally {
            PZZ040_SQLUtility.close(conn);
        }
        
        // 会社コードの設定
        this.companyCode = companyCode;
        // 言語Noの設定
        this.langNo = langNo;
        // 項目フィルタの設定
        this.komokuFilterMap = new HashMap<String, String>();
        for (KomokuFilterDto komokuFilterDto : komokuFilterList) {
            this.komokuFilterMap.put(komokuFilterDto.getKomokuId(), komokuFilterDto.getDisplayMode());
        }
    }
    
    /**
     * フィルタされた値を取得する
     * @param komokuId 項目ID
     * @return フィルタされた値
     */
    public String getFilterValue (String komokuId, String value) {
        
        if (this.komokuFilterMap.containsKey(komokuId)) {
            String displayMode = this.komokuFilterMap.get(komokuId);
            if (VISIBLE.equals(displayMode)) {
                if (value == null || "".equals(value)) {
                    value = "";
                }
                return value;
            }
            if (HYPHEN.equals(displayMode)) {
                return CommonLabel.getLabel(this.companyCode, LABEL_HYPHEN, this.langNo);
            }
        }
        return null;
    }
    
    /**
     * フィルタ項目がVisibleであるかを取得する
     * @param komokuId 項目ID
     * @return 表示可否
     */
    public boolean isVisible (String komokuId) {
        if (this.komokuFilterMap.containsKey(komokuId)) {
            String displayMode = this.komokuFilterMap.get(komokuId);
            if (VISIBLE.equals(displayMode)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * フィルタ項目が表示対象であるかを取得する
     * @param komokuId 項目ID
     * @return 表示可否
     */
    public boolean isDisplay (String komokuId) {
        if (this.komokuFilterMap.containsKey(komokuId)) {
            String displayMode = this.komokuFilterMap.get(komokuId);
            if (VISIBLE.equals(displayMode)) {
                return true;
            }
            if (HYPHEN.equals(displayMode)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * フィルタ項目が検索対象であるかを取得する
     * @param komokuId 項目ID
     * @return 検索可否
     */
    public boolean isSearch (String komokuId) {
        if (this.komokuFilterMap.containsKey(komokuId)) {
            String displayMode = this.komokuFilterMap.get(komokuId);
            if (VISIBLE.equals(displayMode)) {
                return true;
            }
            if (HYPHEN.equals(displayMode)) {
                return false;
            }
        }
        return false;
    }
}
