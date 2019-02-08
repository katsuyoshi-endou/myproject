/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.
 */
/**************************************************
 !!!!!このファイルは編集しないでください!!!!!
        自動生成されたソースコードです。
        Excelブックを編集してください。

       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.batch.jinik.dto;

import java.io.Serializable;

/**
 * MAIL_INFO Data Transfer Object。
 * @author CareerDaoTool.xla
*/
public class MailInfoDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 送信連番
     */
    private Integer sendNo;
    /**
     * 状態
     */
    private Integer status;
    /**
     * Fromアドレス
     */
    private String fromAddress;
    /**
     * Toアドレス
     */
    private String toAddress;
    /**
     * CCアドレス
     */
    private String ccAddress;
    /**
     * BCCアドレス
     */
    private String bccAddress;
    /**
     * 件名
     */
    private String title;
    /**
     * 本文
     */
    private String body;
    /**
     * 実行者ID
     */
    private String actionPersonId;
    /**
     * 機能種別
     */
    private String kind;
    /**
     * 実行結果メッセージ
     */
    private String message;
    /**
     * 最終更新機能ID
     */
    private String updateFunctionId;
    /**
     * 最終更新日時
     */
    private String updateDate;
    /**
     * 予備文字列1
     */
    private String reservedString1;
    /**
     * 予備文字列2
     */
    private String reservedString2;
    /**
     * 予備文字列3
     */
    private String reservedString3;
    /**
     * 予備文字列4
     */
    private String reservedString4;
    /**
     * 予備文字列5
     */
    private String reservedString5;
    /**
     * 予備文字列6
     */
    private String reservedString6;
    /**
     * 予備文字列7
     */
    private String reservedString7;
    /**
     * 予備文字列8
     */
    private String reservedString8;
    /**
     * 予備文字列9
     */
    private String reservedString9;
    /**
     * 予備文字列10
     */
    private String reservedString10;

    /**
     * 送信連番を取得する。
     * @return 送信連番
     */
    public Integer getSendNo() {
        return sendNo;
    }

    /**
     * 送信連番を設定する。
     * @param sendNo 送信連番
     */
    public void setSendNo(Integer sendNo) {
        this.sendNo = sendNo;
    }

    /**
     * 状態を取得する。
     * @return 状態
     */
    public Integer getStatus() {
        return status;
    }

    /**
     * 状態を設定する。
     * @param status 状態
     */
    public void setStatus(Integer status) {
        this.status = status;
    }

    /**
     * Fromアドレスを取得する。
     * @return Fromアドレス
     */
    public String getFromAddress() {
        return fromAddress;
    }

    /**
     * Fromアドレスを設定する。
     * @param fromAddress Fromアドレス
     */
    public void setFromAddress(String fromAddress) {
        this.fromAddress = fromAddress;
    }

    /**
     * Toアドレスを取得する。
     * @return Toアドレス
     */
    public String getToAddress() {
        return toAddress;
    }

    /**
     * Toアドレスを設定する。
     * @param toAddress Toアドレス
     */
    public void setToAddress(String toAddress) {
        this.toAddress = toAddress;
    }

    /**
     * CCアドレスを取得する。
     * @return CCアドレス
     */
    public String getCcAddress() {
        return ccAddress;
    }

    /**
     * CCアドレスを設定する。
     * @param ccAddress CCアドレス
     */
    public void setCcAddress(String ccAddress) {
        this.ccAddress = ccAddress;
    }

    /**
     * BCCアドレスを取得する。
     * @return BCCアドレス
     */
    public String getBccAddress() {
        return bccAddress;
    }

    /**
     * BCCアドレスを設定する。
     * @param bccAddress BCCアドレス
     */
    public void setBccAddress(String bccAddress) {
        this.bccAddress = bccAddress;
    }

    /**
     * 件名を取得する。
     * @return 件名
     */
    public String getTitle() {
        return title;
    }

    /**
     * 件名を設定する。
     * @param title 件名
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * 本文を取得する。
     * @return 本文
     */
    public String getBody() {
        return body;
    }

    /**
     * 本文を設定する。
     * @param body 本文
     */
    public void setBody(String body) {
        this.body = body;
    }

    /**
     * 実行者IDを取得する。
     * @return 実行者ID
     */
    public String getActionPersonId() {
        return actionPersonId;
    }

    /**
     * 実行者IDを設定する。
     * @param actionPersonId 実行者ID
     */
    public void setActionPersonId(String actionPersonId) {
        this.actionPersonId = actionPersonId;
    }

    /**
     * 機能種別を取得する。
     * @return 機能種別
     */
    public String getKind() {
        return kind;
    }

    /**
     * 機能種別を設定する。
     * @param kind 機能種別
     */
    public void setKind(String kind) {
        this.kind = kind;
    }

    /**
     * 実行結果メッセージを取得する。
     * @return 実行結果メッセージ
     */
    public String getMessage() {
        return message;
    }

    /**
     * 実行結果メッセージを設定する。
     * @param message 実行結果メッセージ
     */
    public void setMessage(String message) {
        this.message = message;
    }

    /**
     * 最終更新機能IDを取得する。
     * @return 最終更新機能ID
     */
    public String getUpdateFunctionId() {
        return updateFunctionId;
    }

    /**
     * 最終更新機能IDを設定する。
     * @param updateFunctionId 最終更新機能ID
     */
    public void setUpdateFunctionId(String updateFunctionId) {
        this.updateFunctionId = updateFunctionId;
    }

    /**
     * 最終更新日時を取得する。
     * @return 最終更新日時
     */
    public String getUpdateDate() {
        return updateDate;
    }

    /**
     * 最終更新日時を設定する。
     * @param updateDate 最終更新日時
     */
    public void setUpdateDate(String updateDate) {
        this.updateDate = updateDate;
    }

    /**
     * 予備文字列1を取得する。
     * @return 予備文字列1
     */
    public String getReservedString1() {
        return reservedString1;
    }

    /**
     * 予備文字列1を設定する。
     * @param reservedString1 予備文字列1
     */
    public void setReservedString1(String reservedString1) {
        this.reservedString1 = reservedString1;
    }

    /**
     * 予備文字列2を取得する。
     * @return 予備文字列2
     */
    public String getReservedString2() {
        return reservedString2;
    }

    /**
     * 予備文字列2を設定する。
     * @param reservedString2 予備文字列2
     */
    public void setReservedString2(String reservedString2) {
        this.reservedString2 = reservedString2;
    }

    /**
     * 予備文字列3を取得する。
     * @return 予備文字列3
     */
    public String getReservedString3() {
        return reservedString3;
    }

    /**
     * 予備文字列3を設定する。
     * @param reservedString3 予備文字列3
     */
    public void setReservedString3(String reservedString3) {
        this.reservedString3 = reservedString3;
    }

    /**
     * 予備文字列4を取得する。
     * @return 予備文字列4
     */
    public String getReservedString4() {
        return reservedString4;
    }

    /**
     * 予備文字列4を設定する。
     * @param reservedString4 予備文字列4
     */
    public void setReservedString4(String reservedString4) {
        this.reservedString4 = reservedString4;
    }

    /**
     * 予備文字列5を取得する。
     * @return 予備文字列5
     */
    public String getReservedString5() {
        return reservedString5;
    }

    /**
     * 予備文字列5を設定する。
     * @param reservedString5 予備文字列5
     */
    public void setReservedString5(String reservedString5) {
        this.reservedString5 = reservedString5;
    }

    /**
     * 予備文字列6を取得する。
     * @return 予備文字列6
     */
    public String getReservedString6() {
        return reservedString6;
    }

    /**
     * 予備文字列6を設定する。
     * @param reservedString6 予備文字列6
     */
    public void setReservedString6(String reservedString6) {
        this.reservedString6 = reservedString6;
    }

    /**
     * 予備文字列7を取得する。
     * @return 予備文字列7
     */
    public String getReservedString7() {
        return reservedString7;
    }

    /**
     * 予備文字列7を設定する。
     * @param reservedString7 予備文字列7
     */
    public void setReservedString7(String reservedString7) {
        this.reservedString7 = reservedString7;
    }

    /**
     * 予備文字列8を取得する。
     * @return 予備文字列8
     */
    public String getReservedString8() {
        return reservedString8;
    }

    /**
     * 予備文字列8を設定する。
     * @param reservedString8 予備文字列8
     */
    public void setReservedString8(String reservedString8) {
        this.reservedString8 = reservedString8;
    }

    /**
     * 予備文字列9を取得する。
     * @return 予備文字列9
     */
    public String getReservedString9() {
        return reservedString9;
    }

    /**
     * 予備文字列9を設定する。
     * @param reservedString9 予備文字列9
     */
    public void setReservedString9(String reservedString9) {
        this.reservedString9 = reservedString9;
    }

    /**
     * 予備文字列10を取得する。
     * @return 予備文字列10
     */
    public String getReservedString10() {
        return reservedString10;
    }

    /**
     * 予備文字列10を設定する。
     * @param reservedString10 予備文字列10
     */
    public void setReservedString10(String reservedString10) {
        this.reservedString10 = reservedString10;
    }

}

