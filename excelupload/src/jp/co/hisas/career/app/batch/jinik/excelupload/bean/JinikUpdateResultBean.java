package jp.co.hisas.career.app.batch.jinik.excelupload.bean;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class JinikUpdateResultBean {

	public int success = 0;
	public int warning = 0;

	private final String UPLOAD_WARN_FILE_CSV_TITLE = "GUID,名前,所属組織,内容";

	private List<JinikUpdateResultDto> results;
	
	/**
	 * エラーメッセージ
	 */
	private String errMsg = "";

	public String getErrMsg() {
		return errMsg;
	}

	public void setErrMsg( String errMsg ) {
		this.errMsg = errMsg;
	}

	public JinikUpdateResultBean() {
		results = new ArrayList<JinikUpdateResultDto>();
	}

	public void addLogMessage( String guid, String personName, String deptFullName, String message ) {

		JinikUpdateResultDto dto = new JinikUpdateResultDto();

		dto.setOwnGuid( guid );
		dto.setOwnPersonName( personName );
		dto.setOwnFullDeptName( deptFullName );
		dto.setMessage( message );

		results.add( dto );

		warning++;
	}

	public File createLogFile( String logFileDir, String logFileName ) throws IOException {

		File attachedFile = null;

		try {
			attachedFile = new File( logFileDir + logFileName );

			FileWriter fw = new FileWriter( attachedFile );

			// CSVヘッダー
			fw.write( UPLOAD_WARN_FILE_CSV_TITLE + "\r\n" );

			for ( JinikUpdateResultDto rec : results ) {
				fw.write( rec.getOwnGuid() + "," +  rec.getOwnPersonName()+ "," + rec.getOwnFullDeptName() + "," + rec.getMessage() + "\r\n" );
			}
			fw.close();
		} catch ( IOException e ) {
			throw e;
		}
		return attachedFile;
	}

	private class JinikUpdateResultDto {
		/**
		 * GUID
		 */
		private String ownGuid;

		/**
		 * 氏名
		 */
		private String ownPersonName;

		/**
		 * 所属名称
		 */
		private String ownFullDeptName;


		/**
		 * ログメッセージ
		 */
		private String message;

		/**
		 * GUIDを返す
		 *
		 * @return GUID
		 */
		public String getOwnGuid() {
			return ownGuid;
		}

		/**
		 * GUIDを設定する
		 *
		 * @param ownGuid GUID
		 */
		public void setOwnGuid( String ownGuid ) {
			this.ownGuid = ownGuid;
		}

		/**
		 * 氏名を取得する
		 *
		 * @return 氏名
		 */
		public String getOwnPersonName() {
			return ownPersonName;
		}

		/**
		 * 氏名を設定する
		 *
		 * @param ownPersonName 氏名
		 */
		public void setOwnPersonName( String ownPersonName ) {
			this.ownPersonName = ownPersonName;
		}

		/**
		 * 所属名称を返す
		 *
		 * @return 所属名称
		 */
		public String getOwnFullDeptName() {
			return ownFullDeptName;
		}

		/**
		 * 所属名称を設定する
		 *
		 * @param ownFullDeptName 所属名称
		 */
		public void setOwnFullDeptName( String ownFullDeptName ) {
			this.ownFullDeptName = ownFullDeptName;
		}

		/**
		 * メッセージを返す
		 *
		 * @return メッセージ
		 */
		public String getMessage() {
			return message;
		}

		/**
		 * メッセージを設定する
		 *
		 * @param message メッセージ
		 */
		public void setMessage( String message ) {
			this.message = message;
		}
	}
}
