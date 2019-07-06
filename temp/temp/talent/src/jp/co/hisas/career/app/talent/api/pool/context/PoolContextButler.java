package jp.co.hisas.career.app.talent.api.pool.context;

import jp.co.hisas.career.app.talent.api.Butler;
import jp.co.hisas.career.app.talent.deliver.DeliverOrder;
import jp.co.hisas.career.app.talent.deliver.pool.context.PoolContextPutDeliver;
import jp.co.hisas.career.app.talent.deliver.pool.context.PoolContextPutOrder;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;

public class PoolContextButler extends Butler {
	
	public PoolContextButler(Tray tray) {
		super( tray );
	}
	
	@Override
	public String takeGET() throws CareerException {
		
		PoolContextEvRslt rslt = new PoolContextEvRslt();
		
		rslt.pageState = tray.getSessionAttr( JvSessionKey.TALENTS_PAGE_STATE );
		
		return SU.toJson( rslt );
	}
	
	@Override
	public String takePOST() throws CareerException {
		return null;
	}
	
	@Override
	public String takePUT() throws CareerException {
		PoolContextPutOrder order = DeliverOrder.fromJson( tray, PoolContextPutOrder.class );
		order.init( tray );
		PoolContextEvRslt rslt = PoolContextPutDeliver.go( tray, order );
		return SU.toJson( rslt );
	}
	
	@Override
	public String takeDELETE() throws CareerException {
		return null;
	}
}
