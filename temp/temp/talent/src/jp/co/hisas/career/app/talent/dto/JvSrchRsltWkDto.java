/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class JvSrchRsltWkDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String sessionId;
    private String party;
    private String guid;
    private String tgtCmpaCd;
    private String tgtStfNo;
    private String roleId;
    private String updUser;

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public String getParty() {
        return party;
    }

    public void setParty(String party) {
        this.party = party;
    }

    public String getGuid() {
        return guid;
    }

    public void setGuid(String guid) {
        this.guid = guid;
    }

    public String getTgtCmpaCd() {
        return tgtCmpaCd;
    }

    public void setTgtCmpaCd(String tgtCmpaCd) {
        this.tgtCmpaCd = tgtCmpaCd;
    }

    public String getTgtStfNo() {
        return tgtStfNo;
    }

    public void setTgtStfNo(String tgtStfNo) {
        this.tgtStfNo = tgtStfNo;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }

    public String getUpdUser() {
        return updUser;
    }

    public void setUpdUser(String updUser) {
        this.updUser = updUser;
    }

}

