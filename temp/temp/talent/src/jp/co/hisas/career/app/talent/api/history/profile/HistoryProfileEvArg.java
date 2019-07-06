package jp.co.hisas.career.app.talent.api.history.profile;

import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;

@SuppressWarnings("serial")
public class HistoryProfileEvArg extends AbstractEventArg {
	
	public String sharp = null;
	public String sessionId;
	public String party;
	public String guid;
	public String tgtCmpaCd;
	public String tgtStfNo;
	
	public HistoryProfileEvArg(String loginNo) throws CareerException {
		if (loginNo == null) {
			throw new CareerException( "Invalid Arg: loginNo is null." );
		}
		this.setLoginNo( loginNo );
	}
	
	public void validateArg() throws CareerException {
		if (SU.isBlank( sharp )) {
			throw new CareerException( "Invalid HistoryProfileEvArg: sharp is null." );
		}
	}
	
}
