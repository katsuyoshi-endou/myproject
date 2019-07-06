package jp.co.hisas.career.app.talent.event;

import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;

@SuppressWarnings("serial")
public class MyMenuEvArg extends AbstractEventArg {
	
	public String sharp = null;
	public String party = null;
	public String guid = null;
	
	public MyMenuEvArg(String loginNo) throws CareerException {
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
