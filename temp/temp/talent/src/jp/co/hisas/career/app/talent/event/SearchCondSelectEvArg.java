package jp.co.hisas.career.app.talent.event;

import jp.co.hisas.career.app.talent.bean.SearchCondSelectBean;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.ejb.AbstractEventArg;
import jp.co.hisas.career.util.SU;

@SuppressWarnings("serial")
public class SearchCondSelectEvArg extends AbstractEventArg {



	public String masterId = null;
	public String masterName = null;
	public SearchCondSelectBean searchCondSelectBean = null;

	public SearchCondSelectEvArg(String loginNo) throws CareerException {
		if (loginNo == null) {
			throw new CareerException( "Invalid Arg: loginNo is null." );
		}
		this.setLoginNo( loginNo );
	}

	//カテゴリチェック
	public void ValueCheck() throws CareerException {
		if (SU.isBlank( masterId )) {
			throw new CareerException( "マスタIDの判断が出来ません" );
		}
	}

}
