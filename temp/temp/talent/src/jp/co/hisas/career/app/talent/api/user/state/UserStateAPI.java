package jp.co.hisas.career.app.talent.api.user.state;

import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.WebAPIServlet;
import jp.co.hisas.career.util.Tray;

public class UserStateAPI extends WebAPIServlet {
	
	private static final long serialVersionUID = 1L;
	
	@Override
	public String doGetMain( Tray tray ) throws CareerException {
		return null;
	}
	
	@Override
	public String doPostMain( Tray tray ) throws CareerException {
		return null;
	}
	
	@Override
	public String doPutMain( Tray tray ) throws CareerException {
		UserStateButler butler = new UserStateButler( tray );
		return butler.takePUT();
	}
	
	@Override
	public String doDeleteMain( Tray tray ) throws CareerException {
		return null;
	}
	
}
