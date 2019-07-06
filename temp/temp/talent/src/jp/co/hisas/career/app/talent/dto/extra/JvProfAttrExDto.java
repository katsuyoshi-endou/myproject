package jp.co.hisas.career.app.talent.dto.extra;

import java.io.Serializable;

public class JvProfAttrExDto implements Serializable {
	
	private static final long serialVersionUID = 1L;
	private String empId;
	private String attrId;
	private String attrVal;
	
	public String getEmpId() {
		return empId;
	}
	
	public void setEmpId( String empId ) {
		this.empId = empId;
	}
	
	public String getAttrId() {
		return attrId;
	}
	
	public void setAttrId( String attrId ) {
		this.attrId = attrId;
	}
	
	public String getAttrVal() {
		return attrVal;
	}
	
	public void setAttrVal( String attrVal ) {
		this.attrVal = attrVal;
	}
	
}
