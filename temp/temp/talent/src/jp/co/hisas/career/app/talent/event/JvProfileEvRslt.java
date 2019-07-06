package jp.co.hisas.career.app.talent.event;

import java.util.Map;

import jp.co.hisas.career.app.talent.bean.JvProfileBean;
import jp.co.hisas.career.ejb.AbstractEventResult;
import jp.co.hisas.career.util.dto.CaRegistDto;
import jp.co.hisas.career.util.dto.CaRegistMainDto;

@SuppressWarnings("serial")
public class JvProfileEvRslt extends AbstractEventResult {
	
	public JvProfileBean jvProfileBean = null;
	public String tgtRoleId = null;
	public CaRegistDto caRegistDto;
	public CaRegistMainDto caRegistMainDto;
	public Map<String, String> filteredPzBoxMap;
	public Map<String, String> wkProfile;
	public int wkIdxMax;
	
}
