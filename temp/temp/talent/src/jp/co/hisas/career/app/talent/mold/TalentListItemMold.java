package jp.co.hisas.career.app.talent.mold;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class TalentListItemMold implements Serializable {
	
	private static final long serialVersionUID = 1L;

	public String photoUrl;
	public Map<String, String> attr;

	public TalentListItemMold() {
		attr = new HashMap<String, String>();
	}
}
