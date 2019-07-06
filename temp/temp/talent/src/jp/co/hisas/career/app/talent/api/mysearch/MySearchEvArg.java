package jp.co.hisas.career.app.talent.api.mysearch;

import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.dto.JvTrMysrchCndLgcDto;
import jp.co.hisas.career.app.talent.mold.MySearchMold;
import jp.co.hisas.career.app.talent.mold.MysrchCndLgcMold;
import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;

@SuppressWarnings("serial")
public class MySearchEvArg extends AbstractEventArg {
	
	public String sharp = null;
	public String party;
	public String guid;
	public String query;
	public String sessionId;
	public MySearchMold mySearchMold;
	public Map<String, Map<String, String>> shelfCondMap;
	public MysrchCndLgcMold pzSearchBean;
	public String mysrchId;
	public String mysrchNm;
	public Map<String, String> saveHistDtlSglMap;
	public Map<String, Map<Integer, String[]>> saveHistDtlMltMap;
	public List<JvTrMysrchCndLgcDto> saveHistDtlLgcList;
	public Map<String, Map<String, String>> saveHistShelftypeMap;
	public boolean exceptRetire;
	public boolean exceptRemove;
	public boolean isShared;
	
	public MySearchEvArg(String loginNo) throws CareerException {
		if (loginNo == null) {
			throw new CareerException( "Invalid Arg: loginNo is null." );
		}
		this.setLoginNo( loginNo );
	}
	
	public void validateArg() throws CareerException {
		if (SU.isBlank( sharp )) {
			throw new CareerException( "Invalid SearchEvArg: sharp is null." );
		}
	}
	
}
