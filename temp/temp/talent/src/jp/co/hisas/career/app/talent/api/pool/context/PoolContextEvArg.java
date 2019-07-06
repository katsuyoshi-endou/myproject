package jp.co.hisas.career.app.talent.api.pool.context;

import jp.co.hisas.career.app.talent.deliver.pool.context.PoolContextGetOrder;
import jp.co.hisas.career.app.talent.deliver.pool.context.PoolContextPutOrder;
import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;

public class PoolContextEvArg extends AbstractEventArg {
	
	public String sharp = null;
	public PoolContextGetOrder orderGET;
	public PoolContextPutOrder orderPUT;
	
	public PoolContextEvArg(String loginNo) throws CareerException {
		if (loginNo == null) {
			throw new CareerException( "Invalid Arg: loginNo is null." );
		}
		this.setLoginNo( loginNo );
	}
	
	public void validateArg() throws CareerException {
		String className = PoolContextEvArg.class.getName();
		if (SU.isBlank( sharp )) {
			throw new CareerException( className + "Invalid: sharp is null." );
		}
		// TODO: リクエストチェック機構
	}
	
}
