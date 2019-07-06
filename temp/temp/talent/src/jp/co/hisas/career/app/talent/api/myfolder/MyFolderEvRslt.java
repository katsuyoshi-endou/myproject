package jp.co.hisas.career.app.talent.api.myfolder;

import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.dto.JvTrMyfoldDto;
import jp.co.hisas.career.ejb.AbstractEventResult;

@SuppressWarnings("serial")
public class MyFolderEvRslt extends AbstractEventResult {
	
	public JvTrMyfoldDto myFolder;
	public String myfoldId;
	public List<Map<String, String>> pickupFolders;
	public boolean canTalEdit;
	
}
