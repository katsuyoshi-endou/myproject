package jp.co.hisas.career.app.batch.jinik.excelupload;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.log4j.Category;
import org.apache.log4j.PropertyConfigurator;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import jp.co.hisas.career.app.batch.jinik.dto.CstSheetExclusiveDto;
import jp.co.hisas.career.app.batch.jinik.dto.JinikSheetDto;
import jp.co.hisas.career.app.batch.jinik.dto.MailInfoDto;
import jp.co.hisas.career.app.batch.jinik.dto.VCsInfoAttrDto;
import jp.co.hisas.career.app.batch.jinik.dto.ZzJinikUploadReserveDto;
import jp.co.hisas.career.app.batch.jinik.excelupload.bean.JinikUpdateResultBean;
import jp.co.hisas.career.app.batch.jinik.excelupload.util.property.JinikUploadProperty;
import jp.co.hisas.career.app.batch.util.BatchConnectUtil;

public class JinikExcelFileUpdateBatch implements Job {

	private Connection conn = null;

	@SuppressWarnings("deprecation")
	private static Category catErr = Category.getInstance("BatchError");
	@SuppressWarnings("deprecation")
	private static Category catMsg = Category.getInstance("BatchMessage");

	private Map<String, String> propMap = null;
	
	// 読み込むシート名
	private final String READ_TARGET_SHEET_NAME = "人材育成計画";

	// 回答データの読込み行位置
	private final int CELL_READ_START_LINE = 16;

	// シートの年度を取得するためのセル位置（AM13）
	private final int CELL_SHEET_NENDO_ROW = 12;
	private final int CELL_SHEET_NENDO_COLUMN = 38;

	private final String MSG_READ_UPLOAD_FILE_ERR = "Excelアップロードファイルの読み込みに失敗しました。";
	private final String MSG_UPDATED_SHEET_NOT_EXIST = "更新対象のシートが存在しません。処理をスキップしました。";
	private final String MSG_UPDATED_BY_OTHERS = "他者による更新が行われていました。処理をスキップしました。";
	private final String MSG_NOT_TARGET_STATUS = "登録可能なシートのステータスではありません。処理をスキップしました。";

	private final String ATTACHED_FILE_TEMP_DIR = "./temp";

	private final String STATUS_00_NEW = "計画入力中";
	private final String STATUS_02_CHK_SIN = "進捗状況確認中";
	
    private static final String PROP_LOG4J_PATH = "properties\\log4j.properties";
    private static final String PROP_BATCH_PATH = "properties\\jinik_batch.properties";

	@Override
	public void execute( JobExecutionContext arg0 ) throws JobExecutionException {
		
		final JinikExcelFileUpdateBatch instance = new JinikExcelFileUpdateBatch();

		try {
			SimpleDateFormat fmt = new SimpleDateFormat("yyyy年MM月dd日 E曜日 HH時mm分ss秒");
			System.out.println( "取込みバッチが起動しました。 >> " + fmt.format( new Date()));

			instance.execute();

		} catch ( Exception e ) {
			catErr.error( "エラーが発生したため、ジョブスケジュールを中断します。", e );
			System.exit( -1 );
		}
	}

	private void execute() throws SQLException, Exception {

		try {
			//ログ設定ファイルの読込み
			PropertyConfigurator.configure( PROP_LOG4J_PATH );

			propMap = getBatchProperties();

			// 予約者ID
			DateFormat df = new SimpleDateFormat( "yyyyMMddHH24mmss" );
			df.format( new Date( Calendar.getInstance().getTimeInMillis() ) );
			String RSV_ID = "EXCEL_UPLOAD" + df.format( new Date( Calendar.getInstance().getTimeInMillis()));

			try {
				this.conn = BatchConnectUtil.getConnetcion( propMap.get( "jdbc.driver" ), propMap.get( "jdbc.URL" ), propMap.get( "jdbc.user" ), propMap.get( "jdbc.password" ));
			} catch ( SQLException e ) {
				catErr.error( "データベースとの接続に失敗しました。", e );
				throw e;
			}

			conn.setAutoCommit( false );

			ZzJinikUploadReserveDto dto = null;

			try {
				// 処理開始前の予約ジョブに関するトランザクション処理
				dto = execReserveJobTransaction();
			} catch ( SQLException e ) {
				throw e;
			}

			JinikUpdateResultBean rsltBean = null;

			if ( dto != null ) {
				catMsg.info( "アップロードファイル取込処理開始 予約SEQ >> " + String.valueOf( dto.getRsvSeq()));
				try {
					// 処理待ちジョブのアップロードファイルをDBに格納
					rsltBean = execRsvFileUpdateTransaction( RSV_ID, dto );

					// CST_SHEET_FILL_AUTOの反映
					execUpdateFillAutoTransaction( RSV_ID );
				} catch ( Exception e ) {
					// 更新処理でエラーの時、メールを送信
					execSendBatchMailTransaction( dto, rsltBean, "ERROR" );
					throw e;
				}
				execSendBatchMailTransaction( dto, rsltBean, "" );

				catMsg.info( "アップロードファイル取込処理終了 予約SEQ >> " + String.valueOf( dto.getRsvSeq()));
			}
		} catch ( SQLException | IOException e ) {
			throw e;
		} catch ( Exception e ) {
			catErr.error( "予期せぬエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeconnection( conn );
		}
	}

	/**
	 * 処理開始前のジョブに関するトランザクション処理
	 *
	 * @return
	 * @throws SQLException
	 */
	private ZzJinikUploadReserveDto execReserveJobTransaction() throws SQLException {

		ZzJinikUploadReserveDto job = null;

		try {
			// 一定時間を超えて稼働しているジョブを検索し、"エラー"にマークする
			updateUnderProcJobToErrJob( conn );

			// 現在処理中のジョブを取得
			int procJob = getUnderProcessingJobCount( conn );
			if ( procJob > 0 ) {
				return null;
			}

			// 処理待ちのジョブを取得
			List<ZzJinikUploadReserveDto> jobs = getJobsByReserveStatus( ZzJinikUploadReserveDto.RSV_STATUS_PENDING );
			if ( jobs.size() > 0 ) {
				job = jobs.get( 0 );

				// 取得した先頭の処理待ちジョブに処理開始の情報を書き込み
				updateUploadReserveStatus( job.getRsvSeq(), ZzJinikUploadReserveDto.RSV_STATUS_PROCESSING );
			}
			BatchConnectUtil.commitConnection(conn);
		} catch ( SQLException e ) {
			BatchConnectUtil.rollbackConnection( conn );
			throw e;
		}
		return job;
	}

	private JinikUpdateResultBean execRsvFileUpdateTransaction( String rsvId, ZzJinikUploadReserveDto rsvDto) throws SQLException {

		// アップロード処理結果
		JinikUpdateResultBean rsltBean = new JinikUpdateResultBean();

		try {
			// Excelシート回答情報を取得する
			List<JinikSheetDto> jinikSheetList = readExcelBinaryObject( rsvDto );
			if ( jinikSheetList == null ) {
				// アップロードファイル読み込みエラー
				rsltBean.setErrMsg( MSG_READ_UPLOAD_FILE_ERR );
				return rsltBean;
			}
	
			for ( JinikSheetDto jinikSheetDto : jinikSheetList ) {
				// 更新対象シートの情報を取得する
				VCsInfoAttrDto csInfoAttr = getVCsInfoAttr( jinikSheetDto );
				if ( csInfoAttr == null ) {
					// 更新対象のシートが存在しません。処理をスキップしました。
					rsltBean.addLogMessage( jinikSheetDto.getOwnGuid(), jinikSheetDto.getOwnPersonName(), jinikSheetDto.getOwnDeptFullName(), MSG_UPDATED_SHEET_NOT_EXIST );
					continue;
				}
	
				// シートIDをセット
				jinikSheetDto.setSheetId( csInfoAttr.getSheetId());
	
				// ステータスチェック
				if (( STATUS_00_NEW.equals( jinikSheetDto.getSheetStatus()) || STATUS_02_CHK_SIN.equals( jinikSheetDto.getSheetStatus())) && jinikSheetDto.getSheetStatus().equals( csInfoAttr.getStatusNm())) {
					// 排他チェック？
					CstSheetExclusiveDto execDto = new CstSheetExclusiveDto();
					execDto.setSheetId( csInfoAttr.getSheetId());
					execDto.setExclusiveKey( csInfoAttr.getExclusiveKey());
	
					if ( !checkSheetExclusiveKey( execDto, conn )) {
						// 他者による更新が行われていました。処理をスキップしました。
						rsltBean.addLogMessage( jinikSheetDto.getOwnGuid(), jinikSheetDto.getOwnPersonName(), jinikSheetDto.getOwnDeptFullName(), MSG_UPDATED_BY_OTHERS );
						continue;
					}
	
					// 排他キーの更新
					updateExclusiveKey( execDto, conn );
	
					// ステータスが"計画入力中"のシートをCS_RSV_DSTRBTに登録
					if ( STATUS_00_NEW.equals( jinikSheetDto.getSheetStatus())) {
						insertSheetReserve( csInfoAttr, rsvId, conn );
					}
	
					// CSTシート回答の更新
					updateSheetFill( jinikSheetDto, conn );
	
					rsltBean.success++;
	
				} else {
					// 登録可能なシートのステータスではありません。処理をスキップしました。
					rsltBean.addLogMessage( jinikSheetDto.getOwnGuid(), jinikSheetDto.getOwnPersonName(), jinikSheetDto.getOwnDeptFullName(), MSG_NOT_TARGET_STATUS );
					continue;
				}
			}
			BatchConnectUtil.commitConnection( this.conn );
		} catch ( SQLException e ) {
			BatchConnectUtil.rollbackConnection( this.conn );
			throw e;
		} catch ( Exception e ) {
			BatchConnectUtil.rollbackConnection( this.conn );
			throw e;
		}
		return rsltBean;
	}

	private void execUpdateFillAutoTransaction( String rsvId ) throws SQLException {
		try {
			// FILL_AUTOの物理テーブルへの反映
			updateCstSheetFillAuto( rsvId );

			// シート配布予約データの削除
			deleteSheetReserve( rsvId );

			BatchConnectUtil.commitConnection( this.conn );
		} catch ( SQLException e ) {
			BatchConnectUtil.rollbackConnection( this.conn );
			throw e;
		}
	}

	private void execSendBatchMailTransaction( ZzJinikUploadReserveDto dto, JinikUpdateResultBean rsltBean, String mailType ) throws SQLException, IOException {

		if ( mailType == "" || mailType == null ) {
			mailType = rsltBean.warning == 0 ? "SUCCESS" : "WARN";
		}
		
		if ( rsltBean.getErrMsg() != "" || rsltBean.getErrMsg().length() != 0 ) {
			mailType = "ERROR";
		}

		// アップロード更新処理完了情報の書き込み
		updateUploadReserveStatus( dto.getRsvSeq(), ZzJinikUploadReserveDto.RSV_STATUS_FINISHED );

		HashMap<String, String> userinfo = getCaRegist( dto.getRsvGuid());
		String mailToAddr = userinfo.get( "MAIL_ADDRESS" );
		if ( mailToAddr == null ) {
			catErr.error( "送信先メールアドレスが取得できません。" );
		}

		// メール送信情報（タイトルと本文）の取得
		String[] contents = getMailContents( mailType, conn );

		// メールの種別により本文の置き換えを行う
		HashMap<String, String> replaceMap = new HashMap<String, String>();
		if ( "SUCCESS".equals( mailType )) {
			replaceMap.put( "upload_num", String.valueOf( rsltBean.success ));
		}
		replaceMap.put( "sender_name", userinfo.get( "PERSON_NAME" ));
		replaceMap.put( "file_name", dto.getUploadFileName());

		String mailBody = contents[1];

		for ( Map.Entry<String, String> entry : replaceMap.entrySet()) {
			String key = entry.getKey();
			String val = entry.getValue();
			// #{key} -> val
			mailBody = mailBody.replaceAll( "\\#\\{" + key + "\\}", val );
		}

		// メール送信情報の登録
		MailInfoDto mailDto = new MailInfoDto();
		mailDto.setFromAddress( propMap.get( "BATCH_MAIL_FROM" ) );
		mailDto.setToAddress( userinfo.get( "MAIL_ADDRESS" ));
		mailDto.setTitle( contents[0] );
		mailDto.setBody( mailBody );

		int sendNo = insertMailInfo( mailDto );

		insertMailAttachment( sendNo, rsltBean );
	}

	private MailInfoDto makeMailInfoDto( String mailType, ZzJinikUploadReserveDto rsvDto, Connection conn ) throws SQLException {
		MailInfoDto dto = new MailInfoDto();

		try {
			// メール送信情報（タイトルと本文）の取得
			String[] contents = getMailContents( mailType, conn );
			
			// 予約者の情報を取得
			HashMap<String, String> userinfo = getCaRegist( rsvDto.getRsvGuid());
			
			String mailBody = contents[1];
			
			mailBody = mailBody.replaceAll( "\\#\\{sender_name\\}", userinfo.get( "PERSON_NAME" ) == null ? "" : userinfo.get( "PERSON_NAME" ));
			mailBody = mailBody.replaceAll( "\\#\\{file_name\\}", rsvDto.getUploadFileName());
			
			dto.setFromAddress( propMap.get( "BATCH_MAIL_FROM" ) );
			dto.setToAddress( userinfo.get( "MAIL_ADDRESS" ));
			dto.setTitle( contents[0] );
			dto.setBody( mailBody );

		} catch ( SQLException e ) {
			throw e;
		}
		return dto;
	}
	
	/**
	 * 一定時間を経過した"処理中"のジョブを、"エラー"ジョブに更新する
	 *
	 * @param conn Database Connection
	 * @throws SQLException
	 */
	private void updateUnderProcJobToErrJob( Connection conn ) throws SQLException {

		PreparedStatement stmt = null;
		PreparedStatement updStmt = null;
		ResultSet rs = null;

		try {
			List<ZzJinikUploadReserveDto> list = new ArrayList<ZzJinikUploadReserveDto>();

			String rsvSeq = "";
			
			StringBuffer sb = new StringBuffer();
			sb.append( "SELECT RSV_SEQ, RSV_GUID, RSV_STATUS, UPLOAD_FILE_NAME FROM ZZ_JINIK_UPLOAD_RESERVE " );
			sb.append( "WHERE RSV_STATUS = '" + ZzJinikUploadReserveDto.RSV_STATUS_PROCESSING + "' " );
			sb.append( "AND UPDATE_START_DATE + " ); 
			sb.append( "( " );
			sb.append( "    SELECT TO_NUMBER(PARAM_VALUE) FROM CCP_PARAM WHERE PARAM_BUNRUI_NM = 'Plan' AND PARAM_ID = 'JINIK_ELAPSE_TIME_TO_ERROR' " );
			sb.append( ") / 1440 < SYSDATE " );
			sb.append( "ORDER BY RSV_SEQ" );
			
			stmt = conn.prepareStatement( sb.toString());

			rs = stmt.executeQuery();
			while ( rs.next()) {
				ZzJinikUploadReserveDto dto = new ZzJinikUploadReserveDto();
				
				dto.setRsvSeq( rs.getInt( "RSV_SEQ" ));
				dto.setRsvGuid( rs.getString( "RSV_GUID" ));
				dto.setRsvStatus( rs.getString( "RSV_STATUS" ));
				dto.setUploadFileName( rs.getString( "UPLOAD_FILE_NAME" ));
				
				list.add( dto );
			}
			
			if ( list.size() > 0 ) {
				sb.setLength( 0 );
				sb.append( "UPDATE ZZ_JINIK_UPLOAD_RESERVE ");
				sb.append( "SET RSV_STATUS = '" + ZzJinikUploadReserveDto.RSV_STATUS_EROOR + "', " );
				sb.append( "UPDATE_FINISH_DATE = SYSDATE " );
				sb.append( "WHERE RSV_STATUS = '" + ZzJinikUploadReserveDto.RSV_STATUS_PROCESSING + "' ");
				sb.append( "AND UPDATE_START_DATE +  ");
				sb.append( "( ");
				sb.append( "    SELECT TO_NUMBER(PARAM_VALUE) FROM CCP_PARAM WHERE PARAM_BUNRUI_NM = 'Plan' AND PARAM_ID = 'JINIK_ELAPSE_TIME_TO_ERROR' ");
				sb.append( ") / 1440 < SYSDATE");
	
				updStmt = conn.prepareStatement( sb.toString());

				updStmt.executeUpdate();
				
				for ( ZzJinikUploadReserveDto dto : list ) {
					MailInfoDto mailInfo = makeMailInfoDto( "ERROR", dto, conn );
					
					insertMailInfo( mailInfo );
					
					rsvSeq = rsvSeq + dto.getRsvSeq() + ", ";
				}
				
				catMsg.info( "一定時間経過したジョブを'エラー'に更新しました。 予約SEQ >> " + rsvSeq );
			}
		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, rs );
		}
	}

	/**
	 * 現在実行中のジョブを検索し、検索結果（件数）を返す
	 *
	 * @param conn Database Connection
	 * @return 実行中ジョブの件数
	 */
	private int getUnderProcessingJobCount( Connection conn ) throws SQLException {

		int cnt = 0;

		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			String sql = "SELECT COUNT(*) FROM ZZ_JINIK_UPLOAD_RESERVE WHERE RSV_STATUS = '処理中'";

			stmt = conn.prepareStatement( sql );

			rs = stmt.executeQuery();
			if ( rs.next()) {
				cnt = rs.getInt( 1 );
			}
			return cnt;
		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, rs );
		}
	}

	private List<ZzJinikUploadReserveDto> getJobsByReserveStatus( String status ) throws SQLException {

		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		List<ZzJinikUploadReserveDto> list = new ArrayList<ZzJinikUploadReserveDto>();
		
		try {
			StringBuilder sb = new StringBuilder();
			
			sb.append( "SELECT RSV_SEQ, RSV_GUID, RSV_DATE, RSV_STATUS, UPLOAD_FILE_NAME, UPLOAD_CONTENT_TYPE, UPLOAD_FILE, UPDATE_START_DATE, UPDATE_FINISH_DATE FROM  ZZ_JINIK_UPLOAD_RESERVE" );
			sb.append( " WHERE RSV_STATUS = ? " );
			sb.append( " ORDER BY RSV_SEQ" );
			
			stmt = conn.prepareStatement( sb.toString());
			stmt.setString( 1, status );
			
			rs = stmt.executeQuery();
			
			while ( rs.next()) {
				ZzJinikUploadReserveDto dto = new ZzJinikUploadReserveDto();
				
				dto.setRsvSeq( rs.getInt( "RSV_SEQ" ));
				dto.setRsvGuid( rs.getString( "RSV_GUID" ));
				dto.setRsvDate( rs.getString( "RSV_DATE" ));
				dto.setRsvStatus( rs.getString( "RSV_STATUS" ));
				dto.setUploadFileName( rs.getString( "UPLOAD_FILE_NAME" ));
				dto.setUploadContentType( rs.getString( "UPLOAD_CONTENT_TYPE" ));
				dto.setUploadBlobFile( rs.getBlob( "UPLOAD_FILE" ));
				dto.setUpdateStartDate( rs.getString( "UPDATE_START_DATE" ));
				dto.setUpdateFinishDate( rs.getString( "UPDATE_FINISH_DATE" ));
				
				list.add( dto );
			}
		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, rs );
		}
		return list;
	}

	/**
	 * 指定された予約SEQに一致する予約情報のステータスを更新する。
	 * 　更新時にステータスに対応した日付項目も更新する。
	 *
	 * @param rsvSeq 予約SEQ
	 * @param status 変更する予約ステータス
	 * @param conn コネクション
	 * @throws SQLException
	 */
	private void updateUploadReserveStatus( int rsvSeq, String status ) throws SQLException {

		PreparedStatement stmt = null;

		try {
			StringBuilder sb = new StringBuilder();

			sb.append( "UPDATE ZZ_JINIK_UPLOAD_RESERVE " );
			sb.append( "SET RSV_STATUS = ? " );

			if ( ZzJinikUploadReserveDto.RSV_STATUS_FINISHED.equals( status )) {
				sb.append( ", UPDATE_FINISH_DATE = SYSDATE " );
			} else if ( ZzJinikUploadReserveDto.RSV_STATUS_PROCESSING.equals( status )) {
				sb.append( ", UPDATE_START_DATE = SYSDATE " );
			}

			sb.append( "WHERE RSV_SEQ = ?" );

			stmt = conn.prepareStatement( sb.toString());
			stmt.setString( 1, status );
			stmt.setInt( 2, rsvSeq );

			stmt.executeUpdate();

		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, null );
		}
	}

	private List<JinikSheetDto> readExcelBinaryObject(ZzJinikUploadReserveDto uploadBean) {

		List<JinikSheetDto> sheetBeans = null;

		try {
			Blob blob = uploadBean.getUploadBlobFile();
			InputStream is = blob.getBinaryStream();
	
			XSSFWorkbook xssfwkbk = (XSSFWorkbook)WorkbookFactory.create(is);
	
			XSSFSheet sheet = xssfwkbk.getSheet( READ_TARGET_SHEET_NAME );
			if ( sheet != null ) {
				sheetBeans = new ArrayList<JinikSheetDto>();
	
				// セル"AM13"の年度を読み取ってシートの年度として、運用コードを生成する
				String operCd = getStringRangeValue( sheet.getRow( CELL_SHEET_NENDO_ROW ).getCell( CELL_SHEET_NENDO_COLUMN ));
				if ( operCd == "" ) {
					return sheetBeans;
				}
	
				operCd = operCd.replace( "年度", "T-jinik" );
	
				for ( int i = CELL_READ_START_LINE; i <= sheet.getLastRowNum(); i++ ) {
					XSSFRow row = sheet.getRow( i );
	
					// getLaastRowNumよりも少ない場合があるので、ステータス欄が空であればループを抜ける
					if ( getStringValue( row.getCell( 1 )) == "" ) {
						break;
					}
	
					JinikSheetDto bean = new JinikSheetDto();
	
					bean.setOperationCd( operCd );
					for ( int j = 0; j < JinikUploadProperty.fillMap.length; j++ ) {
						String value = getStringValue( row.getCell( Integer.valueOf( JinikUploadProperty.fillMap[j][0] )));

						String fillID = JinikUploadProperty.fillMap[j][1];
						
						switch ( fillID ) {
						case "STATUS_NM" :
							bean.setSheetStatus( value );
							break;
						case "OWN_GUID" :
							bean.setOwnGuid( value );
							break;
						case "OWN_PERSON_NAME" :
							bean.setOwnPersonName( value );
							break;
						case "CMPA_CD" :
							bean.setOwnCmpaCd( value );
							break;
						case "DEPT_FULL_NAME" :
							bean.setOwnDeptFullName( value );
							break;
						default :
							if ( fillID.startsWith( "jinik_kaito_ido_0" ) || fillID.startsWith( "jinik_kaito_taishoku_0" )) {
								value = "○".equals( value ) ? "on" : "off";
							}
							bean.putFillData( fillID, value );
						}
					}
					sheetBeans.add( bean );
				}
			} else {
				// 対象のシートが読み込めなかったとき
	
			}
		} catch ( SQLException | InvalidFormatException | IOException e ) {
			catErr.error( MSG_READ_UPLOAD_FILE_ERR, e );
			return null;
		} catch ( Exception e ) {
			catErr.error( "致命的なエラーが発生しました。", e );
			return null;
		}
		return sheetBeans;
	}

	private static String getStringValue( XSSFCell cell ) {
		String ret = "";

		if ( cell == null ) {
			return "";
		}
		switch ( cell.getCellType()) {
		case XSSFCell.CELL_TYPE_NUMERIC:
			ret = Integer.toString( Integer.valueOf(( int )cell.getNumericCellValue()));
			break;
		case XSSFCell.CELL_TYPE_STRING:
			ret = cell.getStringCellValue();
			break;
		case XSSFCell.CELL_TYPE_BOOLEAN:
			ret = Boolean.toString( cell.getBooleanCellValue());
			break;
		}
		return ret;
	}

	private static String getStringRangeValue( XSSFCell cell ) {
		String ret = "";
		int rowIndex = cell.getRowIndex();
		int columnIndex = cell.getColumnIndex();

		XSSFSheet sheet = cell.getSheet();
		int size = sheet.getNumMergedRegions();
		for ( int i= 0; i < size; i++ ) {
			CellRangeAddress range = sheet.getMergedRegion( i );
			if ( range.isInRange( rowIndex, columnIndex )) {
				XSSFCell firstCell = getCell( sheet, range.getFirstRow(), range.getFirstColumn());
				ret = getStringValue( firstCell );
				break;
			}
		}
		return ret;
	}

	private static XSSFCell getCell( XSSFSheet sheet, int rowIndex, int columnIndex ) {
		XSSFRow row = sheet.getRow( rowIndex );
		if ( row != null ) {
			XSSFCell cell = row.getCell( columnIndex );
			return cell;
		}
		return null;
	}

	private VCsInfoAttrDto getVCsInfoAttr( JinikSheetDto dto ) throws SQLException {

		PreparedStatement stmt = null;
		ResultSet rs = null;
		VCsInfoAttrDto attrDto = null;

		try {
			StringBuilder sb = new StringBuilder();

			sb.append( "SELECT SHEET_ID, PARTY, OPERATION_CD, FORM_CD, OWN_GUID, STATUS_CD, STATUS_NM, FLOW_CD, EXCLUSIVE_KEY FROM V_CS_INFO_ATTR CS " );
			sb.append( "WHERE CS.PARTY = ? " );
			sb.append( "AND CS.OPERATION_CD = ? " );
			sb.append( "AND CS.FORM_CD = ? " );
			sb.append( "AND CS.OWN_GUID = ? " );

			stmt = conn.prepareStatement( sb.toString());

			stmt.setString( 1, "PANA" );
			stmt.setString( 2, dto.getOperationCd());
			stmt.setString( 3, "frm-jinik" );
			stmt.setString( 4, dto.getOwnGuid());

			rs = stmt.executeQuery();

			if ( rs.next()) {
				attrDto = new VCsInfoAttrDto();

				attrDto.setSheetId( rs.getString( "SHEET_ID" ));
				attrDto.setParty( rs.getString( "PARTY" ));
				attrDto.setOperationCd( rs.getString( "OPERATION_CD" ));
				attrDto.setFormCd( rs.getString( "FORM_CD" ));
				attrDto.setOwnGuid( rs.getString( "OWN_GUID" ));
				attrDto.setParty( rs.getString( "PARTY" ));
				attrDto.setStatusCd( rs.getString( "STATUS_CD" ));
				attrDto.setStatusNm( rs.getString( "STATUS_NM" ));
				attrDto.setFlowCd( rs.getString( "FLOW_CD" ));
				attrDto.setExclusiveKey( rs.getInt( "EXCLUSIVE_KEY" ));
			}
		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, rs );
		}
		return attrDto;
	}

	private boolean checkSheetExclusiveKey( CstSheetExclusiveDto curSheetDto, Connection conn ) throws SQLException {

		CstSheetExclusiveDto dbSheetDto = getCstSheetExclusiveKey( curSheetDto.getSheetId(), conn );
		if ( curSheetDto != null && dbSheetDto != null ) {
			String curSheetId = curSheetDto.getSheetId();
			String dbSheetId = dbSheetDto.getSheetId();
			if ( dbSheetId.equals( curSheetId )) {
				Integer curSheetExecKey = curSheetDto.getExclusiveKey();
				Integer dbSheetExecKey = dbSheetDto.getExclusiveKey();
				if ( dbSheetExecKey.equals( curSheetExecKey )) {
					return true;
				}
			}
		}
		return false;
	}

	private CstSheetExclusiveDto getCstSheetExclusiveKey( String sheetId, Connection conn ) throws SQLException {

		PreparedStatement stmt = null;
		ResultSet rs = null;
		CstSheetExclusiveDto dto = null;

		try {
			String sql = "SELECT SHEET_ID, EXCLUSIVE_KEY FROM CST_SHEET_EXCLUSIVE WHERE SHEET_ID = ?";

			stmt = conn.prepareStatement( sql );
			stmt.setString( 1, sheetId );

			rs = stmt.executeQuery();
			if ( rs.next()) {
				dto = new CstSheetExclusiveDto();

				dto.setSheetId( rs.getString( "SHEET_ID" ));
				dto.setExclusiveKey( rs.getInt( "EXCLUSIVE_KEY" ));
			}

			if ( dto == null ) {
				dto = new CstSheetExclusiveDto();

				dto.setSheetId( sheetId );
				dto.setExclusiveKey( 0 );

				insertExclusiveKey( dto, conn );
			}
		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, rs );
		}
		return dto;
	}

	private void insertExclusiveKey( CstSheetExclusiveDto insDto, Connection conn ) throws SQLException {

		PreparedStatement stmt = null;

		try {
			String sql = "INSERT INTO CST_SHEET_EXCLUSIVE( SHEET_ID, EXCLUSIVE_KEY ) VALUES( ?, ? )";

			stmt = conn.prepareStatement( sql );

			stmt.setString( 1, insDto.getSheetId());
			stmt.setInt( 2, insDto.getExclusiveKey());

			stmt.executeUpdate();

		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, null );
		}
	}

	private void updateExclusiveKey( CstSheetExclusiveDto dto, Connection conn ) throws SQLException {

		PreparedStatement stmt = null;

		try {
			String sql = "UPDATE CST_SHEET_EXCLUSIVE SET EXCLUSIVE_KEY = ? WHERE SHEET_ID = ?";

			stmt = conn.prepareStatement( sql );

			stmt.setInt( 1, dto.getExclusiveKey() + 1 );
			stmt.setString( 2, dto.getSheetId());

			stmt.executeUpdate();
		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, null );
		}
	}

	private void insertSheetReserve( VCsInfoAttrDto dto, String rsvId, Connection conn ) throws SQLException {

		PreparedStatement stmt = null;

		try {
			String sql = "INSERT INTO CS_RSV_DSTRBT( RSV_ID, RSV_USER, SHEET_ID, PARTY, OPERATION_CD, FORM_CD, GUID, STATUS_CD, FLOW_PTN ) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ? )";

			stmt = conn.prepareStatement( sql );

			stmt.setString( 1, rsvId );
			stmt.setString( 2, rsvId );
			stmt.setString( 3, dto.getSheetId());
			stmt.setString( 4, dto.getParty());
			stmt.setString( 5, dto.getOperationCd());
			stmt.setString( 6, dto.getFormCd());
			stmt.setString( 7, dto.getOwnGuid());
			stmt.setString( 8, dto.getStatusCd());
			stmt.setString( 9, dto.getFlowCd());

			stmt.executeUpdate();

		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, null );
		}
	}

	private void deleteSheetReserve( String rsvId ) throws SQLException {

		PreparedStatement stmt = null;

		try {
			String sql = "DELETE FROM CS_RSV_DSTRBT WHERE RSV_ID = ?";

			stmt = conn.prepareStatement( sql );

			stmt.setString( 1, rsvId );

			stmt.executeUpdate();
		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, null );
		}
	}

	private void updateSheetFill( JinikSheetDto bean, Connection conn ) throws SQLException {

		// ステータスにより処理を振り分ける
		if ( STATUS_00_NEW.equals( bean.getSheetStatus() )) {
			// 異動実績以外を更新
			for ( String key : bean.getFillDataMap().keySet()) {
				if ( !"jinik_kaito_ido_month".equals( key ) && !"jinik_kaito_ido_place".equals( key )) {
					String content = bean.getFillDataMap().get( key );

					deleteCstSheetFill( bean.getSheetId(), key, conn );

					insertCstSheetFill( bean.getSheetId(), key, content, conn );
				}
			}

		} else if ( STATUS_02_CHK_SIN.equals( bean.getSheetStatus())) {
			// 異動実績のみ更新
			String[] idoJisseki = { "jinik_kaito_ido_month", "jinik_kaito_ido_place" };

			for ( String item : idoJisseki ) {
				String content = bean.getFillDataMap().get( item );

				deleteCstSheetFill( bean.getSheetId(), item, conn );

				insertCstSheetFill( bean.getSheetId(), item, content, conn );
			}
		}
	}

	private void deleteCstSheetFill( String sheetId, String fillId, Connection conn ) throws SQLException {

		PreparedStatement stmt = null;

		try {
			String sql = "DELETE FROM CST_SHEET_FILL WHERE SHEET_ID = ? AND FILL_ID = ?";

			stmt = conn.prepareStatement( sql );

			stmt.setString( 1, sheetId );
			stmt.setString( 2, fillId );

			stmt.executeUpdate();

		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, null );
		}
	}

	private void insertCstSheetFill( String sheetId, String fillId, String fillContent, Connection conn ) throws SQLException {

		PreparedStatement stmt = null;

		try {

			String sql = "INSERT INTO CST_SHEET_FILL( SHEET_ID, FILL_ID, FILL_CONTENT ) VALUES( ?, ?, ? )";

			stmt = conn.prepareStatement( sql );

			stmt.setString( 1, sheetId );
			stmt.setString( 2, fillId );
			stmt.setString( 3, fillContent );

			stmt.executeUpdate();
		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, null );
		}
	}

	private void updateCstSheetFillAuto( String rsvId ) throws SQLException {

		PreparedStatement delStmt = null;
		PreparedStatement insStmt = null;

		try {
			String autoFillIds = getJinikFillAutoId();
			
			StringBuilder sb = new StringBuilder();
			//
			sb.append( "DELETE FROM CST_SHEET_FILL_AUTO CSF " );
			sb.append( "WHERE EXISTS " );
			sb.append( "( " );
			sb.append( "    SELECT SHEET_ID FROM CS_RSV_DSTRBT CRD WHERE CSF.SHEET_ID = CRD.SHEET_ID AND CRD.RSV_ID = ?" );
			sb.append( ") " );

			if ( autoFillIds != "" ) {
				sb.append( "AND CSF.FILL_ID IN ( " + autoFillIds + " )" );
			}
			
			delStmt = conn.prepareStatement( sb.toString());
			delStmt.setString( 1, rsvId );

			delStmt.executeUpdate();

			sb.setLength( 0 );

			sb.append( "INSERT INTO CST_SHEET_FILL_AUTO( SHEET_ID, FILL_ID, FILL_CONTENT ) " );
			sb.append( "SELECT V.SHEET_ID, V.FILL_ID, V.FILL_CONTENT FROM V_CST_SHEET_FILL_AUTO V " );
			sb.append( "INNER JOIN " );
			sb.append( "( " );
			sb.append( "    SELECT SHEET_ID FROM CS_RSV_DSTRBT WHERE RSV_ID = ? " );
			sb.append( ") RSV ON RSV.SHEET_ID = V.SHEET_ID " );

			if ( autoFillIds != "" ) {
				sb.append( "AND V.FILL_ID IN ( " + autoFillIds + " )" );
			}

			insStmt = conn.prepareStatement( sb.toString());
			insStmt.setString( 1, rsvId );

			insStmt.executeUpdate();

		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, insStmt, null );
			BatchConnectUtil.closeConnection( null, delStmt, null );
		}
	}

	/**
	 *
	 *
	 * @param mailType
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	private String[] getMailContents( String mailType, Connection conn ) throws SQLException {

		PreparedStatement stmt = null;
		ResultSet rs = null;

		String contents[] = new String[2];

		try {
			StringBuilder sb = new StringBuilder();

			sb.append( "SELECT " );
			sb.append( "    MAIL.UP_RESULT, " );
			sb.append( "    MAX( CASE WHEN MAIL.PARAM_ID LIKE 'MailSubject_JINIK_Excel%' THEN MAIL.PARAM_VALUE ELSE NULL END ) AS MAIL_TITLE, " );
			sb.append( "    MAX( CASE WHEN MAIL.PARAM_ID LIKE 'MailBody_JINIK_Excel%' THEN MAIL.PARAM_VALUE ELSE NULL END ) AS MAIL_BODY " );
			sb.append( "FROM " );
			sb.append( "( " );
			sb.append( "    SELECT " );
			sb.append( "        CASE SUBSTR(PARAM_ID, LENGTH(PARAM_ID), 1) " );
			sb.append( "            WHEN 'I' THEN 'SUCCESS' " );
			sb.append( "            WHEN 'E' THEN 'ERROR' " );
			sb.append( "            WHEN 'W' THEN 'WARN' " );
			sb.append( "        END AS UP_RESULT, " );
			sb.append( "        PARAM_ID, " );
			sb.append( "        PARAM_VALUE " );
			sb.append( "    FROM CCP_PARAM WHERE PARAM_ID LIKE 'Mail%JINIK_ExcelUL%' " );
			sb.append( ") MAIL " );
			sb.append( "WHERE MAIL.UP_RESULT = ? " );
			sb.append( "GROUP BY MAIL.UP_RESULT" );

			stmt = conn.prepareStatement( sb.toString());
			stmt.setString( 1, mailType );

			rs = stmt.executeQuery();
			if ( rs.next()) {
				contents[0] = rs.getString( "MAIL_TITLE" );
				contents[1] = rs.getString( "MAIL_BODY" );
			}
		} catch ( SQLException e ) {
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, rs );
		}
		return contents;
	}

	private int insertMailInfo( MailInfoDto mailDto ) throws SQLException {

		int sendNo = 0;

		PreparedStatement stmt = null;
		PreparedStatement stmtSelect = null;

		ResultSet rs = null;

		try {

			String sql = "SELECT NVL(MAX( SEND_NO ) + 1, 1) AS SEND_NO FROM MAIL_INFO";

			stmtSelect = conn.prepareStatement( sql );

			rs = stmtSelect.executeQuery();

			if ( rs.next()) {
				sendNo = rs.getInt( "SEND_NO" );
			}

			StringBuilder sb = new StringBuilder();

			sb.append( "INSERT INTO MAIL_INFO( SEND_NO, STATUS, FROM_ADDRESS, TO_ADDRESS, TITLE, BODY, UPDATE_FUNCTION_ID, UPDATE_DATE ) " );
			sb.append( "VALUES( " );
			sb.append( "    ?, " );
			sb.append( "    0, " );
			sb.append( "    ?, ?, ?, ?, " );
			sb.append( "    'JINIK_EXCEL_UL', " );
			sb.append( "    SYSDATE" );
			sb.append( ")" );

			stmt = conn.prepareStatement( sb.toString());
			stmt.setInt(1, sendNo );
			stmt.setString( 2, mailDto.getFromAddress());
			stmt.setString( 3, mailDto.getToAddress());
			stmt.setString( 4, mailDto.getTitle());
			stmt.setString( 5, mailDto.getBody());

			stmt.executeUpdate();

		} catch ( SQLException e ) {
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmtSelect, rs );
			BatchConnectUtil.closeConnection( null, stmt, null );
		}
		return sendNo;
	}

	private void insertMailAttachment( int sendNo, JinikUpdateResultBean bean ) throws IOException, SQLException {

		if ( bean.warning == 0 ) {
			return;
		}

		File tmpDir = new File( ATTACHED_FILE_TEMP_DIR );
		if ( !tmpDir.exists()) {
			tmpDir.mkdir();
		}

		PreparedStatement stmt = null;
		File attachedFile = null;

		try {
			attachedFile = bean.createLogFile( ATTACHED_FILE_TEMP_DIR + "\\", "エラーログ.csv" );

			//作成したファイルをDBに格納
			StringBuilder sb = new StringBuilder();

			sb.append( "INSERT INTO MAIL_ATTACHMENT(SEND_NO, ATTACHMENT_NO, ATTACHMENT_FILE_NAME, ATTACHMENT_FILE ) VALUES " );
			sb.append( "( " );
			sb.append( "    ?, " );
			sb.append( "    ( SELECT NVL(MAX(ATTACHMENT_NO) + 1, 1) FROM MAIL_ATTACHMENT WHERE SEND_NO = ? ), " );
			sb.append( "    ?, " );
			sb.append( "    ? " );
			sb.append( ")" );

			stmt = conn.prepareStatement( sb.toString());
			stmt.setInt(1, sendNo );
			stmt.setInt(2, sendNo );
			stmt.setString( 3, attachedFile.getName());
			stmt.setBinaryStream( 4, new FileInputStream( attachedFile ), attachedFile.length());

			stmt.executeUpdate();

		} catch ( IOException e ) {
			catErr.error( "添付ファイルの作成に失敗しました。", e );
			throw e;
		} catch ( SQLException e ) {
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, null );
			
			if ( attachedFile.exists() ) {
				attachedFile.delete();
			}
		}
	}
	
	private Map<String, String> getBatchProperties() throws IOException {
		HashMap<String, String> propMap = new HashMap<String, String>();
		
		Properties prop = new Properties();
		try {
			prop.load( Files.newBufferedReader( Paths.get( PROP_BATCH_PATH ), StandardCharsets.UTF_8 ));
			
			for ( Object key : prop.keySet()) {
				propMap.put(( String )key, ( String )prop.get( key ));
			}
		} catch ( IOException e ) {
			catErr.error( "プロパティファイルの読み込みに失敗しました。", e );
			throw e;
		}
		return propMap;
	}

	private HashMap<String, String> getCaRegist( String guid ) throws SQLException {

		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		HashMap<String, String> userinfo = new HashMap<String, String>();

		try {
			String sql = "SELECT GUID, PERSON_NAME, MAIL_ADDRESS FROM CA_REGIST WHERE GUID = ? AND MAIN_FLG = '1'";
			stmt = conn.prepareStatement( sql );
						stmt.setString( 1, guid );
			
			rs = stmt.executeQuery();
			if ( rs.next()) {
				userinfo.put( "GUID", rs.getString( "GUID" ));
				userinfo.put( "PERSON_NAME", rs.getString( "PERSON_NAME" ));
				userinfo.put( "MAIL_ADDRESS", rs.getString( "MAIL_ADDRESS" ));
			}
		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, rs );
		}
		return userinfo;
	}

	private String getJinikFillAutoId() throws SQLException {
		String ret = "";
		
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			String sql = "SELECT DISTINCT(FILL_ID) FROM V_CST_SHEET_FILL_AUTO WHERE FILL_ID LIKE 'jinik_%' ORDER BY FILL_ID";
			
			stmt = conn.prepareStatement( sql );
			rs = stmt.executeQuery();
			while ( rs.next()) {
				ret = ret + "'" + rs.getString( "FILL_ID" ) + "',";
			}
			
			if ( ret != "" ) {
				ret = ret.substring( 0, ret.length() - 1 );
			}
		} catch ( SQLException e ) {
			catErr.error( "SQLエラーが発生しました。", e );
			throw e;
		} finally {
			BatchConnectUtil.closeConnection( null, stmt, rs );
		}
		return ret;
	}

}

