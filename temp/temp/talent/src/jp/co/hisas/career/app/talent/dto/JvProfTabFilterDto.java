/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class JvProfTabFilterDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String party;
    private String roleId;
    private String tabId;
    private Integer hyojiJunjo;
    private String displayMode;

    public String getParty() {
        return party;
    }

    public void setParty(String party) {
        this.party = party;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }

    public String getTabId() {
        return tabId;
    }

    public void setTabId(String tabId) {
        this.tabId = tabId;
    }

    public Integer getHyojiJunjo() {
        return hyojiJunjo;
    }

    public void setHyojiJunjo(Integer hyojiJunjo) {
        this.hyojiJunjo = hyojiJunjo;
    }

    public String getDisplayMode() {
        return displayMode;
    }

    public void setDisplayMode(String displayMode) {
        this.displayMode = displayMode;
    }

}
