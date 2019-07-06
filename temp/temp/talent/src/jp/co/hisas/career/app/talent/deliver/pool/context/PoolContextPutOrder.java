package jp.co.hisas.career.app.talent.deliver.pool.context;

import jp.co.hisas.career.app.talent.api.mold.TalentsPageState;
import jp.co.hisas.career.app.talent.deliver.DeliverOrder;
import jp.co.hisas.career.util.Tray;

public class PoolContextPutOrder extends DeliverOrder {
	
	public TalentsPageState pageState;
	
	public PoolContextPutOrder(Tray tray) {
		super( tray );
	}
}
