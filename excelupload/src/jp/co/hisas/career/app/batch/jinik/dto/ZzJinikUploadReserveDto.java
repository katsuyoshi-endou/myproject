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

import java.io.File;
import java.io.Serializable;
import java.sql.Blob;

/**
 * 人材育成計画アップロード予約 Data Transfer Object。
*/
public class ZzJinikUploadReserveDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 完了
     */
    public static final String RSV_STATUS_FINISHED = "完了";

    /**
     * 処理中
     */
    public static final String RSV_STATUS_PROCESSING = "処理中";

    /**
     * 処理待ち
     */
    public static final String RSV_STATUS_PENDING = "処理待ち";

    /**
     * エラー
     */
    public static final String RSV_STATUS_EROOR = "エラー";

	/**
     * 予約SEQ
     */
    private Integer rsvSeq;
    /**
     * 予約者GUID
     */
    private String rsvGuid;
    /**
     * 予約日時
     */
    private String rsvDate;
    /**
     * 予約処理ステータス
     */
    private String rsvStatus;
    /**
     * アップロードファイル名
     */
    private String uploadFileName;
    /**
     * アップロードファイル形式
     */
    private String uploadContentType;
    /**
     * アップロードファイル
     */
    private File uploadFile;

    /**
     * アップロードファイル（BLOB形式）
     */
    private Blob uploadBlobFile;
    /**
     * 処理開始日時
     */
    private String updateStartDate;
    /**
     * 処理完了日時
     */
    private String updateFinishDate;

    /**
     * 予約SEQを取得する。
     * @return 予約SEQ
     */
    public Integer getRsvSeq() {
        return rsvSeq;
    }

    /**
     * 予約SEQを設定する。
     * @param rsvSeq 予約SEQ
     */
    public void setRsvSeq(Integer rsvSeq) {
        this.rsvSeq = rsvSeq;
    }

    /**
     * 予約者GUIDを取得する。
     * @return 予約者GUID
     */
    public String getRsvGuid() {
        return rsvGuid;
    }

    /**
     * 予約者GUIDを設定する。
     * @param rsvGuid 予約者GUID
     */
    public void setRsvGuid(String rsvGuid) {
        this.rsvGuid = rsvGuid;
    }

    /**
     * 予約日時を取得する。
     * @return 予約日時
     */
    public String getRsvDate() {
        return rsvDate;
    }

    /**
     * 予約日時を設定する。
     * @param rsvDate 予約日時
     */
    public void setRsvDate(String rsvDate) {
        this.rsvDate = rsvDate;
    }

    /**
     * 予約処理ステータスを取得する。
     * @return 予約処理ステータス
     */
    public String getRsvStatus() {
        return rsvStatus;
    }

    /**
     * 予約処理ステータスを設定する。
     * @param rsvStatus 予約処理ステータス
     */
    public void setRsvStatus(String rsvStatus) {
        this.rsvStatus = rsvStatus;
    }

    /**
     * アップロードファイル名を取得する。
     * @return アップロードファイル名
     */
    public String getUploadFileName() {
        return uploadFileName;
    }

    /**
     * アップロードファイル名を設定する。
     * @param uploadFileName アップロードファイル名
     */
    public void setUploadFileName(String uploadFileName) {
        this.uploadFileName = uploadFileName;
    }

    /**
     * アップロードファイル形式を取得する。
     * @return アップロードファイル形式
     */
    public String getUploadContentType() {
        return uploadContentType;
    }

    /**
     * アップロードファイル形式を設定する。
     * @param uploadContentType アップロードファイル形式
     */
    public void setUploadContentType(String uploadContentType) {
        this.uploadContentType = uploadContentType;
    }

    /**
     * アップロードファイルを取得する。
     * @return アップロードファイル
     */
    public File getUploadFile() {
        return uploadFile;
    }

    /**
     * アップロードファイルを設定する。
     * @param uploadFile アップロードファイル
     */
    public void setUploadFile(File uploadFile) {
        this.uploadFile = uploadFile;
    }

    /**
     * アップロードファイルを取得する。
     * @return アップロードファイル
     */
    public Blob getUploadBlobFile() {
        return uploadBlobFile;
    }

    /**
     * アップロードファイルを設定する。
     * @param uploadFile アップロードファイル
     */
    public void setUploadBlobFile(Blob uploadFile) {
        this.uploadBlobFile = uploadFile;
    }

    /**
     * 処理開始日時を取得する。
     * @return 処理開始日時
     */
    public String getUpdateStartDate() {
        return updateStartDate;
    }

    /**
     * 処理開始日時を設定する。
     * @param updateStartDate 処理開始日時
     */
    public void setUpdateStartDate(String updateStartDate) {
        this.updateStartDate = updateStartDate;
    }

    /**
     * 処理完了日時を取得する。
     * @return 処理完了日時
     */
    public String getUpdateFinishDate() {
        return updateFinishDate;
    }

    /**
     * 処理完了日時を設定する。
     * @param updateFinishDate 処理完了日時
     */
    public void setUpdateFinishDate(String updateFinishDate) {
        this.updateFinishDate = updateFinishDate;
    }

}

