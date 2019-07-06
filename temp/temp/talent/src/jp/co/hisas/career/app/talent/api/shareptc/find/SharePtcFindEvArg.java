package jp.co.hisas.career.app.talent.api.shareptc.find;

import java.util.Map;

import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;

@SuppressWarnings("serial")
public class SharePtcFindEvArg extends AbstractEventArg {
	
	public String sharp = null;
	public String party;
	public String albumMode;
	public String albumId;
	public Map<String, String> queryMap;
	
	public SharePtcFindEvArg(String loginNo) throws CareerException {
		if (loginNo == null) {
			throw new CareerException( "Invalid Arg: loginNo is null." );
		}
		this.setLoginNo( loginNo );
	}
	
	public void validateArg() throws CareerException {
		if (SU.isBlank( sharp )) {
			throw new CareerException( "Invalid SharePtcEvArg: sharp is null." );
		}
	}
	
}
