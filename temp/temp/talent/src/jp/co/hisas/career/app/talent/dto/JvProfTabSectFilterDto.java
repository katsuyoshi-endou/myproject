/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class JvProfTabSectFilterDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String party;
    private String roleId;
    private String tabId;
    private String sectId;
    private String onOff;

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

    public String getSectId() {
        return sectId;
    }

    public void setSectId(String sectId) {
        this.sectId = sectId;
    }

    public String getOnOff() {
        return onOff;
    }

    public void setOnOff(String onOff) {
        this.onOff = onOff;
    }

}

