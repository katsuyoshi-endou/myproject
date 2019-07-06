package jp.co.hisas.career.app.talent.api.pool;

import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.WebAPIServlet;
import jp.co.hisas.career.util.Tray;

public class PoolAPI extends WebAPIServlet {
	
	private static final long serialVersionUID = 1L;
	
	@Override
	public String doGetMain( Tray tray ) throws CareerException {
		PoolButler butler = new PoolButler( tray );
		return butler.takeGET();
	}
	
	@Override
	public String doPostMain( Tray tray ) throws Exception {
		return null;
	}
	
	@Override
	public String doPutMain( Tray tray ) throws CareerException {
		return null;
	}
	
	@Override
	public String doDeleteMain( Tray tray ) throws Exception {
		return null;
	}
	
}
