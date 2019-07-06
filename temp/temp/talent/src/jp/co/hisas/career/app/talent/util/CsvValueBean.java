package jp.co.hisas.career.app.talent.util;

public abstract class CsvValueBean {

	/** パーソナル情報ValueBean */
	private CsvValueBean personalInfo = null;

	public CsvValueBean getPersonalInfo() {
		return personalInfo;
	}

	/**
	 * パーソナル情報ValueBeanを格納する
	 * @param personalInfo
	 */
	public void setPersonalInfo(CsvValueBean personalInfo) {
		this.personalInfo = personalInfo;
	}
	
	
	
}
