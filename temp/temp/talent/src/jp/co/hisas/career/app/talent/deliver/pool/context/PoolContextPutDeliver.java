package jp.co.hisas.career.app.talent.deliver.pool.context;

import jp.co.hisas.career.app.talent.api.mold.TalentsPageState;
import jp.co.hisas.career.app.talent.api.pool.context.PoolContextEvRslt;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.Tray;

public class PoolContextPutDeliver {
	
	public static PoolContextEvRslt go( Tray tray, PoolContextPutOrder order ) throws CareerException {
		TalentsPageState ps = order.pageState;
		tray.session.setAttribute( JvSessionKey.TALENTS_PAGE_STATE, ps );
		return null;
	}
	
}
