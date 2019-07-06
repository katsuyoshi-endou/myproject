package jp.co.hisas.career.app.talent.event;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.bean.LegacyKensakuDefBean;
import jp.co.hisas.career.app.talent.bean.PersonalPictureBean;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndLgcDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndMltDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndSglDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchDto;
import jp.co.hisas.career.ejb.AbstractEventResult;

@SuppressWarnings("serial")
public class LegacyEvRslt extends AbstractEventResult {
	
	// selectKensakuInfoAll
	public LegacyKensakuDefBean legacyKensakuDefBean;
	
	// getPersonalPictureBean
	public PersonalPictureBean picturebean;
	
	// getSavedMySearchBySeqNo
	public HashMap<String, JvTrMysrchCndSglDto> sglMap;
	public HashMap<String, JvTrMysrchCndMltDto> mltMap;
	public List<JvTrMysrchCndLgcDto> lgcList;
	public Map<String, Map<String, String>> slfMap;

	public List<JvTrMysrchDto> mysrchList;
	
}