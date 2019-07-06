package jp.co.hisas.career.app.talent.api.search;

import java.util.Map;

import jp.co.hisas.career.app.talent.mold.ProfileMold;
import jp.co.hisas.career.ejb.AbstractEventResult;

@SuppressWarnings("serial")
public class SearchEvRslt extends AbstractEventResult {

	public int hitCount;
	public Map<String, ProfileMold> profiles;
	
}
