/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class JvTrMysrchCndSlfDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String mysrchId;
    private String sectId;
    private String komokuId;
    private String query;
    private String kigoType;

    public String getMysrchId() {
        return mysrchId;
    }

    public void setMysrchId(String mysrchId) {
        this.mysrchId = mysrchId;
    }

    public String getSectId() {
        return sectId;
    }

    public void setSectId(String sectId) {
        this.sectId = sectId;
    }

    public String getKomokuId() {
        return komokuId;
    }

    public void setKomokuId(String komokuId) {
        this.komokuId = komokuId;
    }

    public String getQuery() {
        return query;
    }

    public void setQuery(String query) {
        this.query = query;
    }

    public String getKigoType() {
        return kigoType;
    }

    public void setKigoType(String kigoType) {
        this.kigoType = kigoType;
    }

}

