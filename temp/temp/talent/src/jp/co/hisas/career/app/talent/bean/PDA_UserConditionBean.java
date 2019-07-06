package jp.co.hisas.career.app.talent.bean;

import java.io.Serializable;

/**
 * ユーザ選択Bean.
 */
public class PDA_UserConditionBean implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 職番 */
    private String kojinShokuban;

    /** 氏名（漢字） */
    private String kojinKanji;

    /** 氏名（全角カナ） */
    private String kojinKana;

    /** 氏名（英語） */
    private String kojinEiji;

    /** 旧姓検索 (true:検索対象、false:検索非対象) */
    private boolean kojin_kyuseiFlg;
// ADD 2010/07/05 COMTURE VDA010_自由条件検索(01-00) START
    /** 所属 */
    private String kojinShozoku;

    /**
     * @return kojinShozoku
     */
    public String getKojinShozoku() {
        return kojinShozoku;
    }

    /**
     * @param kojinShozoku 設定する kojinShozoku
     */
    public void setKojinShozoku( String kojinShozoku ) {
        this.kojinShozoku = kojinShozoku;
    }
// ADD 2010/07/05 COMTURE VDA010_自由条件検索(01-00) END
// ADD 2012/11 SBAW 上長向け検索 start
    private String inpDDA051;
    private String inpDDA052;
    private String inpDDA053;
    private String inpDDA054;
    private String inpDDA055;
    private String inpDDA056;
    private String inpDDA057;
    private int selDDA051;
    private int selDDA052;
    private int selDDA053;
    private int selDDA054;
    private int selDDA055;
    private int selDDA056;
    private int selDDA057;

	public String getInpDDA051() {
		return inpDDA051;
	}

	public void setInpDDA051(String inpDDA051) {
		this.inpDDA051 = inpDDA051;
	}

	public String getInpDDA052() {
		return inpDDA052;
	}

	public void setInpDDA052(String inpDDA052) {
		this.inpDDA052 = inpDDA052;
	}

	public String getInpDDA053() {
		return inpDDA053;
	}

	public void setInpDDA053(String inpDDA053) {
		this.inpDDA053 = inpDDA053;
	}

	public String getInpDDA054() {
		return inpDDA054;
	}

	public void setInpDDA054(String inpDDA054) {
		this.inpDDA054 = inpDDA054;
	}

	public String getInpDDA055() {
		return inpDDA055;
	}

	public void setInpDDA055(String inpDDA055) {
		this.inpDDA055 = inpDDA055;
	}

	public String getInpDDA056() {
		return inpDDA056;
	}

	public void setInpDDA056(String inpDDA056) {
		this.inpDDA056 = inpDDA056;
	}

	public String getInpDDA057() {
		return inpDDA057;
	}

	public void setInpDDA057(String inpDDA057) {
		this.inpDDA057 = inpDDA057;
	}

	public int getSelDDA051() {
		return selDDA051;
	}

	public void setSelDDA051(int selDDA051) {
		this.selDDA051 = selDDA051;
	}

	public int getSelDDA052() {
		return selDDA052;
	}

	public void setSelDDA052(int selDDA052) {
		this.selDDA052 = selDDA052;
	}

	public int getSelDDA053() {
		return selDDA053;
	}

	public void setSelDDA053(int selDDA053) {
		this.selDDA053 = selDDA053;
	}

	public int getSelDDA054() {
		return selDDA054;
	}

	public void setSelDDA054(int selDDA054) {
		this.selDDA054 = selDDA054;
	}

	public int getSelDDA055() {
		return selDDA055;
	}

	public void setSelDDA055(int selDDA055) {
		this.selDDA055 = selDDA055;
	}

	public int getSelDDA056() {
		return selDDA056;
	}

	public void setSelDDA056(int selDDA056) {
		this.selDDA056 = selDDA056;
	}

	public int getSelDDA057() {
		return selDDA057;
	}

	public void setSelDDA057(int selDDA057) {
		this.selDDA057 = selDDA057;
	}
// ADD 2012/11 SBAW 上長向け検索 end
    /**
     * 旧姓検索 (true:検索対象、false:検索非対象)を取得。
     * 
     * @return kojin_kyuseiFlg 旧姓検索 (true:検索対象、false:検索非対象)
     */
    public boolean isKojin_kyuseiFlg() {
        return kojin_kyuseiFlg;
    }

    /**
     * 旧姓検索 (true:検索対象、false:検索非対象)を設定する。
     * 
     * @param kojin_kyuseiFlg 旧姓検索 (true:検索対象、false:検索非対象)
     */
    public void setKojin_kyuseiFlg( boolean kojin_kyuseiFlg ) {
        this.kojin_kyuseiFlg = kojin_kyuseiFlg;
    }

    /**
     * 氏名（英語）を取得。
     * 
     * @return kojinEiji 氏名（英語）
     */
    public String getKojinEiji() {
        return kojinEiji;
    }

    /**
     * 氏名（英語）を設定する。
     * 
     * @param kojinEiji 氏名（英語）
     */
    public void setKojinEiji( String kojinEiji ) {
        this.kojinEiji = kojinEiji;
    }

    /**
     * 氏名（全角カナ）を取得。
     * 
     * @return kojinKana 氏名（全角カナ）
     */
    public String getKojinKana() {
        return kojinKana;
    }

    /**
     * 氏名（全角カナ）を設定する。
     * 
     * @param kojinKana 氏名（全角カナ）
     */
    public void setKojinKana( String kojinKana ) {
        this.kojinKana = kojinKana;
    }

    /**
     * 氏名（漢字）を取得。
     * 
     * @return kojinKanji 氏名（漢字）
     */
    public String getKojinKanji() {
        return kojinKanji;
    }

    /**
     * 氏名（漢字）を設定する。
     * 
     * @param kojinKanji 氏名（漢字）
     */
    public void setKojinKanji( String kojinKanji ) {
        this.kojinKanji = kojinKanji;
    }

    /**
     * 職番を取得。
     * 
     * @return kojinShokuban 職番
     */
    public String getKojinShokuban() {
        return kojinShokuban;
    }

    /**
     * 職番を設定する。
     * 
     * @param kojinShokuban 職番
     */
    public void setKojinShokuban( String kojinShokuban ) {
        this.kojinShokuban = kojinShokuban;
    }
}
