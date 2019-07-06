package jp.co.hisas.career.app.talent.api;

import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.Tray;

public abstract class Butler {
	
	public Tray tray;
	
	public Butler( Tray tray ) {
		this.tray = tray;
	}
	
	public String takeGET() throws CareerException {
		return null;
	}
	
	public String takePOST() throws CareerException {
		return null;
	}
	
	public String takePUT() throws CareerException {
		return null;
	}
	
	public String takeDELETE() throws CareerException {
		return null;
	}
	
}
