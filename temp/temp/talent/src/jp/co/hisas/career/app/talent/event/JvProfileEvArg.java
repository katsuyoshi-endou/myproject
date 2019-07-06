package jp.co.hisas.career.app.talent.event;

import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;

@SuppressWarnings("serial")
public class JvProfileEvArg extends AbstractEventArg {
	
	public String sharp = null;
	public String party = null;
	public String tgtCmpaCd = null;
	public String tgtStfNo = null;
	public String tgtRoleId = null;
// #OLYM_065W ADD START
		public String tgtGuid = null;
// #OLYM_065W ADD END
	public String sessionId = null;
	public String guid;
	public String wkIdx;
	
	public JvProfileEvArg(String loginNo) throws CareerException {
		if (loginNo == null) {
			throw new CareerException( "Invalid Arg: loginNo is null." );
		}
		this.setLoginNo( loginNo );
	}
	
	public void validateArg() throws CareerException {
		if (SU.isBlank( sharp )) {
			throw new CareerException( "Invalid JvProfileEvArg: sharp is null." );
		}
		if (SU.equals( sharp, "INIT" )) {
			if (SU.isBlank( party )) {
				throw new CareerException( "Invalid JvProfileEvArg: party is null." );
			}
			if (SU.isBlank( tgtRoleId )) {
				throw new CareerException( "Invalid JvProfileEvArg: tgtRoleId is null." );
			}
		}
	}
	
}
