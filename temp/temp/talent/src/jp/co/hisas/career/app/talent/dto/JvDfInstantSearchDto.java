/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class JvDfInstantSearchDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String party;
    private String scope;
    private Integer sort;
    private Integer checkFlg;

    public String getParty() {
        return party;
    }

    public void setParty(String party) {
        this.party = party;
    }

    public String getScope() {
        return scope;
    }

    public void setScope(String scope) {
        this.scope = scope;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Integer getCheckFlg() {
        return checkFlg;
    }

    public void setCheckFlg(Integer checkFlg) {
        this.checkFlg = checkFlg;
    }

}

