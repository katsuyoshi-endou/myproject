package jp.co.hisas.career.app.talent.event;

import java.util.List;

import jp.co.hisas.career.app.talent.dto.JvDfInstantSearchDto;
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchDto;
import jp.co.hisas.career.ejb.AbstractEventResult;

public class MyMenuEvRslt extends AbstractEventResult {
	
	public boolean hasRoles;
	public List<JvDfInstantSearchDto> instantSearchScopeList;
	public List<JvTrMysrchDto> mysrchList;
	public List<JvTrMyfoldDto> myfoldList;
	public boolean canRetireSrch;
	public List<JvTrMysrchDto> sharedMysrchList;
	public List<JvTrMyfoldDto> sharedMyfoldList;
	
}
