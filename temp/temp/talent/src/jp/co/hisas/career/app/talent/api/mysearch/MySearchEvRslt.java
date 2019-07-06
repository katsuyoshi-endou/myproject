package jp.co.hisas.career.app.talent.api.mysearch;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.bean.LegacyKensakuDefBean;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndLgcDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndMltDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndSglDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchDto;
import jp.co.hisas.career.ejb.AbstractEventResult;

@SuppressWarnings("serial")
public class MySearchEvRslt extends AbstractEventResult {
	
	public JvTrMysrchDto mySearch;
	public String savedMysrchId;
	public HashMap<String, JvTrMysrchCndSglDto> sglMap;
	public HashMap<String, JvTrMysrchCndMltDto> mltMap;
	public List<JvTrMysrchCndLgcDto> lgcList;
	public Map<String, Map<String, String>> slfMap;
	public LegacyKensakuDefBean cndLgcDef;
	public boolean canCndEdit;
	
}
