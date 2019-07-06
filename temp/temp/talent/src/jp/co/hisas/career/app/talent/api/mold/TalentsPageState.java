package jp.co.hisas.career.app.talent.api.mold;

import java.io.Serializable;

public class TalentsPageState implements Serializable {
	
	public int currentPage = 1;
	public int currentPageSize = 50;
	public String lastClickedEid = "";
}
