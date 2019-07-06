package jp.co.hisas.career.app.talent.dto.extra;

import java.io.Serializable;

public class JvSrchRsltWkDtoEx implements Serializable {
	
	private static final long serialVersionUID = 1L;
	private String tgtCmpaCd;
	private String tgtStfNo;
	private Integer wkIdx;
	private Integer starredFlg;
	
	public String getTgtCmpaCd() {
		return tgtCmpaCd;
	}
	
	public void setTgtCmpaCd( String tgtCmpaCd ) {
		this.tgtCmpaCd = tgtCmpaCd;
	}
	
	public String getTgtStfNo() {
		return tgtStfNo;
	}
	
	public void setTgtStfNo( String tgtStfNo ) {
		this.tgtStfNo = tgtStfNo;
	}
	
	public Integer getWkIdx() {
		return wkIdx;
	}
	
	public void setWkIdx( Integer wkIdx ) {
		this.wkIdx = wkIdx;
	}
	
	public Integer getStarredFlg() {
		return starredFlg;
	}
	
	public void setStarredFlg( Integer starredFlg ) {
		this.starredFlg = starredFlg;
	}
	
}
