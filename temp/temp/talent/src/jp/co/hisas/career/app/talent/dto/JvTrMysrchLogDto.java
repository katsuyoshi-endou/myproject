/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class JvTrMysrchLogDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String mysrchId;
    private Integer actSeq;
    private String actBy;
    private String actType;
    private String actArg;
    private String actAt;

    public String getMysrchId() {
        return mysrchId;
    }

    public void setMysrchId(String mysrchId) {
        this.mysrchId = mysrchId;
    }

    public Integer getActSeq() {
        return actSeq;
    }

    public void setActSeq(Integer actSeq) {
        this.actSeq = actSeq;
    }

    public String getActBy() {
        return actBy;
    }

    public void setActBy(String actBy) {
        this.actBy = actBy;
    }

    public String getActType() {
        return actType;
    }

    public void setActType(String actType) {
        this.actType = actType;
    }

    public String getActArg() {
        return actArg;
    }

    public void setActArg(String actArg) {
        this.actArg = actArg;
    }

    public String getActAt() {
        return actAt;
    }

    public void setActAt(String actAt) {
        this.actAt = actAt;
    }

}

