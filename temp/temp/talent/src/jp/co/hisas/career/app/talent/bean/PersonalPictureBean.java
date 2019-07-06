/*
 * All Rights Reserved. Copyright (C) 2004, Hitachi Systems & Services, Ltd.
 *
 * プロジェクト名　：
 *   人材戦略システム（リシテアCareer実績系）
 *
 * 備考　：
 *   なし
 *
 * 履歴　：
 *   日付        バージョン   名前　　　　　内容
 * 2004/03/30       1.0     小野　隆之    新規作成
 */
package jp.co.hisas.career.app.talent.bean;

import java.io.Serializable;

import jp.co.hisas.career.util.log.Log;

public class PersonalPictureBean implements Serializable {
	/* ログインユーザの氏名NO */
	private String login_no = null;

	/* 写真 */
	private byte[] picture;

	/* ファイル名 */
	private String name;

	/* コンテントタイプ */
	private String content_type;

	/* 公開フラグ */
	private String kokaiFlg;

	/**
	 * コンストラクター
	 */
	public PersonalPictureBean(final String login_no) {
		this.login_no = login_no;
	}

	/**
	 * @return
	 */
	public byte[] getPicture() {
		Log.method(this.login_no, "IN", "");
		Log.method(this.login_no, "OUT", "");

		return this.picture;
	}

	/**
	 * @param image
	 */
	public void setPicture(final byte[] image) {
		Log.method(this.login_no, "IN", "");
		this.picture = image;
		Log.method(this.login_no, "OUT", "");
	}

	/**
	 * @return
	 */
	public String getContent_type() {
		return this.content_type;
	}

	/**
	 * @return
	 */
	public String getName() {
		return this.name;
	}

	/**
	 * @param string
	 */
	public void setContent_type(final String string) {
		this.content_type = string;
	}

	/**
	 * @param string
	 */
	public void setName(final String string) {
		this.name = string;
	}

	/**
	 * @return
	 */
	public String getKokaiFlg() {
		return this.kokaiFlg;
	}

	/**
	 * @param string
	 */
	public void setKokaiFlg(final String string) {
		this.kokaiFlg = string;
	}
}