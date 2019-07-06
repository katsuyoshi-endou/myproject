package jp.co.hisas.career.app.talent.api.history.profile;

import java.util.Map;

import jp.co.hisas.career.app.talent.mold.ProfileMold;
import jp.co.hisas.career.ejb.AbstractEventResult;

@SuppressWarnings("serial")
public class HistoryProfileEvRslt extends AbstractEventResult {
	
	public Map<String, ProfileMold> profiles;
	
}
