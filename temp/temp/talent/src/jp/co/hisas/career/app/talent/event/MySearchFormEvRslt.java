package jp.co.hisas.career.app.talent.event;

import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.dto.JvProfTabSectListtypeDto;
import jp.co.hisas.career.ejb.AbstractEventResult;

@SuppressWarnings("serial")
public class MySearchFormEvRslt extends AbstractEventResult {

	public int stfCnt;
	public int recordCnt;
	public Map<String, List<JvProfTabSectListtypeDto>> shelftypeList;

}