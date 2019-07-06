package jp.co.hisas.career.app.talent.api.pool.context;

import javax.xml.ws.http.HTTPException;

import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.WebAPIServlet;
import jp.co.hisas.career.util.Tray;

public class PoolContextAPI extends WebAPIServlet {
	
	private static final long serialVersionUID = 1L;
	
	@Override
	public String doGetMain( Tray tray ) throws CareerException {
		PoolContextButler butler = new PoolContextButler( tray );
		return butler.takeGET();
	}
	
	@Override
	public String doPostMain( Tray tray ) throws CareerException {
		throw new HTTPException( 405 );
	}
	
	@Override
	public String doPutMain( Tray tray ) throws CareerException {
		PoolContextButler butler = new PoolContextButler( tray );
		return butler.takePUT();
	}
	
	@Override
	public String doDeleteMain( Tray tray ) throws CareerException {
		throw new HTTPException( 405 );
	}
	
}
