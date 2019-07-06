package jp.co.hisas.career.app.talent.event;

import java.util.List;
import java.util.Map;

import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;

@SuppressWarnings("serial")
public class SearchTalentsEvArg extends AbstractEventArg {
	
	public String sharp = null;
	public String sessionId;
	public String party;
	public String guid;
	public boolean isSrch;
	public String colsPtn;
	public String sectId;
	public List<String> addedItems;
	public String filterKomokuId;
	public String deptCmpaCd;
	public String startDeptCd;
	public String tblObj;
	public String shelfSectId;
	public Map<String, String> shelfConds;
	
	public SearchTalentsEvArg(String loginNo) throws CareerException {
		if (loginNo == null) {
			throw new CareerException( "Invalid Arg: loginNo is null." );
		}
		this.setLoginNo( loginNo );
	}
	
	public void validateArg() throws CareerException {
		if (SU.isBlank( sharp )) {
			throw new CareerException( "Invalid JvProfileEvArg: sharp is null." );
		}
	}
	
}
