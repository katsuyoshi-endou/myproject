/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class KensakuKanoPersonDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String personId;
    private String tgtPersonId;
    private Integer tgtKenmuNo;
    private String tgtSosikiCode;
    private String roleId;

    public String getPersonId() {
        return personId;
    }

    public void setPersonId(String personId) {
        this.personId = personId;
    }

    public String getTgtPersonId() {
        return tgtPersonId;
    }

    public void setTgtPersonId(String tgtPersonId) {
        this.tgtPersonId = tgtPersonId;
    }

    public Integer getTgtKenmuNo() {
        return tgtKenmuNo;
    }

    public void setTgtKenmuNo(Integer tgtKenmuNo) {
        this.tgtKenmuNo = tgtKenmuNo;
    }

    public String getTgtSosikiCode() {
        return tgtSosikiCode;
    }

    public void setTgtSosikiCode(String tgtSosikiCode) {
        this.tgtSosikiCode = tgtSosikiCode;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }

}

