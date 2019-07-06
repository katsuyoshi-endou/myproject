/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class JvTrMyfoldDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String myfoldId;
    private String myfoldNm;
    private Integer sharedFlg;
    private Integer bindOnlyFlg;
    private String madeBy;
    private String madeAt;
    private String updBy;
    private String updAt;

    public String getMyfoldId() {
        return myfoldId;
    }

    public void setMyfoldId(String myfoldId) {
        this.myfoldId = myfoldId;
    }

    public String getMyfoldNm() {
        return myfoldNm;
    }

    public void setMyfoldNm(String myfoldNm) {
        this.myfoldNm = myfoldNm;
    }

    public Integer getSharedFlg() {
        return sharedFlg;
    }

    public void setSharedFlg(Integer sharedFlg) {
        this.sharedFlg = sharedFlg;
    }

    public Integer getBindOnlyFlg() {
        return bindOnlyFlg;
    }

    public void setBindOnlyFlg(Integer bindOnlyFlg) {
        this.bindOnlyFlg = bindOnlyFlg;
    }

    public String getMadeBy() {
        return madeBy;
    }

    public void setMadeBy(String madeBy) {
        this.madeBy = madeBy;
    }

    public String getMadeAt() {
        return madeAt;
    }

    public void setMadeAt(String madeAt) {
        this.madeAt = madeAt;
    }

    public String getUpdBy() {
        return updBy;
    }

    public void setUpdBy(String updBy) {
        this.updBy = updBy;
    }

    public String getUpdAt() {
        return updAt;
    }

    public void setUpdAt(String updAt) {
        this.updAt = updAt;
    }

}

