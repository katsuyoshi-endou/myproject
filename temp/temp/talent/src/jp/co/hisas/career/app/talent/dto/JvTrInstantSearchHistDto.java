/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class JvTrInstantSearchHistDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer seqNo;
    private String party;
    private String guid;
    private String scopes;
    private String query;
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

    public String getScopes() {
        return scopes;
    }

    public void setScopes(String scopes) {
        this.scopes = scopes;
    }

    public String getQuery() {
        return query;
    }

    public void setQuery(String query) {
        this.query = query;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

}

