package jp.co.hisas.career.app.talent.api.shareptc;

import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.WebAPIServlet;
import jp.co.hisas.career.util.Tray;

public class SharePtcAPI extends WebAPIServlet {
	
	private static final long serialVersionUID = 1L;
	
	@Override
	public String doGetMain( Tray tray ) throws CareerException {
		SharePtcButler butler = new SharePtcButler( tray );
		return butler.takeGET();
	}
	
	@Override
	public String doPostMain( Tray tray ) throws CareerException {
		SharePtcButler butler = new SharePtcButler( tray );
		return butler.takePOST();
	}
	
	@Override
	public String doPutMain( Tray tray ) throws CareerException {
		SharePtcButler butler = new SharePtcButler( tray );
		return butler.takePUT();
	}
	
	@Override
	public String doDeleteMain( Tray tray ) throws CareerException {
		return null;
	}
	
}
