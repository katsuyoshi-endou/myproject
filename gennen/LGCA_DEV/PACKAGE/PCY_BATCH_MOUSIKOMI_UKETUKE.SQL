create or replace PACKAGE PCY_BATCH_MOUSIKOMI_UKETUKE 
IS

-------------
-- 定数定義
-------------

-- バッチID
vBatchID		                        CONSTANT VARCHAR2(40) := 'BATCH_MOUSIKOMI_UKETUKE';

-- バッチ更新ユーザ名
vBATCH_USER_NAME                        CONSTANT VARCHAR2(20) := 'BATCH';
vPROC_ADMIN                             CONSTANT VARCHAR2(20) := 'ZZZZZZ';


-- 状況区分
cvJYOKYO_KBN_WAIT_LYSITHEA              CONSTANT ZZ_PARTNER_ENTRY_STATUS.STATUS%TYPE := '0';    -- リシテア処理待ち
cvJYOKYO_KBN_WAIT_SUSBSYS               CONSTANT ZZ_PARTNER_ENTRY_STATUS.STATUS%TYPE := '1';    -- サブシステム処理待ち
cvJYOKYO_KBN_COMPLETED                  CONSTANT ZZ_PARTNER_ENTRY_STATUS.STATUS%TYPE := '2';    -- 処理完了

-- 結果区分（処理グループNoごと）
cvGRP_KEKKA_KBN_SUCCESS                 CONSTANT ZZ_PARTNER_ENTRY_STATUS.PROC_RESULT%TYPE := '1';    -- 成功
cvGRP_KEKKA_KBN_FAILURE                 CONSTANT ZZ_PARTNER_ENTRY_STATUS.PROC_RESULT%TYPE := '2';    -- 失敗
cvGRP_KEKKA_KBN_EXCLUSIVE_ERR           CONSTANT ZZ_PARTNER_ENTRY_STATUS.PROC_RESULT%TYPE := '9';    -- 排他エラー

-- 処理完了メッセージ
cvMSG_UKETUKE_COMPLETED                 CONSTANT VARCHAR2(256) := '{0}件の受付処理が正常終了しました。';
cvMSG_UKETUKE_ERROR                     CONSTANT VARCHAR2(256) := 'チェックエラーのため、受付処理を中止しました。';
cvMSG_EXCLUSIVE_WARN                    CONSTANT VARCHAR2(256) := '受付処理中に他ユーザにより更新されたため、処理をスキップしました。';


-- 処理区分
cvSYORI_KBN_MOUSIKOMI                   CONSTANT ZZ_PARTNER_ENTRY_WK.PROC_TYPE%TYPE := '0';     -- 申込
cvSYORI_KBN_TORIKESI                    CONSTANT ZZ_PARTNER_ENTRY_WK.PROC_TYPE%TYPE := '1';     -- 取消

-- 個別結果区分
cvKEKKA_KBN_SUCCESS                     CONSTANT ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE := '1';   -- 処理成功
cvKEKKA_KBN_MOUSIKOMI_KIKAN_NG          CONSTANT ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE := '2';   -- 申込可能期間チェックNG
cvKEKKA_KBN_EXIST_CHK_NG                CONSTANT ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE := '3';   -- 同一科目・クラスチェックNG
cvKEKKA_KBN_MANSEKI_CHK_NG              CONSTANT ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE := '4';   -- 満席チェックNG
cvKEKKA_KBN_TORIKESI_KIKAN_NG           CONSTANT ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE := '5';   -- 取消期間チェックNG
cvKEKKA_KBN_EXCEPTION_ERR               CONSTANT ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE := '9';   -- 処理例外
cvKEKKA_KBN_CHECK_OK                    CONSTANT ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE := '0';   -- チェックOK

-- チェックエラーメッセージ
cvMSG_MOUSIKOMI_KIKAN_ERR               CONSTANT VARCHAR2(100) := '申込可能な期間ではありません。';
cvMSG_ALREADY_ENTRY_ERR                 CONSTANT VARCHAR2(100) := 'すでに同一科目・クラスに申し込み済みです。';
cvMSG_MANSEKI_ERR                       CONSTANT VARCHAR2(100) := '申込定員数を超えています。';
cvMSG_CANCEL_KIKAN_ERR                  CONSTANT VARCHAR2(100) := '取り消し可能な期間ではありません。';
cvMSG_UNEXPECTED_ERR                    CONSTANT VARCHAR2(100) := '予期せぬエラーが発生しました。';

-- 処理開始日時
vPROC_START_TIME                        VARCHAR2(14);

-- 日付取得区分
cvPROC_DATE                             CONSTANT CHAR(1) := '0';            -- 処理開始日付
cvCURRENT_DATE                          CONSTANT CHAR(1) := '1';            -- 現在日付

-- ログファイル用ファイルハンドル
vLOG_FILE_HANDLE                        UTL_FILE.FILE_TYPE;

cvLOG_FILE_TEMPLATE                     CONSTANT VARCHAR2(128) := 'mousikomi-uketuke_{0}.log';
cvMSG_TEMPLATE                          CONSTANT VARCHAR2(1024) := '{0} [{1}] [処理グループNo:{2}] [処理順:{3}] [メッセージ:{4}]';

cvMSG_TYPE_INFO                         CONSTANT VARCHAR2(20) := '情報';
cvMSG_TYPE_ERROR                        CONSTANT VARCHAR2(20) := 'エラー';
cvMSG_TYPE_WARNING                      CONSTANT VARCHAR2(20) := '警告';


-- データ更新時デフォルト値
cvDEF_L15_SEIKYU_FLG                    CONSTANT L15_MOUSIKOMI_JYOKYO_TBL.SEIKYU_FLG%TYPE := '0';       -- 請求フラグ
cvDEF_L14_TAISYO_KUBUN                  CONSTANT L14_TAISYOSYA_TBL.TAISYO_KUBUN%TYPE := '1';            -- 対象区分
cvDEF_L94_SYORI_FLG                     CONSTANT L94_MOUSIKOMI_DEL_RIREKI_TBL.SYORI_FLG%TYPE := '1';    -- 処理フラグ
cvDEF_L16_DAIKOUSYA_FLG                 CONSTANT L16_SYONINSYA_TBL.DAIKOUSYA_FLG%TYPE := '0';           -- 代行者フラグ


-------------------------------------------------------------------------------
-- 機能：メイン処理
-- 引数：
-------------------------------------------------------------------------------
FUNCTION MAIN RETURN NUMBER;

-------------------------------------------------------------------------------
-- 機能：申込受付メイン処理
-- 概要：申込受付処理を実行する
-- 引数：
-------------------------------------------------------------------------------
FUNCTION F_MOUSIKOMI_UKETUKE RETURN NUMBER;

-------------------------------------------------------------------------------
-- 機能：申込受付メイン処理（処理グループNoごと）
-- 概要：申込受付処理を実行する
-- 引数：
-------------------------------------------------------------------------------
FUNCTION F_MOUSIKOMI_UKETUKE_BY_GROUP(
    tPROC_GRP_NO                    ZZ_PARTNER_ENTRY_STATUS.PROC_GRP_NO%TYPE
)
RETURN VARCHAR2;

-------------------------------------------------------------------------------
-- 機能：申込状況コピー処理
-- 概要：引数で指定された処理グループNoに一致するL15_申込状況のレコードを
--       L15_申込状況ワークにコピーする
-- 引数：処理グループNo
-------------------------------------------------------------------------------
PROCEDURE P_COPY_ENTRY_WK(
    tPROC_GROUP_NO                  IN  ZZ_PARTNER_ENTRY_WK.PROC_GRP_NO%TYPE
);

-------------------------------------------------------------------------------
-- 機能：L15_申込状況ワークレコード削除処理
-- 概要：L15_申込状況ワークテーブルのレコードを全件削除する
-- 引数：
-------------------------------------------------------------------------------
PROCEDURE P_DELETE_ENTRY_WK;

-------------------------------------------------------------------------------
-- 機能：申込受付データチェックメイン処理
-- 概要：申込受付データのチェック処理を実行する
-- 引数：科目コード
--       クラスコード
--       処理区分（0:申込、1:取消）
-------------------------------------------------------------------------------
FUNCTION F_CHECK_ENTRY_DATA(
    tKAMOKU_CODE                    IN  ZZ_PARTNER_ENTRY_WK.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  ZZ_PARTNER_ENTRY_WK.CLASS_CODE%TYPE,
    tSIMEI_NO                       IN  ZZ_PARTNER_ENTRY_WK.SIMEI_NO%TYPE,
    tPROC_TYPE                      IN  ZZ_PARTNER_ENTRY_WK.PROC_TYPE%TYPE
)
RETURN CHAR;

-------------------------------------------------------------------------------
-- 機能：申込可能期間チェック処理
-- 概要：申込受付データが申込可能期間内であるかのチェックを実行する
-- 引数：科目コード
--       クラスコード
-------------------------------------------------------------------------------
FUNCTION F_CHECK_MOUSIKOMI_KIKAN(
    tKAMOKU_CODE                    IN  ZZ_PARTNER_ENTRY_WK.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  ZZ_PARTNER_ENTRY_WK.CLASS_CODE%TYPE
) RETURN CHAR;

-------------------------------------------------------------------------------
-- 機能：同一科目・クラス存在チェック処理
-- 概要：申込受付データがすでに申し込み済みであるかのチェックを実行する
--       （L15_申込状況テーブルに存在するか）
-- 引数：科目コード
--       クラスコード
--       氏名No
-------------------------------------------------------------------------------
FUNCTION F_CHECK_MOUSIKOMI(
    tKAMOKU_CODE                    IN  ZZ_PARTNER_ENTRY_WK.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  ZZ_PARTNER_ENTRY_WK.CLASS_CODE%TYPE,
    tSIMEI_NO                       IN  ZZ_PARTNER_ENTRY_WK.SIMEI_NO%TYPE
) RETURN CHAR;

-------------------------------------------------------------------------------
-- 機能：満席チェック処理
-- 概要：引数で指定された科目・クラスが満席であるかのチェックを実行する
-- 引数：科目コード
--       クラスコード
-------------------------------------------------------------------------------
FUNCTION F_CHECK_MOUSIKOMI_MANSEKI(
    tKAMOKU_CODE                    IN  ZZ_PARTNER_ENTRY_WK.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  ZZ_PARTNER_ENTRY_WK.CLASS_CODE%TYPE
) RETURN CHAR;

-------------------------------------------------------------------------------
-- 機能：申込取消期間チェック処理
-- 概要：申込受付データが取消可能期間内であるかのチェックを実行する
-- 引数：科目コード
--       クラスコード
-------------------------------------------------------------------------------
FUNCTION F_CHECK_MOUSIKOMI_CANCEL_KIKAN(
    tKAMOKU_CODE                    IN  ZZ_PARTNER_ENTRY_WK.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  ZZ_PARTNER_ENTRY_WK.CLASS_CODE%TYPE
) RETURN CHAR;

-------------------------------------------------------------------------------
-- 機能：協力会社申込ワーク更新処理
-- 概要：引数で指定された協力会社申込ワークの[個別処理結果区分]を更新する
-- 引数：処理グループNo
--       処理順
--       個別処理結果区分
-------------------------------------------------------------------------------
PROCEDURE P_UPDATE_PROC_RESULT(
    tPROC_GRP_NO                    IN  ZZ_PARTNER_ENTRY_WK.PROC_GRP_NO%TYPE,
    tPROC_ORDER                     IN  ZZ_PARTNER_ENTRY_WK.PROC_ORDER%TYPE,
    tPROC_RESULT                    IN  ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE
);

-------------------------------------------------------------------------------
-- 機能：協力会社申込受付処理
-- 概要：受付処理を実行する
-- 引数：科目コード
--       クラスコード
--       氏名No
--       申込者
--       処理区分（0:申込、1:取消）
-------------------------------------------------------------------------------
FUNCTION F_MOUSIKOMI_ENTRY(
    tKAMOKU_CODE                    IN  ZZ_PARTNER_ENTRY_WK.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  ZZ_PARTNER_ENTRY_WK.CLASS_CODE%TYPE,
    tSIMEI_NO                       IN  ZZ_PARTNER_ENTRY_WK.SIMEI_NO%TYPE,
    tMOUSIKOMISYA                   IN  ZZ_PARTNER_ENTRY_WK.MOUSIKOMISYA%TYPE,
    tPROC_TYPE                      IN  ZZ_PARTNER_ENTRY_WK.PROC_TYPE%TYPE
) RETURN CHAR;

-------------------------------------------------------------------------------
-- 機能：申込状況ワークテーブル登録処理
-- 概要：L15_申込状況ワークにレコードを引数で指定されたステータス・受付状態で
--       新規登録する
-- 引数：科目コード
--       クラスコード
--       氏名No
--       申込者
--       ステータス
--       受付状態
-------------------------------------------------------------------------------
PROCEDURE P_INSERT_MOUSIKOMI_JYOKYO_WORK(
    tKAMOKU_CODE                    IN  L15_MOUSIKOMI_JYOKYO_TBL.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  L15_MOUSIKOMI_JYOKYO_TBL.CLASS_CODE%TYPE,
    tSIMEI_NO                       IN  L15_MOUSIKOMI_JYOKYO_TBL.SIMEI_NO%TYPE,
    tMOUSIKOMISYA                   IN  L15_MOUSIKOMI_JYOKYO_TBL.MOUSIKOMISYA%TYPE,
    tSTATUS                         IN  L15_MOUSIKOMI_JYOKYO_TBL.STATUS%TYPE,
    tUKETUKE_JYOTAI                 IN  L15_MOUSIKOMI_JYOKYO_TBL.UKETSUKE_JYOTAI%TYPE
);

-------------------------------------------------------------------------------
-- 機能：申込状況ワークテーブル削除処理
-- 概要：L15_申込状況ワークから指定された条件でレコードを削除する
-- 引数：科目コード
--       クラスコード
--       氏名No
-------------------------------------------------------------------------------
PROCEDURE P_DELETE_MOUSIKOMI_JYOKYO_WORK(
    tKAMOKU_CODE                    IN  L15_MOUSIKOMI_JYOKYO_TBL.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  L15_MOUSIKOMI_JYOKYO_TBL.CLASS_CODE%TYPE,
    tSIMEI_NO                       IN  L15_MOUSIKOMI_JYOKYO_TBL.SIMEI_NO%TYPE
);

-------------------------------------------------------------------------------
-- 機能：申込削除履歴テーブル登録処理
-- 概要：L94_申込削除履歴テーブルにレコードを新規登録する
-- 引数：科目コード
--       クラスコード
--       氏名No
-------------------------------------------------------------------------------
PROCEDURE P_INSERT_MOUSIKOMI_DEL_RIREKI(
    tKAMOKU_CODE                    IN  L94_MOUSIKOMI_DEL_RIREKI_TBL.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  L94_MOUSIKOMI_DEL_RIREKI_TBL.CLASS_CODE%TYPE,
    tSIMEI_NO                       IN  L94_MOUSIKOMI_DEL_RIREKI_TBL.SIMEI_NO%TYPE
);

-------------------------------------------------------------------------------
-- 機能：対象者テーブル登録処理
-- 概要：L14_対象者テーブルにレコードを新規登録する
-- 引数：科目コード
--       クラスコード
--       氏名No
-------------------------------------------------------------------------------
PROCEDURE P_INSERT_TAISYOSHA_TBL(
    tKAMOKU_CODE                    IN  L14_TAISYOSYA_TBL.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  L14_TAISYOSYA_TBL.CLASS_CODE%TYPE,
    tSIMEI_NO                       IN  L14_TAISYOSYA_TBL.SIMEI_NO%TYPE
);

-------------------------------------------------------------------------------
-- 機能：対象者テーブル削除処理
-- 概要：L14_対象者テーブルから指定された条件でレコードを削除する
-- 引数：科目コード
--       クラスコード
--       氏名No
-------------------------------------------------------------------------------
PROCEDURE P_DELETE_TAISYOSHA_TBL(
    tKAMOKU_CODE                    IN  L14_TAISYOSYA_TBL.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  L14_TAISYOSYA_TBL.CLASS_CODE%TYPE,
    tSIMEI_NO                       IN  L14_TAISYOSYA_TBL.SIMEI_NO%TYPE
);

-------------------------------------------------------------------------------
-- 機能：承認者テーブル登録処理
-- 概要：L16_承認者テーブルにレコードを新規登録する
-- 引数：氏名No
-------------------------------------------------------------------------------
PROCEDURE P_INSERT_SYONINSYA_TBL(
    tSIMEI_NO                       IN  L16_SYONINSYA_TBL.SIMEI_NO%TYPE,
    tSYONINSHA                      IN  L16_SYONINSYA_TBL.SYONINSYA1%TYPE
);

-------------------------------------------------------------------------------
-- 機能：申込ワークデータコピー処理
-- 概要：L15_申込状況ワークテーブルのデータをL15_申込状況にコピーする
-- 引数：
-------------------------------------------------------------------------------
FUNCTION F_COPY_WORK_TO_MOUSIKOMI_TBL RETURN VARCHAR2;

-------------------------------------------------------------------------------
-- 機能：協力会社申込処理状況テーブル更新処理
-- 概要：[協力会社申込処理状況]テーブルの結果区分を更新する
-- 引数：処理グループNo
--       結果区分
-------------------------------------------------------------------------------
PROCEDURE P_UPDATE_PARTNER_ENTRY_STATUS(
    tPROC_GRP_NO                    IN  ZZ_PARTNER_ENTRY_STATUS.PROC_GRP_NO%TYPE,
    tSTATUS                         IN  ZZ_PARTNER_ENTRY_STATUS.STATUS%TYPE,
    tPROC_RESULT                    IN  ZZ_PARTNER_ENTRY_STATUS.PROC_RESULT%TYPE
);

-------------------------------------------------------------------------------
-- 機能：処理開始日の取得処理
-- 概要：処理開始日時または現在日付から年月日を切り出し返す
-- 引数：取得タイプ（0:処理開始日時、1:現在日付）
-------------------------------------------------------------------------------
FUNCTION getPROC_DATE(
    tGET_TYPE                       IN  CHAR
) RETURN VARCHAR2;

-------------------------------------------------------------------------------
-- 機能：処理開始時刻の取得処理
-- 概要：処理開始日時または現在日時から時分秒を切り出し返す
-- 引数：取得タイプ（0:処理開始日時、1:現在日付）
-------------------------------------------------------------------------------
FUNCTION getPROC_TIME(
    tGET_TYPE                       IN  CHAR
) RETURN VARCHAR2;

-------------------------------------------------------------------------------
-- 機能：ZZ_バッチ制御テーブル更新処理
-- 概要：ZZ_バッチ制御テーブルを更新する
--       ※本処理は、自律型トランザクションで実行する
-- 引数：バッチ名称
--       処理中フラグ（0:処理待ち、1:処理中）
-------------------------------------------------------------------------------
PROCEDURE UPDATE_BATCH_SEIGYO_TBL(
    tBATCH_NAME                     IN  ZZ_BATCH_SEIGYO_TBL.BATCH_NAME%TYPE,
    tSTATUS                         IN  ZZ_BATCH_SEIGYO_TBL.STATUS%TYPE
);

-------------------------------------------------------------------------------
-- 機能：処理中フラグ取得処理
-- 概要：バッチの処理中フラグを取得する
-- 引数：バッチ名称
-------------------------------------------------------------------------------
FUNCTION GET_BATCH_STATUS(
    tBATCH_NAME                     IN  ZZ_BATCH_SEIGYO_TBL.BATCH_NAME%TYPE
) RETURN CHAR;

-------------------------------------------------------------------------------
-- 機能：チェックエラーメッセージ取得処理
-- 概要：エラーチェック時のエラーメッセージを取得する
-- 引数：エラーコード
-------------------------------------------------------------------------------
FUNCTION GET_CHECK_ERR_MSG(
    tERR_CODE                       IN  ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE
) RETURN VARCHAR2;

-------------------------------------------------------------------------------
-- 機能：ログファイルオープン
-- 概要：ログファイルを作成し、オープンする
-- 引数：
-------------------------------------------------------------------------------
PROCEDURE LOG_FILE_OPEN;

-------------------------------------------------------------------------------
-- 機能：ログ書き込み処理
-- 概要：ログを書き込む
-- 引数：ログ種別（0:INFO、1:ERROR、2:WARNING）
--       処理グループNo
--       処理順
--       ログメッセージ
-------------------------------------------------------------------------------
PROCEDURE P_OUTPUT_LOG(
    tLOG_TYPE                       IN  CHAR,
    tPROC_GRP_NO                    IN  ZZ_PARTNER_ENTRY_STATUS.PROC_GRP_NO%TYPE,
    tPROC_ORDER                     IN  ZZ_PARTNER_ENTRY_WK.PROC_ORDER%TYPE,
    tLOG_MSG                        IN  VARCHAR2
);

-------------------------------------------------------------------------------
-- 機能：ログファイルクローズ
-- 概要：ログファイルを閉じる
-- 引数：
-------------------------------------------------------------------------------
PROCEDURE LOG_FILE_CLOSE;


FUNCTION TEST_MAIN(
    vUSER_NAME                      IN  VARCHAR2
) RETURN NUMBER;

END PCY_BATCH_MOUSIKOMI_UKETUKE;