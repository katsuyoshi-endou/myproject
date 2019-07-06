package jp.co.hisas.career.app.talent.event;

import jp.co.hisas.career.app.talent.bean.DeptTreeBean;
import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;

@SuppressWarnings("serial")
public class DeptTreeEvArg extends AbstractEventArg {
	
	public String state = null;
	public String party = null;
	public String companyCode = null;
	public DeptTreeBean searchGroupBean = null;
	
	public DeptTreeEvArg(String loginNo) throws CareerException {
		if (loginNo == null) {
			throw new CareerException( "Invalid Arg: loginNo is null." );
		}
		this.setLoginNo( loginNo );
	}
	
	public void validateArg() throws CareerException {
		if (SU.isBlank( state )) {
			throw new CareerException( "stateの判断が出来ません" );
		}
		if (!"INIT".equals( state ) && SU.isBlank( companyCode )) {
			throw new CareerException( "会社コードの判断が出来ません" );
		}
	}
	
}
