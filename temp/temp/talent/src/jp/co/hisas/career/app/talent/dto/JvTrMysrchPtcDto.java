/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class JvTrMysrchPtcDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String mysrchId;
    private String party;
    private String guid;
    private Integer ownerFlg;
    private Integer cndEditFlg;

    public String getMysrchId() {
        return mysrchId;
    }

    public void setMysrchId(String mysrchId) {
        this.mysrchId = mysrchId;
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

    public Integer getOwnerFlg() {
        return ownerFlg;
    }

    public void setOwnerFlg(Integer ownerFlg) {
        this.ownerFlg = ownerFlg;
    }

    public Integer getCndEditFlg() {
        return cndEditFlg;
    }

    public void setCndEditFlg(Integer cndEditFlg) {
        this.cndEditFlg = cndEditFlg;
    }

}

