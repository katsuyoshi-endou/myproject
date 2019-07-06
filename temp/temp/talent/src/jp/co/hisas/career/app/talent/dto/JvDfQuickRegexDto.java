/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class JvDfQuickRegexDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String regexPtn;
    private String pzId;
    private String operator;
    private Integer priority;
    private Integer overFlg;

    public String getRegexPtn() {
        return regexPtn;
    }

    public void setRegexPtn(String regexPtn) {
        this.regexPtn = regexPtn;
    }

    public String getPzId() {
        return pzId;
    }

    public void setPzId(String pzId) {
        this.pzId = pzId;
    }

    public String getOperator() {
        return operator;
    }

    public void setOperator(String operator) {
        this.operator = operator;
    }

    public Integer getPriority() {
        return priority;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }

    public Integer getOverFlg() {
        return overFlg;
    }

    public void setOverFlg(Integer overFlg) {
        this.overFlg = overFlg;
    }

}

