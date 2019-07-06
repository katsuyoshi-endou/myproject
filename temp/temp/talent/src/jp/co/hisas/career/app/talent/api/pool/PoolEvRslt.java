package jp.co.hisas.career.app.talent.api.pool;

import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.dto.extra.JvSrchRsltWkDtoEx;
import jp.co.hisas.career.ejb.AbstractEventResult;

@SuppressWarnings("serial")
public class PoolEvRslt extends AbstractEventResult {
	
	public List<JvSrchRsltWkDtoEx> resultList;
	public Map<String, Map<String, String>> profileAttrMap;
	
}
