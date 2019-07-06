package jp.co.hisas.career.app.talent.event;

import jp.co.hisas.career.app.talent.bean.DeptTreeBean;
import jp.co.hisas.career.ejb.AbstractEventResult;

@SuppressWarnings("serial")
public class DeptTreeEvRslt extends AbstractEventResult {

	public DeptTreeBean deptTreeBean = null;

}