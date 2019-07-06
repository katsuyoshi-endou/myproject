package jp.co.hisas.career.app.talent.api.pool.context;

import jp.co.hisas.career.app.talent.api.mold.TalentsPageState;
import jp.co.hisas.career.ejb.AbstractEventResult;

public class PoolContextEvRslt extends AbstractEventResult {
	
	public int hitCount;
	public TalentsPageState pageState;
}
