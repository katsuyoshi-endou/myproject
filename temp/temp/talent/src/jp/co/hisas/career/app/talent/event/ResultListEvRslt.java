package jp.co.hisas.career.app.talent.event;

import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.dto.JvSrchRsltListDto;
import jp.co.hisas.career.app.talent.dto.JvSrchRsltWkDto;
import jp.co.hisas.career.app.talent.dto.JvTalStarredDto;
import jp.co.hisas.career.ejb.AbstractEventResult;

@SuppressWarnings("serial")
public class ResultListEvRslt extends AbstractEventResult {

	public int stfCnt;
	public int recordCnt;
	public Map<Integer, JvSrchRsltListDto> jvSrchRsltList;
	public boolean canCsvDownload;
	public List<JvTalStarredDto> starredList;
	public List<JvSrchRsltWkDto> targetList;

}