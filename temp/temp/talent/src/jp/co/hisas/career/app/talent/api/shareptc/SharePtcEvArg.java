package jp.co.hisas.career.app.talent.api.shareptc;

import java.util.List;
import java.util.Map;

import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;

@SuppressWarnings("serial")
public class SharePtcEvArg extends AbstractEventArg {
	
	public String sharp = null;
	public String action;
	public String party;
	public String albumMode;
	public String albumId;
	public String tgtGuid;
	public Map<String, String> editableMap;
	public List<String> deletedList;
	public String prevOwner;
	public String nextOwner;
	
	public SharePtcEvArg(String loginNo) throws CareerException {
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
