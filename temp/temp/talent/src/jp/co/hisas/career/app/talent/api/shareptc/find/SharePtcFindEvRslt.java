package jp.co.hisas.career.app.talent.api.shareptc.find;

import java.util.List;
import java.util.Map;

import jp.co.hisas.career.ejb.AbstractEventResult;

@SuppressWarnings("serial")
public class SharePtcFindEvRslt extends AbstractEventResult {

	public List<Map<String, String>> findResult;
	public Map<String, Map<String, String>> profileAttrMap;
	
}
