/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class KensakuKigoDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String kensakuKomokuId;
    private Integer hyojiJyunjyo;
    private String hyojiName;
    private String kigoType;
    private String updatePersonId;
    private String updateFunction;
    private String updateDate;
    private String updateTime;

    public String getKensakuKomokuId() {
        return kensakuKomokuId;
    }

    public void setKensakuKomokuId(String kensakuKomokuId) {
        this.kensakuKomokuId = kensakuKomokuId;
    }

    public Integer getHyojiJyunjyo() {
        return hyojiJyunjyo;
    }

    public void setHyojiJyunjyo(Integer hyojiJyunjyo) {
        this.hyojiJyunjyo = hyojiJyunjyo;
    }

    public String getHyojiName() {
        return hyojiName;
    }

    public void setHyojiName(String hyojiName) {
        this.hyojiName = hyojiName;
    }

    public String getKigoType() {
        return kigoType;
    }

    public void setKigoType(String kigoType) {
        this.kigoType = kigoType;
    }

    public String getUpdatePersonId() {
        return updatePersonId;
    }

    public void setUpdatePersonId(String updatePersonId) {
        this.updatePersonId = updatePersonId;
    }

    public String getUpdateFunction() {
        return updateFunction;
    }

    public void setUpdateFunction(String updateFunction) {
        this.updateFunction = updateFunction;
    }

    public String getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(String updateDate) {
        this.updateDate = updateDate;
    }

    public String getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(String updateTime) {
        this.updateTime = updateTime;
    }

}

