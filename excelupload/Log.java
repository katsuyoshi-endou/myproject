package jp.co.hisas.career.app.batch.util.log;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Properties;

import org.apache.log4j.Category;
import org.apache.log4j.PropertyConfigurator;

import jp.co.hisas.career.app.batch.util.property.HcdbDef;
import jp.co.hisas.career.util.property.ReadFile;

public class Log {
	
	private final static String CATEGORY_BATCH_MESSAGE = "CTG_BATCH_MESSAGE";

	private static Category _msgCategory;

	private static boolean _initStatus = false;

	private static HashMap _msgMapData = null;

	/**
	 * Log4Jを初期化する。
	 * @param type:バッチの種類：kensyurekiIkoまたはkensyuDataSakujyoである。
	 * @param path:ログファイルを格納するフォルダへのパス
	 */
	static public void init(final String type, final String path) throws FileNotFoundException {

		ReadFile.refreshFile();

		/* Log4J定義ファイル名をセットし、全カテゴリのインスタンスを生成 */
		final Properties prop = new Properties();

		final Date now = new Date();
		final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss"); // fix 2017.01
		final String fileName = dateFormat.format(now) + "_" + type;

		final String tempPath = path;
		final String tempFileName = fileName;
		new FileOutputStream(tempPath + "/" + tempFileName + ".log");

		prop.put("log4j.category.CTG_BATCH_MESSAGE", "INFO, APN_BATCH_MESSAGE");
		prop.put("log4j.appender.APN_BATCH_MESSAGE", "org.apache.log4j.FileAppender");
		prop.put("log4j.appender.APN_BATCH_MESSAGE.layout", "org.apache.log4j.PatternLayout");
		prop.put("log4j.appender.APN_BATCH_MESSAGE.layout.ConversionPattern", "%m%n");
		prop.put("log4j.appender.APN_BATCH_MESSAGE.File", path + "/" + fileName + ".log");
		PropertyConfigurator.configure(prop);

		Log._msgCategory = Category.getInstance(Log.CATEGORY_BATCH_MESSAGE);
		Log._initStatus = true;
	}

	/**
	 * ログファイルにメッセージを書き込むことに使用する。
	 * @param msg:書き込むメッセージ又はメッセージID
	 * @param isKey:戻り値がtrueの場合、booleanをキーに、メッセージファイルでmsgに該当するメッセージを検索する。 falseの場合、ログファイルにmsgを直接に書き込む。
	 */
	public static void message(String msg, boolean isKey) {
		if (Log._initStatus) {
			if (!isKey) {
				Log._msgCategory.info(msg);
			} else {
				msg = msg.trim();
				if (Log._msgMapData == null) {

					/* メッセージ定義ファイル名取得 */
					final String msgFileName = (String) ReadFile.fileMapData.get(HcdbDef.msgCode);

					Log._msgMapData = new HashMap();

					Log._msgMapData = ReadFile.getMsgMapData(msgFileName);

				}
				final String errorMessage = (String) Log._msgMapData.get(msg);
				Log._msgCategory.info(errorMessage);
			}

		}
	}

	/**
	 * ログファイルにメッセージを書き込むことに使用する。
	 * @param msg
	 */
	public static void message(final String msg) {
		Log.message(msg, false);
	}

	/**
	 * seqNoに該当するPCG-0109のエラーメッセージを出力することに使用する。
	 * @param kamokuCode
	 * @param classCode
	 * @param e:例外
	 */
	public static void messagePCG0109(final String seqNo, final Throwable e) {
		if (Log._initStatus) {
			if (Log._msgMapData == null) {

				/* メッセージ定義ファイル名取得 */
				final String msgFileName = (String) ReadFile.fileMapData.get(HcdbDef.msgCode);
				Log._msgMapData = new HashMap();
				Log._msgMapData = ReadFile.getMsgMapData(msgFileName);

			}
			String errorMessage = (String) Log._msgMapData.get("PCG-0109");
			errorMessage += "[SEQ_NO:" + seqNo + "]";
			errorMessage += e.getMessage();
			Log._msgCategory.info(errorMessage);
		}
	}

	/**
	 * 指定した科目コード及びクラスコードに該当するPCG-0123のエラーメッセージを出力することに使用する。
	 * @param kamokuCode: 出力するための科目コード
	 * @param classCode: 出力するためのクラスコード
	 * @param e: exception: 出力するための例外
	 */
	public static void messagePCG0123(final String kamokuCode, final String classCode, final Throwable e) {
		if (Log._initStatus) {
			if (Log._msgMapData == null) {

				/* メッセージ定義ファイル名取得 */
				final String msgFileName = (String) ReadFile.fileMapData.get(HcdbDef.msgCode);
				Log._msgMapData = ReadFile.getMsgMapData(msgFileName);

			}
			String errorMessage = (String) Log._msgMapData.get("PCG-0123");
			errorMessage += "[Subject code:" + kamokuCode + "]";
			errorMessage += "[Class code:" + classCode + "]";
			errorMessage += e.getMessage();
			Log._msgCategory.info(errorMessage);
		}
	}
}
