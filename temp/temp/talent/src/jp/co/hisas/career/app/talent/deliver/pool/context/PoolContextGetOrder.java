package jp.co.hisas.career.app.talent.deliver.pool.context;

import jp.co.hisas.career.app.talent.deliver.DeliverOrder;
import jp.co.hisas.career.util.Tray;

public class PoolContextGetOrder extends DeliverOrder {
	
	public String operationCd;
	
	public PoolContextGetOrder(Tray tray) {
		super( tray );
	}
}
