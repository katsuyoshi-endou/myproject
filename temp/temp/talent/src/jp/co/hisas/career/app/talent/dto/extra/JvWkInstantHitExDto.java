package jp.co.hisas.career.app.talent.dto.extra;

import java.io.Serializable;

public class JvWkInstantHitExDto implements Serializable {
	
	private static final long serialVersionUID = 1L;
	private Integer querySeq;
	private String query;
	private String eid;
	private String pzId;
	private String pzName;
	private String pzVal;
	
	public Integer getQuerySeq() {
		return querySeq;
	}
	
	public void setQuerySeq( Integer querySeq ) {
		this.querySeq = querySeq;
	}
	
	public String getQuery() {
		return query;
	}
	
	public void setQuery( String query ) {
		this.query = query;
	}
	
	public String getEid() {
		return eid;
	}
	
	public void setEid( String eid ) {
		this.eid = eid;
	}
	
	public String getPzId() {
		return pzId;
	}
	
	public void setPzId( String pzId ) {
		this.pzId = pzId;
	}
	
	public String getPzName() {
		return pzName;
	}
	
	public void setPzName( String pzName ) {
		this.pzName = pzName;
	}
	
	public String getPzVal() {
		return pzVal;
	}
	
	public void setPzVal( String pzVal ) {
		this.pzVal = pzVal;
	}
	
}
