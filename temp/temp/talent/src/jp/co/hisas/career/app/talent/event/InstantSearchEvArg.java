package jp.co.hisas.career.app.talent.event;

import java.util.List;

import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;

@SuppressWarnings("serial")
public class InstantSearchEvArg extends AbstractEventArg {
	
	public String sharp = null;
	public String sessionId;
	public String guid;
	public String party;
	public String query;
	public String[] scopes;
	public boolean exceptRetire;
	public boolean exceptRemove;
	public List<String> multiStfnoList;
	
	public InstantSearchEvArg(String loginNo) throws CareerException {
		if (loginNo == null) {
			throw new CareerException( "Invalid Arg: loginNo is null." );
		}
		this.setLoginNo( loginNo );
	}
	
	public void validateArg() throws CareerException {
		if (SU.isBlank( sharp )) {
			throw new CareerException( "Invalid InstantSearchEvArg: sharp is null." );
		}
	}
	
}
