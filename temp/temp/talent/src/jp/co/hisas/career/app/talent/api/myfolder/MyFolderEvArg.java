package jp.co.hisas.career.app.talent.api.myfolder;

import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;

@SuppressWarnings("serial")
public class MyFolderEvArg extends AbstractEventArg {
	
	public String sharp = null;
	public String party;
	public String guid;
	public String myfoldId;
	public String foldNm;
	public boolean isShared;
	
	public MyFolderEvArg(String loginNo) throws CareerException {
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
