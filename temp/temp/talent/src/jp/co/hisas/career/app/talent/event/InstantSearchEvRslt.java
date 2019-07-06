package jp.co.hisas.career.app.talent.event;

import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.dto.JvProfTabSectDto;
import jp.co.hisas.career.app.talent.dto.JvSectTblMapDto;
import jp.co.hisas.career.app.talent.dto.JvSrchRsltListDto;
import jp.co.hisas.career.app.talent.dto.extra.JvSrchCsvDto;
import jp.co.hisas.career.app.talent.dto.extra.JvWkInstantHitExDto;
import jp.co.hisas.career.ejb.AbstractEventResult;
import jp.co.hisas.career.util.PagingInfo;

@SuppressWarnings("serial")
public class InstantSearchEvRslt extends AbstractEventResult {
	
	public PagingInfo paging = new PagingInfo();
	public List<JvSrchRsltListDto> jvSrchRsltList;
	public List<JvSrchRsltListDto> csvRowList;
	public List<JvSrchCsvDto> jvSrchCsvRowList;
	public List<String> visibleColList;
	public List<JvProfTabSectDto> tabSects;
	public Map<String, JvSectTblMapDto> sectTblMap;
	public List<JvWkInstantHitExDto> hitPzList;
	public String[] queryWords;
	public List<String> scopeList;
	
}