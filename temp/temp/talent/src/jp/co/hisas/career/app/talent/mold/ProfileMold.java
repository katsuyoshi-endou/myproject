package jp.co.hisas.career.app.talent.mold;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class ProfileMold implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	public String cmpaCd;
	public String stfNo;
	public String photoUrl;
	public boolean isStarred;
	public Map<String, String> basic;
	public Set<TimelineMold> timeline;
	
	public ProfileMold() {
		basic = new HashMap<String, String>();
	}
	
}
