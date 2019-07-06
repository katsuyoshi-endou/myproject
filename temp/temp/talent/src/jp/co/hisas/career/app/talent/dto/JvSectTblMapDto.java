/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.                             
 */
/**************************************************
       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.talent.dto;

import java.io.Serializable;

public class JvSectTblMapDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String party;
    
    private String filSectId;
    private String csvPtnId;
    private String csvPtnNm;
    private String tblObj;
    private String fileNm;

    public String getParty() {
        return party;
    }

    public void setParty(String party) {
        this.party = party;
    }

    public String getCsvPtnId() {
    	return csvPtnId;
    }

    public void setCsvPtnId(String ptnId) {
    	this.csvPtnId = ptnId;
    }

    public String getCsvPtnNm() {
    	return csvPtnNm;
    }

    public void setCsvPtnNm(String ptnNm) {
    	this.csvPtnNm = ptnNm;
    }
    
    public String getFilSectId() {
    	return filSectId;
    }
    
    public void setFilSectId(String sectId) {
    	this.filSectId = sectId;
    }

    public String getTblObj() {
        return tblObj;
    }

    public void setTblObj(String tblObj) {
        this.tblObj = tblObj;
    }

    public String getFileNm() {
        return fileNm;
    }

    public void setFileNm(String fileNm) {
        this.fileNm = fileNm;
    }

}

