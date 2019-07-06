/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class JvTrProfViewHistDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer seqNo;
    private String party;
    private String guid;
    private String tgtCmpaCd;
    private String tgtStfNo;
    private String timestamp;

    public Integer getSeqNo() {
        return seqNo;
    }

    public void setSeqNo(Integer seqNo) {
        this.seqNo = seqNo;
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

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

}

