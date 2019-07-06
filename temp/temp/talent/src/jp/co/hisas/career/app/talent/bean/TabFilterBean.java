package jp.co.hisas.career.app.talent.bean;

import java.io.Serializable;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.dao.JvProfTabFilterDao;
import jp.co.hisas.career.app.talent.dto.JvProfTabFilterDto;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.log.Log;

/**
 * 項目フィルタを設定する
 */
public class TabFilterBean implements Serializable {

    /** 表示モード：ON */
    private static final String ON = "ON";

    /** 表示モード：NONE */
    private static final String NONE = "NONE";
    
    /** タブフィルタ */
    private List<String> tabFilterList;
    
    /** 表示不要タブリスト */
    private List<String> tabFilterNoneList;
    
    /**
     * コンストラクタ
     * @param komokuFilterList
     */
    public TabFilterBean( String companyCode, String roleId ) {

        List<JvProfTabFilterDto> tabFilterList = null;
        
        Connection conn = null;
        try {
            conn = PZZ040_SQLUtility.getConnection("");
            JvProfTabFilterDao dao = new JvProfTabFilterDao(conn);
            tabFilterList = dao.selectCompanyAndRole(companyCode, roleId);
        } catch ( final Exception e ) {
            Log.error( "", e );
        } finally {
            PZZ040_SQLUtility.close(conn);
        }
        
        // タブフィルタの設定
        this.tabFilterList = new ArrayList<String>();
        this.tabFilterNoneList = new ArrayList<String>();
        for (JvProfTabFilterDto tabFilterDto : tabFilterList) {
            if (ON.equals(tabFilterDto.getDisplayMode())) {
                this.tabFilterList.add(tabFilterDto.getTabId());
            }
            if (NONE.equals(tabFilterDto.getDisplayMode())) {
                this.tabFilterNoneList.add(tabFilterDto.getTabId());
            }
        }
    }
    
    /**
     * 表示対象のタブを取得する
     * @return
     */
    public List<String> getTabFilterList () {
        return tabFilterList;
    }
    
    public void setTabFilterList(List<String> tabFilterList) {
        this.tabFilterList = tabFilterList;
    }

    /**
     * 表示不要タブリストを取得する
     * @return
     */
    public List<String> getTabFilterNoneList () {
        return tabFilterNoneList;
    }
    
    /**
     * 表示対象のタブであるか
     * @param tabId タブID
     * @return
     */
    public boolean isDisplay (String tabId) {
        if (tabFilterList.contains(tabId)) {
            return true;
        }
        return false;
    }
}
