package jp.co.hisas.career.app.talent.event;

import jp.co.hisas.career.app.talent.bean.SearchCondSelectBean;
import jp.co.hisas.career.ejb.AbstractEventResult;

@SuppressWarnings("serial")
public class SearchCondSelectEvRslt extends AbstractEventResult {

	public SearchCondSelectBean searchCondSelectBean = null;

}