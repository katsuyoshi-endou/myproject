package jp.co.hisas.career.app.talent.event;

import jp.co.hisas.career.app.talent.mold.MysrchCndLgcMold;
import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;

@SuppressWarnings("serial")
public class LegacyEvArg extends AbstractEventArg {
	
	public String sharp = null;
	public String party;
	public String guid;
	public String tgtCmpaCd;
	public String tgtStfNo;
	
	// selectKensakuInfoAll
	
	public String sessionId;
	public MysrchCndLgcMold pzSearchBean;
	
	// getPersonalPictureBean
	public String tgtGuid;
	
	// getSavedMySearchBySeqNo
	public int seqNo;
	
	public String mysrchId;
	
	public LegacyEvArg(String loginNo) throws CareerException {
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
