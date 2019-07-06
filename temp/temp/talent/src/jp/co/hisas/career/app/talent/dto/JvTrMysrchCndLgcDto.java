/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class JvTrMysrchCndLgcDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String mysrchId;
    private Integer lgcRowNo;
    private String tabId;
    private String paramId;
    private String searchValue;
    private String kigoType;

    public String getMysrchId() {
        return mysrchId;
    }

    public void setMysrchId(String mysrchId) {
        this.mysrchId = mysrchId;
    }

    public Integer getLgcRowNo() {
        return lgcRowNo;
    }

    public void setLgcRowNo(Integer lgcRowNo) {
        this.lgcRowNo = lgcRowNo;
    }

    public String getTabId() {
        return tabId;
    }

    public void setTabId(String tabId) {
        this.tabId = tabId;
    }

    public String getParamId() {
        return paramId;
    }

    public void setParamId(String paramId) {
        this.paramId = paramId;
    }

    public String getSearchValue() {
        return searchValue;
    }

    public void setSearchValue(String searchValue) {
        this.searchValue = searchValue;
    }

    public String getKigoType() {
        return kigoType;
    }

    public void setKigoType(String kigoType) {
        this.kigoType = kigoType;
    }

}

