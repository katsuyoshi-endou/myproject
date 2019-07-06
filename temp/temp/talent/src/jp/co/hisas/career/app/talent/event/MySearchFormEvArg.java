package jp.co.hisas.career.app.talent.event;

import java.util.Map;

import jp.co.hisas.career.app.talent.dto.JvSrchRsltListDto;
import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;

@SuppressWarnings("serial")
public class MySearchFormEvArg extends AbstractEventArg {
	
	public String sharp = null;
	public String party = null;
	public Map<Integer, JvSrchRsltListDto> jvSrchRsltList;
	public Map<Integer, String> reqIdxList;
	public String colsPtn;
	public String trans;
	public String guid;
	public boolean isShared;
	
	public MySearchFormEvArg(String loginNo) throws CareerException {
		if (loginNo == null) {
			throw new CareerException( "Invalid Arg: loginNo is null." );
		}
		this.setLoginNo( loginNo );
	}
	
	public void validateArg() throws CareerException {
		if (SU.isBlank( sharp )) {
			throw new CareerException( "Invalid MySearchFormEvArg: sharp is null." );
		}
	}
	
}
