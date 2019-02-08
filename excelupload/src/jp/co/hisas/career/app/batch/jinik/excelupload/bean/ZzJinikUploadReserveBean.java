package jp.co.hisas.career.app.batch.jinik.excelupload.bean;

import java.sql.Blob;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ZzJinikUploadReserveBean {
	/**
	 * 予約SEQ
	 */
	private int rsv_seq;
	
	/**
	 * 予約者GUID
	 */
	private String rsv_guid = null;
	
	/**
	 * 予約者メールアドレス
	 */
	private String rsv_mail_address = null;
	
	/**
	 * 予約日時
	 */
	private String rsv_date = null;
	
	/**
	 * 予約処理ステータス
	 */
	private String rsv_status = null;
	
	/**
	 * アップロードファイル名
	 */
	private String upload_file_name = null;
	
	/**
	 * アップロードファイル形式
	 */
	private String upload_content_type = null;
	
	/**
	 * アップロードファイル
	 */
	private Blob upload_file = null;

	/**
	 * 処理開始日時
	 */
	private String update_start_date = null;
	
	/**
	 * 処理完了日時
	 */
	private String update_finish_date = null;

	/**
	 * 予約SEQを返す
	 * 
	 * @return 予約SEQ
	 */
	public int getRsvSeq() {
		return rsv_seq;
	}

	/**
	 * 予約SEQを設定する
	 * 
	 * @param rsv_seq 予約SEQ
	 */
	public void setRsvSeq( int rsv_seq ) {
		this.rsv_seq = rsv_seq;
	}

	/**
	 * 予約者GUIDを返す
	 * 
	 * @return 予約者GUID
	 */
	public String getRsvGuid() {
		return rsv_guid;
	}

	/**
	 * 予約者GUID1を設定する
	 * 
	 * @param rsv_guid 予約者GUID
	 */
	public void setRsvGuid( String rsv_guid ) {
		this.rsv_guid = rsv_guid;
	}

	/**
	 * 予約者メールアドレスを返す
	 * 
	 * @return 予約者メールアドレス
	 */
	public String getRsvMailAddress() {
		return rsv_mail_address;
	}

	/**
	 * 予約者メールアドレスを設定する
	 * 
	 * @param rsv_mail_address 予約者メールアドレス
	 */
	public void setRsvMailAddress( String rsv_mail_address ) {
		this.rsv_mail_address = rsv_mail_address;
	}

	/**
	 * 予約日時を返す
	 * 
	 * @return 予約日時
	 */
	public String getRsvDate() {
		return rsv_date;
	}

	/**
	 * 予約日時を設定する
	 * 
	 * @param rsv_date 予約日時
	 */
	public void setRsvDate( String rsv_date ) {
		this.rsv_date = rsv_date;
	}

	/**
	 * 予約処理ステータスを返す
	 * 
	 * @return 予約処理ステータス
	 */
	public String getRsvStatus() {
		return rsv_status;
	}

	/**
	 * 予約処理ステータスを設定する
	 * 
	 * @param rsv_status 予約処理ステータス
	 */
	public void setRsvStatus( String rsv_status ) {
		this.rsv_status = rsv_status;
	}

	/**
	 * 	アップロードファイル名を返す
	 * 
	 * @return アップロードファイル名
	 */
	public String getUploadFileName() {
		return upload_file_name;
	}

	/**
	 * アップロードファイル名を設定する
	 * 
	 * @param upload_file_nme アップロードファイル名
	 */
	public void setUploadFileName( String upload_file_nme ) {
		this.upload_file_name = upload_file_nme;
	}

	/**
	 * 	アップロードファイル形式を返す
	 * 
	 * @return アップロードファイル形式
	 */
	public String getUploadContentType() {
		return upload_content_type;
	}

	/**
	 * アップロードファイル形式を設定する
	 * 
	 * @param upload_content_type アップロードファイル形式
	 */
	public void setUploadContentType( String upload_content_type ) {
		this.upload_content_type = upload_content_type;
	}

	/**
	 * アップロードファイルを返す
	 * 
	 * @return アップロードファイル
	 */
	public Blob getUploadFile() {
		return upload_file;
	}

	/**
	 * アップロードファイルを設定する
	 * 
	 * @param upload_file アップロードファイル
	 */
	public void setUploadFile( Blob upload_file ) {
		this.upload_file = upload_file;
	}

	/**
	 * 処理開始日時を返す
	 * 
	 * @return 処理開始日時
	 */
	public String getUpdateStartDate() {
		return update_start_date;
	}

	/**
	 * 処理開始日時を設定する
	 * 
	 * @param update_start_date 処理開始日時
	 */
	public void setUpdateStartDate( String update_start_date ) {
		this.update_start_date = update_start_date;
	}

	/**
	 * 処理完了日時を返す
	 * 
	 * @return 処理完了日時
	 */
	public String getUpdateFinishDate() {
		return update_finish_date;
	}

	/**
	 * 処理完了日時を返す
	 * 
	 * @param update_finish_date 処理完了日時
	 */
	public void setUpdateFinishDate( String update_finish_date ) {
		this.update_finish_date = update_finish_date;
	}

	public ZzJinikUploadReserveBean( ResultSet rs ) {
		try {
			this.rsv_seq = rs.getInt( "RsvSeq" );
			this.rsv_guid = rs.getString( "RsvGuid" );
			this.rsv_mail_address = rs.getString( "RsvMailAddress" );
			this.rsv_date = rs.getString( "RsvDate" );
			this.rsv_status = rs.getString( "RsvStatus" );
			this.upload_file_name = rs.getString( "UploadFileName" );
			this.upload_content_type = rs.getString( "UploadContentType" );
			this.upload_file = rs.getBlob( "UploadFile" );
			this.update_start_date = rs.getString( "UpdateStartDate" );
			this.update_finish_date = rs.getString( "UpdateFinishDate" );
		} catch ( SQLException e ) {
			
		}
	}
}
