/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class JvDfQuickWordDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String word;
    private String pzId;
    private Integer priority;
    private Integer overFlg;

    public String getWord() {
        return word;
    }

    public void setWord(String word) {
        this.word = word;
    }

    public String getPzId() {
        return pzId;
    }

    public void setPzId(String pzId) {
        this.pzId = pzId;
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

