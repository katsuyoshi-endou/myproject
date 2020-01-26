create or replace PACKAGE BODY PCY_BATCH_MOUSIKOMI_UKETUKE
IS

-------------------------------------------------------------------------------
-- 機能：メイン処理
-- 引数：
-------------------------------------------------------------------------------
FUNCTION MAIN 
RETURN NUMBER
IS
    vSTATUS                         ZZ_BATCH_SEIGYO_TBL.STATUS%TYPE;
    vRET                            NUMBER := 0;

BEGIN

    -- バッチ処理中かどうか
    vSTATUS := GET_BATCH_STATUS(PCY_BATCH_MOUSIKOMI_UKETUKE.vBatchID);
    IF vSTATUS = '0' THEN
        -- バッチ処理中にして処理開始
        UPDATE_BATCH_SEIGYO_TBL(PCY_BATCH_MOUSIKOMI_UKETUKE.vBatchID, '1');

        -- 申込受付処理
        vRET := F_MOUSIKOMI_UKETUKE;

        UPDATE_BATCH_SEIGYO_TBL(PCY_BATCH_MOUSIKOMI_UKETUKE.vBatchID, '0');
    END IF;

    RETURN vRET;

END MAIN;

-------------------------------------------------------------------------------
-- 機能：申込受付メイン処理
-- 概要：申込受付処理を実行する
-- 引数：
-------------------------------------------------------------------------------
FUNCTION F_MOUSIKOMI_UKETUKE
RETURN NUMBER
IS

    -- 対象の処理グループNoカーソル
    CURSOR curTGT_PROC_GROUP_NO IS
        SELECT PS.PROC_GRP_NO FROM ZZ_PARTNER_ENTRY_STATUS PS
            LEFT JOIN (
                SELECT PROC_GRP_NO, MIN(UPDATE_DATE) AS UPDATE_DATE FROM ZZ_PARTNER_ENTRY_WK GROUP BY PROC_GRP_NO
        )        WK ON PS.PROC_GRP_NO = WK.PROC_GRP_NO
        WHERE PS.STATUS = '0'
        ORDER BY WK.UPDATE_DATE;

    vRET                            ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE;
    vCNT                            NUMBER;

BEGIN
    -- 処理対象の件数を取得
    SELECT COUNT(*) INTO vCNT FROM ZZ_PARTNER_ENTRY_STATUS PS
        LEFT JOIN (
            SELECT PROC_GRP_NO, MIN(UPDATE_DATE) AS UPDATE_DATE FROM ZZ_PARTNER_ENTRY_WK GROUP BY PROC_GRP_NO
    ) WK ON PS.PROC_GRP_NO = WK.PROC_GRP_NO
    WHERE PS.STATUS = '0';

    -- 処理の対象が存在すれば、ログファイルを作成して処理開始
    IF vCNT > 0 THEN
        -- ログファイル作成
        LOG_FILE_OPEN;

        -- 処理グループNo単位で処理
        FOR recTGT_PROC_GROUP_NO IN curTGT_PROC_GROUP_NO LOOP
            -- 処理グループ単位の申込受付処理を実行
            vRET := F_MOUSIKOMI_UKETUKE_BY_GROUP(recTGT_PROC_GROUP_NO.PROC_GRP_NO);
            IF vRET = PCY_BATCH_MOUSIKOMI_UKETUKE.cvGRP_KEKKA_KBN_EXCLUSIVE_ERR THEN
                -- 排他エラーとなったときは、再度、同じ処理グループNoの処理を実行する
                vRET := F_MOUSIKOMI_UKETUKE_BY_GROUP(recTGT_PROC_GROUP_NO.PROC_GRP_NO);
            END IF;
        END LOOP;

        -- ログファイルクローズ
        LOG_FILE_CLOSE;
    END IF;

    RETURN 0;

EXCEPTION
    WHEN OTHERS THEN
        LOG_FILE_CLOSE;

        IF curTGT_PROC_GROUP_NO%ISOPEN THEN
            CLOSE curTGT_PROC_GROUP_NO;
        END IF;

        RETURN -1;

END F_MOUSIKOMI_UKETUKE;

-------------------------------------------------------------------------------
-- 機能：申込受付メイン処理（処理グループNoごと）
-- 概要：申込受付処理を実行する
-- 引数：
-------------------------------------------------------------------------------
FUNCTION F_MOUSIKOMI_UKETUKE_BY_GROUP(
    tPROC_GRP_NO                    ZZ_PARTNER_ENTRY_STATUS.PROC_GRP_NO%TYPE
)
RETURN VARCHAR2
IS
    -- 処理対象のレコードを取得するためのカーソル
    CURSOR curTGT_TRAINING_ENTRY_WK(tPROC_GRP_NO IN ZZ_PARTNER_ENTRY_WK.PROC_GRP_NO%TYPE)
    IS
        SELECT *
        FROM ZZ_PARTNER_ENTRY_WK
        WHERE PROC_GRP_NO = tPROC_GRP_NO
        ORDER BY PROC_ORDER;

    vRET                            VARCHAR2(2);
    vCHK_RESULT                     CHAR(1);
    vMSG                            VARCHAR2(256);

    -- 処理件数
    vPROC_CNT                       NUMBER := 0;

    -- エラーチェックフラグ（処理グループNo単位でエラーあり/なし）
    vCHECK_FLG                      BOOLEAN := TRUE;

BEGIN
    -- 処理の開始
    vPROC_START_TIME := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');

    -- ワークテーブルにデータをコピー
    P_COPY_ENTRY_WK(tPROC_GRP_NO);

    FOR recTGT_TRAINING_ENTRY_WK IN curTGT_TRAINING_ENTRY_WK(tPROC_GRP_NO) LOOP
        vPROC_CNT := vPROC_CNT + 1;

        -- 申込/取消データのチェック
        vCHK_RESULT := F_CHECK_ENTRY_DATA(recTGT_TRAINING_ENTRY_WK.KAMOKU_CODE, recTGT_TRAINING_ENTRY_WK.CLASS_CODE, recTGT_TRAINING_ENTRY_WK.SIMEI_NO, recTGT_TRAINING_ENTRY_WK.PROC_TYPE);
        IF vCHK_RESULT = PCY_BATCH_MOUSIKOMI_UKETUKE.cvKEKKA_KBN_CHECK_OK THEN
            -- 申込/取消処理を実行
            vRET := F_MOUSIKOMI_ENTRY(recTGT_TRAINING_ENTRY_WK.KAMOKU_CODE, recTGT_TRAINING_ENTRY_WK.CLASS_CODE, recTGT_TRAINING_ENTRY_WK.SIMEI_NO, recTGT_TRAINING_ENTRY_WK.MOUSIKOMISYA, recTGT_TRAINING_ENTRY_WK.PROC_TYPE);

            -- [協力会社申込WK]を更新
            P_UPDATE_PROC_RESULT(recTGT_TRAINING_ENTRY_WK.PROC_GRP_NO, recTGT_TRAINING_ENTRY_WK.PROC_ORDER, vRET);
        ELSE
            -- チェックエラーの内容を出力
            P_OUTPUT_LOG('1', tPROC_GRP_NO, recTGT_TRAINING_ENTRY_WK.PROC_ORDER, GET_CHECK_ERR_MSG(vCHK_RESULT));

            -- [協力会社申込WK]を更新
            P_UPDATE_PROC_RESULT(recTGT_TRAINING_ENTRY_WK.PROC_GRP_NO, recTGT_TRAINING_ENTRY_WK.PROC_ORDER, vCHK_RESULT);
            
            vCHECK_FLG := FALSE;

            CONTINUE;
        END IF;
    END LOOP;

    IF vCHECK_FLG = TRUE THEN
        -- すべてのデータがチェックエラーなしのときは、ZZ_WK_L15_申込状況のデータをL15_申込状況へ
        vRET := F_COPY_WORK_TO_MOUSIKOMI_TBL;
        IF vRET = PCY_BATCH_MOUSIKOMI_UKETUKE.cvGRP_KEKKA_KBN_SUCCESS THEN
            vMSG := REPLACE(PCY_BATCH_MOUSIKOMI_UKETUKE.cvMSG_UKETUKE_COMPLETED, '{0}', TO_CHAR(vPROC_CNT));

            P_OUTPUT_LOG('0', tPROC_GRP_NO, '', vMSG);
        ELSE
            P_OUTPUT_LOG('2', tPROC_GRP_NO, '', PCY_BATCH_MOUSIKOMI_UKETUKE.cvMSG_EXCLUSIVE_WARN);

            ROLLBACK;
            
            RETURN PCY_BATCH_MOUSIKOMI_UKETUKE.cvGRP_KEKKA_KBN_EXCLUSIVE_ERR;
        END IF;
    ELSE
        -- 戻り値を"失敗"にセット
        vRET := PCY_BATCH_MOUSIKOMI_UKETUKE.cvGRP_KEKKA_KBN_FAILURE;

        P_OUTPUT_LOG('1', tPROC_GRP_NO, '', PCY_BATCH_MOUSIKOMI_UKETUKE.cvMSG_UKETUKE_ERROR);
    END IF;

    -- [協力会社申込処理状況]テーブルを更新
    P_UPDATE_PARTNER_ENTRY_STATUS(tPROC_GRP_NO, PCY_BATCH_MOUSIKOMI_UKETUKE.cvJYOKYO_KBN_WAIT_SUSBSYS, vRET);

    -- ワークテーブルからレコード削除
    P_DELETE_ENTRY_WK;
    
    COMMIT;

    RETURN vRET;

EXCEPTION
    WHEN OTHERS THEN
        P_OUTPUT_LOG('1', tPROC_GRP_NO, '', SQLERRM);

        ROLLBACK;

        IF curTGT_TRAINING_ENTRY_WK%ISOPEN THEN
            CLOSE curTGT_TRAINING_ENTRY_WK;
        END IF;

        RAISE;

END F_MOUSIKOMI_UKETUKE_BY_GROUP;

-------------------------------------------------------------------------------
-- 機能：申込状況コピー処理
-- 概要：引数で指定された処理グループNoに一致するL15_申込状況のレコードを
--       L15_申込状況ワークにコピーする
-- 引数：処理グループNo
-------------------------------------------------------------------------------
PROCEDURE P_COPY_ENTRY_WK(
    tPROC_GROUP_NO                  IN  ZZ_PARTNER_ENTRY_WK.PROC_GRP_NO%TYPE
)
IS

BEGIN
    P_DELETE_ENTRY_WK;

    INSERT INTO ZZ_WK_L15_MOUSIKOMI_JYOKYO_TBL
    (
        SELECT L15.* FROM L15_MOUSIKOMI_JYOKYO_TBL L15
            LEFT JOIN (
                SELECT DISTINCT KAMOKU_CODE, CLASS_CODE FROM ZZ_PARTNER_ENTRY_WK WHERE PROC_GRP_NO = tPROC_GROUP_NO
            ) WK ON L15.KAMOKU_CODE = WK.KAMOKU_CODE AND L15.CLASS_CODE = WK.CLASS_CODE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END P_COPY_ENTRY_WK;

-------------------------------------------------------------------------------
-- 機能：L15_申込状況ワークレコード削除処理
-- 概要：L15_申込状況ワークテーブルのレコードを全件削除する
-- 引数：
-------------------------------------------------------------------------------
PROCEDURE P_DELETE_ENTRY_WK
IS
    vSQL                            VARCHAR2(1000);

BEGIN
    DELETE FROM ZZ_WK_L15_MOUSIKOMI_JYOKYO_TBL;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END P_DELETE_ENTRY_WK;

-------------------------------------------------------------------------------
-- 機能：申込受付データチェックメイン処理
-- 概要：申込受付データのチェック処理を実行する
-- 引数：科目コード
--       クラスコード
--       氏名No
--       処理区分（0:申込、1:取消）
-------------------------------------------------------------------------------
FUNCTION F_CHECK_ENTRY_DATA(
    tKAMOKU_CODE                    IN  ZZ_PARTNER_ENTRY_WK.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  ZZ_PARTNER_ENTRY_WK.CLASS_CODE%TYPE,
    tSIMEI_NO                       IN  ZZ_PARTNER_ENTRY_WK.SIMEI_NO%TYPE,
    tPROC_TYPE                      IN  ZZ_PARTNER_ENTRY_WK.PROC_TYPE%TYPE
)
RETURN CHAR
IS
    vRET                            ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE;

BEGIN
    vRET := PCY_BATCH_MOUSIKOMI_UKETUKE.cvKEKKA_KBN_SUCCESS;

    IF tPROC_TYPE = '0' THEN
        -- 申込可能期間チェック（L02_CLASS_TBL.MOUSIKOMI_KAISIBI, MOUSIKOMI_SYURYOBI）
        vRET := F_CHECK_MOUSIKOMI_KIKAN(tKAMOKU_CODE, tCLASS_CODE);

        IF vRET = cvKEKKA_KBN_SUCCESS THEN
            -- 同一科目・クラスへの申込チェック
            vRET := F_CHECK_MOUSIKOMI(tKAMOKU_CODE, tCLASS_CODE, tSIMEI_NO);
        END IF;

        IF vRET = cvKEKKA_KBN_SUCCESS THEN
            -- 満席チェック
            vRET := F_CHECK_MOUSIKOMI_MANSEKI(tKAMOKU_CODE, tCLASS_CODE);
        END IF;
    ELSIF tPROC_TYPE = '1' THEN
        -- 申込取消期間チェック
        vRET := F_CHECK_MOUSIKOMI_CANCEL_KIKAN(tKAMOKU_CODE, tCLASS_CODE);
    ELSE
        vRET := cvKEKKA_KBN_EXCEPTION_ERR;
    END IF;

    RETURN vRET;

EXCEPTION
    WHEN OTHERS THEN
        RETURN cvKEKKA_KBN_EXCEPTION_ERR;

END F_CHECK_ENTRY_DATA;

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
)
RETURN CHAR
IS
    vZENSYA_TAISYO_FLG              L02_CLASS_TBL.ZENSYA_TAISYO_FLG%TYPE;
    vSYONIN_KUBUN                   L02_CLASS_TBL.SYONIN_KUBUN%TYPE;

BEGIN
    -- 「全社対象区分」・「承認区分」を取得
    SELECT ZENSYA_TAISYO_FLG, SYONIN_KUBUN INTO vZENSYA_TAISYO_FLG, vSYONIN_KUBUN FROM L02_CLASS_TBL WHERE KAMOKU_CODE = tKAMOKU_CODE AND CLASS_CODE = tCLASS_CODE;

    -- 「処理区分」が、'0（申込）'のとき
    IF tPROC_TYPE = cvSYORI_KBN_MOUSIKOMI THEN

        -- L15_申込状況ワークに"受講予定"としてレコード挿入
        P_INSERT_MOUSIKOMI_JYOKYO_WORK(tKAMOKU_CODE, tCLASS_CODE, tSIMEI_NO, tMOUSIKOMISYA, '1', '2');

        -- 全社対象区分が、"1:対象"のとき、[L14_対象者]テーブルにレコード作成
        IF vZENSYA_TAISYO_FLG = '1' THEN
            P_INSERT_TAISYOSHA_TBL(tKAMOKU_CODE, tCLASS_CODE, tSIMEI_NO);
        END IF;

        -- 承認区分が、"1:要"のとき、[L16_承認者]テーブルにレコード作成
        IF vSYONIN_KUBUN = '1' THEN
            P_INSERT_SYONINSYA_TBL(tSIMEI_NO, PCY_BATCH_MOUSIKOMI_UKETUKE.vPROC_ADMIN);
        END IF;
    ELSE
        -- 「処理区分」が、'1（取消）'のとき

        -- L15_申込状況ワークからレコード削除
        P_DELETE_MOUSIKOMI_JYOKYO_WORK(tKAMOKU_CODE, tCLASS_CODE, tSIMEI_NO);

        -- L94_申込削除履歴テーブルにレコード挿入
        P_INSERT_MOUSIKOMI_DEL_RIREKI(tKAMOKU_CODE, tCLASS_CODE, tSIMEI_NO);

        -- 全社対象区分が、"対象"のとき、[L14_対象者]テーブルからレコード削除
        IF vZENSYA_TAISYO_FLG = '1' THEN
            P_DELETE_TAISYOSHA_TBL(tKAMOKU_CODE, tCLASS_CODE, tSIMEI_NO);
        END IF;
    END IF;

    RETURN cvKEKKA_KBN_SUCCESS;

EXCEPTION
    WHEN OTHERS THEN
        RETURN PCY_BATCH_MOUSIKOMI_UKETUKE.cvKEKKA_KBN_EXCEPTION_ERR;

END F_MOUSIKOMI_ENTRY;

-------------------------------------------------------------------------------
-- 機能：申込可能期間チェック処理
-- 概要：申込受付データが申込可能期間内であるかのチェックを実行する
-- 引数：科目コード
--       クラスコード
-------------------------------------------------------------------------------
FUNCTION F_CHECK_MOUSIKOMI_KIKAN(
    tKAMOKU_CODE                    IN  ZZ_PARTNER_ENTRY_WK.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  ZZ_PARTNER_ENTRY_WK.CLASS_CODE%TYPE
) RETURN CHAR
IS
    vTODAY                          VARCHAR2(8);
    vCNT                            NUMBER;
    vRET                            ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE;

BEGIN
    vTODAY := getPROC_DATE(PCY_BATCH_MOUSIKOMI_UKETUKE.cvPROC_DATE);

    SELECT COUNT(*) INTO vCNT FROM L02_CLASS_TBL
    WHERE KAMOKU_CODE = tKAMOKU_CODE
    AND CLASS_CODE = tCLASS_CODE
    AND (MOUSIKOMI_KAISIBI <= vTODAY AND MOUSIKOMI_SYURYOBI >= vTODAY);

    IF vCNT = 0 THEN
        vRET := cvKEKKA_KBN_MOUSIKOMI_KIKAN_NG;
    ELSE
        vRET := cvKEKKA_KBN_CHECK_OK;
    END IF;

    RETURN vRET;

EXCEPTION
    WHEN OTHERS THEN
        RETURN PCY_BATCH_MOUSIKOMI_UKETUKE.cvKEKKA_KBN_EXCEPTION_ERR;

END F_CHECK_MOUSIKOMI_KIKAN;

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
) RETURN CHAR
IS
    vCNT                            NUMBER;
    vRET                            ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE;

BEGIN
    SELECT COUNT(*) INTO vCNT FROM ZZ_WK_L15_MOUSIKOMI_JYOKYO_TBL 
    WHERE KAMOKU_CODE = tKAMOKU_CODE AND CLASS_CODE = tCLASS_CODE AND SIMEI_NO = tSIMEI_NO;

    IF vCNT = 0 THEN
        vRET := cvKEKKA_KBN_CHECK_OK;
    ELSE
        vRET := cvKEKKA_KBN_EXIST_CHK_NG;
    END IF;

    RETURN vRET;

EXCEPTION
    WHEN OTHERS THEN
        RETURN PCY_BATCH_MOUSIKOMI_UKETUKE.cvKEKKA_KBN_EXCEPTION_ERR;

END F_CHECK_MOUSIKOMI;

-------------------------------------------------------------------------------
-- 機能：満席チェック処理
-- 概要：引数で指定された科目・クラスが満席であるかのチェックを実行する
-- 引数：科目コード
--       クラスコード
-------------------------------------------------------------------------------
FUNCTION F_CHECK_MOUSIKOMI_MANSEKI(
    tKAMOKU_CODE                    IN  ZZ_PARTNER_ENTRY_WK.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  ZZ_PARTNER_ENTRY_WK.CLASS_CODE%TYPE
) RETURN CHAR
IS
    vRET                            ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE;
    vTEIIN                          L02_CLASS_TBL.TEIIN%TYPE;

    vMOUSIKOMI                      NUMBER;

BEGIN
    vRET := cvKEKKA_KBN_CHECK_OK;

    -- L15_申込状況ワークの定員・申込人数を取得
    SELECT 
        COUNT(L02.CLASS_CODE) AS MOUSIKOMI,
        NVL(L02.TEIIN, 0) AS TEIIN
    INTO vMOUSIKOMI, vTEIIN
    FROM L02_CLASS_TBL L02
        INNER JOIN L15_MOUSIKOMI_JYOKYO_TBL L15 ON (L02.KAMOKU_CODE = L15.KAMOKU_CODE AND L02.CLASS_CODE = L15.CLASS_CODE)
    WHERE L02.KAMOKU_CODE = tKAMOKU_CODE
    AND L02.CLASS_CODE = tCLASS_CODE
    AND (L15.STATUS = '1' AND L15.UKETSUKE_JYOTAI = '2')
    GROUP BY L02.KAMOKU_CODE, L02.CLASS_CODE, L02.TEIIN;

    IF vTEIIN <> 0 THEN
        IF vTEIIN < (vMOUSIKOMI + 1) THEN
            vRET := cvKEKKA_KBN_MANSEKI_CHK_NG;
        END IF;
    END IF;

    RETURN vRET;

EXCEPTION
    WHEN OTHERS THEN
        RETURN PCY_BATCH_MOUSIKOMI_UKETUKE.cvKEKKA_KBN_EXCEPTION_ERR;

END F_CHECK_MOUSIKOMI_MANSEKI;

-------------------------------------------------------------------------------
-- 機能：申込取消期間チェック処理
-- 概要：申込受付データが取消可能期間内であるかのチェックを実行する
-- 引数：科目コード
--       クラスコード
-------------------------------------------------------------------------------
FUNCTION F_CHECK_MOUSIKOMI_CANCEL_KIKAN(
    tKAMOKU_CODE                    IN  ZZ_PARTNER_ENTRY_WK.KAMOKU_CODE%TYPE,
    tCLASS_CODE                     IN  ZZ_PARTNER_ENTRY_WK.CLASS_CODE%TYPE
) RETURN CHAR
IS
    vTODAY                          VARCHAR2(8);
    vCNT                            NUMBER;
    vRET                            ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE;

BEGIN
    vTODAY := getPROC_DATE(PCY_BATCH_MOUSIKOMI_UKETUKE.cvPROC_DATE);

    SELECT COUNT(*) INTO vCNT FROM L02_CLASS_TBL L02_CLS
        LEFT JOIN L02_CANCEL_KIKAN L02_CANCEL ON L02_CLS.KAMOKU_CODE = L02_CANCEL.KAMOKU_CODE AND L02_CLS.CLASS_CODE = L02_CANCEL.CLASS_CODE
    WHERE L02_CLS.KAMOKU_CODE = tKAMOKU_CODE AND L02_CLS.CLASS_CODE = tCLASS_CODE
    AND L02_CANCEL.KAISIBI <= vTODAY AND L02_CANCEL.SYURYOBI >= vTODAY;

    IF vCNT = 0 THEN
        vRET := cvKEKKA_KBN_TORIKESI_KIKAN_NG;
    ELSE
        vRET := cvKEKKA_KBN_CHECK_OK;
    END IF;

    RETURN vRET;

EXCEPTION
    WHEN OTHERS THEN
        RETURN PCY_BATCH_MOUSIKOMI_UKETUKE.cvKEKKA_KBN_EXCEPTION_ERR;

END F_CHECK_MOUSIKOMI_CANCEL_KIKAN;

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
)
IS
BEGIN
    UPDATE ZZ_PARTNER_ENTRY_WK SET PROC_RESULT = tPROC_RESULT 
    WHERE PROC_GRP_NO = tPROC_GRP_NO AND PROC_ORDER = tPROC_ORDER;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END P_UPDATE_PROC_RESULT;

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
)
IS
BEGIN
    INSERT INTO ZZ_WK_L15_MOUSIKOMI_JYOKYO_TBL
    (
        KAMOKU_CODE,
        CLASS_CODE,
        SIMEI_NO,
        STATUS,
        UKETSUKE_JYOTAI,
        MOUSIKOMIBI,
        MOUSIKOMIJIKOKU,
        MOUSIKOMISYA,
        SEIKYU_FLG,
        TOUROKUBI,
        TOUROKUJIKOKU,
        TOUROKUSYA,
        KOUSINBI,
        KOUSINJIKOKU,
        KOUSINSYA
    ) VALUES (
        tKAMOKU_CODE,
        tCLASS_CODE,
        tSIMEI_NO,
        tSTATUS,
        tUKETUKE_JYOTAI,
        getPROC_DATE(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
        getPROC_TIME(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
        tMOUSIKOMISYA,
        PCY_BATCH_MOUSIKOMI_UKETUKE.cvDEF_L15_SEIKYU_FLG,
        getPROC_DATE(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
        getPROC_TIME(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
        PCY_BATCH_MOUSIKOMI_UKETUKE.vBATCH_USER_NAME,
        getPROC_DATE(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
        getPROC_TIME(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
        PCY_BATCH_MOUSIKOMI_UKETUKE.vBATCH_USER_NAME
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END P_INSERT_MOUSIKOMI_JYOKYO_WORK;

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
)
IS
    vCNT                            NUMBER;

BEGIN
    -- 同一キーのレコードがあればなにもしない
    SELECT COUNT(*) INTO vCNT FROM L14_TAISYOSYA_TBL WHERE KAMOKU_CODE = tKAMOKU_CODE AND CLASS_CODE = tCLASS_CODE AND SIMEI_NO = tSIMEI_NO;

    IF vCNT = 0 THEN
        INSERT INTO L14_TAISYOSYA_TBL
        (
            KAMOKU_CODE,
            CLASS_CODE,
            SIMEI_NO,
            TAISYO_KUBUN,
            TOUROKUBI,
            TOUROKUJIKOKU,
            TOUROKUSYA,
            KOUSINBI,
            KOUSINJIKOKU,
            KOUSINSYA
        ) VALUES(
            tKAMOKU_CODE,
            tCLASS_CODE,
            tSIMEI_NO,
            PCY_BATCH_MOUSIKOMI_UKETUKE.cvDEF_L14_TAISYO_KUBUN,
            getPROC_DATE(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
            getPROC_TIME(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
            PCY_BATCH_MOUSIKOMI_UKETUKE.vBATCH_USER_NAME,
            getPROC_DATE(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
            getPROC_TIME(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
            PCY_BATCH_MOUSIKOMI_UKETUKE.vBATCH_USER_NAME
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END P_INSERT_TAISYOSHA_TBL;

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
)
IS
BEGIN
    DELETE FROM L14_TAISYOSYA_TBL WHERE KAMOKU_CODE = tKAMOKU_CODE AND CLASS_CODE = tCLASS_CODE AND SIMEI_NO = tSIMEI_NO;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END P_DELETE_TAISYOSHA_TBL;

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
)
IS
BEGIN
    INSERT INTO L94_MOUSIKOMI_DEL_RIREKI_TBL
    (
        SYORIBI,
        SYORIJIKOKU,
        SYORISYA,
        SYORI_FLG,
        SIMEI_NO,
        KAMOKU_CODE,
        KAMOKU_MEI1,
        KAMOKU_MEI2,
        KAMOKU_MEI3,
        KAMOKU_MEI4,
        VERSION_KANRI,
        KAMOKU_GROUP,
        KAMOKU_GROUP_MEI,
        CATEGORY_CODE1,
        CATEGORY_MEI1,
        CATEGORY_CODE2,
        CATEGORY_MEI2,
        CATEGORY_CODE3,
        CATEGORY_MEI3,
        CATEGORY_CODE4,
        CATEGORY_MEI4,
        CATEGORY_CODE5,
        CATEGORY_MEI5,
        KANRIMOTO_CODE,
        KANRIMOTO_MEI,
        TANKA,
        KAMOKU_NAIYOU,
        JYUKOU_JYOKEN,
        YOBI1,
        YOBI2,
        CLASS_CODE,
        CLASS_MEI,
        NISSUU,
        KAISIBI,
        SYURYOBI,
        KAISAIJIKAN,
        KAISIJIKOKU,
        SYURYOJIKOKU,
        MOUSIKOMI_KAISIBI,
        MOUSIKOMI_SYURYOBI,
        JYUKOU_KIGEN,
        CHIKU_CODE,
        CHIKU_MEI,
        KYOSITU_CODE,
        KYOSITU_MEI,
        TEIIN,
        KAISAI_SAISYO_NINZUU,
        KOUSI_CODE,
        KOUSI_MEI,
        KISYO_IKKATSU_FLG,
        ZENSYA_TAISYO_FLG,
        MOUSIKOMI_KUBUN,
        SYONIN_KUBUN,
        UKETUKE_KUBUN,
        HOUKOKU_KUBUN,
        NINSYO_KUBUN,
        HANTEI_KUBUN,
        KAISAI_JYOTAI,
        ANNAI_MAIL_KUBUN,
        FOLLOW_MAIL_KUBUN,
        FOLLOW_MAIL_NISSUU1,
        FOLLOW_MAIL_NISSUU2,
        BIKOU,
        TAISYO_KUBUN,
        MOUSIKOMIBI,
        MOUSIKOMIJIKOKU,
        MOUSIKOMISYA,
        SYONINBI1,
        SYONINJIKOKU1,
        SYONINSYA1,
        SYONINBI2,
        SYONINJIKOKU2,
        SYONINSYA2,
        UKETUKEBI,
        UKETUKEJIKOKU,
        UKETUKESYA
    )
    SELECT
        getPROC_DATE(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
        getPROC_TIME(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
        PCY_BATCH_MOUSIKOMI_UKETUKE.vPROC_ADMIN,
        PCY_BATCH_MOUSIKOMI_UKETUKE.cvDEF_L94_SYORI_FLG,
        tSIMEI_NO,
        KAMOKU.KAMOKU_CODE KAMOKU_CODE,
        KAMOKU.KAMOKU_MEI1 KAMOKU_MEI1,
        KAMOKU.KAMOKU_MEI2 KAMOKU_MEI2,
        KAMOKU.KAMOKU_MEI3 KAMOKU_MEI3,
        KAMOKU.KAMOKU_MEI4 KAMOKU_MEI4,
        KAMOKU.VERSION_KANRI VERSION_KANRI,
        KAMOKU.KAMOKU_GROUP KAMOKU_GROUP,
        KAMOKU_GRP.KAMOKU_GROUP KAMOKU_GROUP,
        KAMOKU.CATEGORY_CODE1 CATEGORY_CODE1,
        CAT1.CATEGORY_MEI1 CATEGORY_MEI1,
        KAMOKU.CATEGORY_CODE2 CATEGORY_CODE2,
        CAT2.CATEGORY_MEI2 CATEGORY_MEI2,
        KAMOKU.CATEGORY_CODE3 CATEGORY_CODE3,
        CAT3.CATEGORY_MEI3 CATEGORY_MEI3,
        KAMOKU.CATEGORY_CODE4 CATEGORY_CODE4,
        CAT4.CATEGORY_MEI4 CATEGORY_MEI4,
        KAMOKU.CATEGORY_CODE5 CATEGORY_CODE5,
        CAT5.CATEGORY_MEI5 CATEGORY_MEI5,
        KAMOKU.KANRIMOTO_CODE KANRIMOTO_CODE,
        KANRI.KANRIMOTO_MEI KANRIMOT_MEI,
        KAMOKU.TANKA TANKA,
        KAMOKU.KAMOKU_NAIYOU KAMOKU_NAIYOU,
        KAMOKU.JYUKOU_JYOKEN JYUKOU_JYOKEN,
        KAMOKU.YOBI1 YOBI1,
        KAMOKU.YOBI2 YOBI2,
        CLS.CLASS_CODE CLASS_CODE,
        CLS.CLASS_MEI CLASS_MEI,
        CLS.NISSUU NISSUU,
        CLS.KAISIBI KAISIBI,
        CLS.SYURYOBI SYURYOBI,
        CLS.KAISAIJIKAN KAISAIJIKAN,
        CLS.KAISIJIKOKU KAISIJIKOKU,
        CLS.SYURYOJIKOKU SYURYOJIKOKU,
        CLS.MOUSIKOMI_KAISIBI MOUSIKOMI_KAISIBI,
        CLS.MOUSIKOMI_SYURYOBI MOUSIKOMI_SYURYOBI,
        CLS.JYUKOU_KIGEN JYUKOU_KIGEN,
        CLS.CHIKU_CODE CHIKU_CODE,
        CLS.CHIKU_MEI CHIKU_MEI,
        CLS.KYOSITU_CODE KYOSITU_CODE,
        CLS.KYOSITU_MEI KYOSITU_MEI,
        CLS.TEIIN TEIIN,
        CLS.KAISAI_SAISYO_NINZUU KAISAI_SAISYO_NINZUU,
        CLS.KOUSI_CODE KOUSI_CODE,
        CLS.KOUSI_MEI KOUSI_MEI,
        CLS.KISYO_IKKATSU_FLG KISYO_IKKATSU_FLG,
        CLS.ZENSYA_TAISYO_FLG ZENSYA_TAISYO_FLG,
        CLS.MOUSIKOMI_KUBUN MOUSIKOMI_KUBUN,
        CLS.SYONIN_KUBUN SYONIN_KUBUN,
        CLS.UKETUKE_KUBUN UKETUKE_KUBUN,
        CLS.HOUKOKU_KUBUN HOUKOKU_KUBUN,
        CLS.NINSYO_KUBUN NINSYO_KUBUN,
        CLS.HANTEI_KUBUN HANTEI_KUBUN,
        CLS.KAISAI_JYOTAI KAISAI_JYOTAI,
        CLS.ANNAI_MAIL_KUBUN ANNAI_MAIL_KUBUN,
        CLS.FOLLOW_MAIL_KUBUN FOLLOW_MAIL_KUBUN,
        CLS.FOLLOW_MAIL_NISSUU1 FOLLOW_MAIL_NISSUU1,
        CLS.FOLLOW_MAIL_NISSUU2 FOLLOW_MAIL_NISSUU2,
        CLS.BIKOU BIKOU,
        TAISYOSYA.TAISYO_KUBUN TAISYO_KUBUN,
        MOUSIKOMI.MOUSIKOMIBI MOUSIKOMIBI,
        MOUSIKOMI.MOUSIKOMIJIKOKU MOUSIKOMIJIKOKU,
        MOUSIKOMI.MOUSIKOMISYA MOUSIKOMISYA,
        MOUSIKOMI.SYONINBI1 SYONINBI1,
        MOUSIKOMI.SYONINJIKOKU1 SYONINJIKOKU1,
        MOUSIKOMI.SYONINSYA1 SYONINSYA1,
        MOUSIKOMI.SYONINBI2 SYONINBI2,
        MOUSIKOMI.SYONINJIKOKU2 SYONINJIKOKU2,
        MOUSIKOMI.SYONINSYA2 SYONINSYA2,
        MOUSIKOMI.UKETUKEBI UKETUKEBI,
        MOUSIKOMI.UKETUKEJIKOKU UKETUKEJIKOKU,
        MOUSIKOMI.UKETUKESYA UKETUKESYA
    FROM ZZ_WK_L15_MOUSIKOMI_JYOKYO_TBL MOUSIKOMI
        LEFT JOIN L01_KAMOKU_TBL KAMOKU ON MOUSIKOMI.KAMOKU_CODE = KAMOKU.KAMOKU_CODE
        LEFT JOIN L02_CLASS_TBL CLS ON MOUSIKOMI.KAMOKU_CODE = CLS.KAMOKU_CODE AND MOUSIKOMI.CLASS_CODE = CLS.CLASS_CODE
        LEFT JOIN L14_TAISYOSYA_TBL TAISYOSYA ON MOUSIKOMI.KAMOKU_CODE = TAISYOSYA.KAMOKU_CODE AND MOUSIKOMI.CLASS_CODE = TAISYOSYA.CLASS_CODE AND MOUSIKOMI.SIMEI_NO = TAISYOSYA.SIMEI_NO
        LEFT JOIN P15_C_KAMOKU_GROUP_TBL KAMOKU_GRP ON KAMOKU.KAMOKU_GROUP = KAMOKU_GRP.KAMOKU_GROUP_CODE
        LEFT JOIN L03_CATEGORY1_TBL CAT1 ON KAMOKU.CATEGORY_CODE1 = CAT1.CATEGORY_CODE1
        LEFT JOIN L04_CATEGORY2_TBL CAT2 ON KAMOKU.CATEGORY_CODE2 = CAT2.CATEGORY_CODE2
        LEFT JOIN L05_CATEGORY3_TBL CAT3 ON KAMOKU.CATEGORY_CODE3 = CAT3.CATEGORY_CODE3
        LEFT JOIN L06_CATEGORY4_TBL CAT4 ON KAMOKU.CATEGORY_CODE4 = CAT4.CATEGORY_CODE4
        LEFT JOIN L07_CATEGORY5_TBL CAT5 ON KAMOKU.CATEGORY_CODE5 = CAT5.CATEGORY_CODE5
        LEFT JOIN L08_KANRIMOTO_TBL KANRI ON KAMOKU.KANRIMOTO_CODE = KANRI.KANRIMOTO_CODE;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END P_INSERT_MOUSIKOMI_DEL_RIREKI;

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
)
IS
BEGIN
    DELETE FROM ZZ_WK_L15_MOUSIKOMI_JYOKYO_TBL WHERE KAMOKU_CODE = tKAMOKU_CODE AND CLASS_CODE = tCLASS_CODE AND SIMEI_NO = tSIMEI_NO;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END P_DELETE_MOUSIKOMI_JYOKYO_WORK;

-------------------------------------------------------------------------------
-- 機能：承認者テーブル登録処理
-- 概要：L16_承認者テーブルにレコードを新規登録する
-- 引数：氏名No
--       承認者1
-------------------------------------------------------------------------------
PROCEDURE P_INSERT_SYONINSYA_TBL(
    tSIMEI_NO                       IN  L16_SYONINSYA_TBL.SIMEI_NO%TYPE,
    tSYONINSHA                      IN  L16_SYONINSYA_TBL.SYONINSYA1%TYPE
)
IS
    vCNT                            NUMBER;

BEGIN
    SELECT COUNT(*) INTO vCNT FROM L16_SYONINSYA_TBL WHERE SIMEI_NO = tSIMEI_NO;

    -- [L16_承認者]テーブルに登録済みのときはなにもしない
    IF vCNT = 0 THEN
        INSERT INTO L16_SYONINSYA_TBL
        (
            SIMEI_NO,
            SYONINSYA1,
            DAIKOUSYA_FLG,
            TOUROKUBI,
            TOUROKUJIKOKU,
            TOUROKUSYA,
            KOUSINBI,
            KOUSINJIKOKU,
            KOUSINSYA
        ) VALUES
        (
            tSIMEI_NO,
            tSYONINSHA,
            PCY_BATCH_MOUSIKOMI_UKETUKE.cvDEF_L16_DAIKOUSYA_FLG,
            getPROC_DATE(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
            getPROC_TIME(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
            PCY_BATCH_MOUSIKOMI_UKETUKE.vBATCH_USER_NAME,
            getPROC_DATE(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
            getPROC_TIME(PCY_BATCH_MOUSIKOMI_UKETUKE.cvCURRENT_DATE),
            PCY_BATCH_MOUSIKOMI_UKETUKE.vBATCH_USER_NAME
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END P_INSERT_SYONINSYA_TBL;

-------------------------------------------------------------------------------
-- 機能：申込ワークデータコピー処理
-- 概要：L15_申込状況ワークテーブルのデータをL15_申込状況にコピーする
-- 引数：
-------------------------------------------------------------------------------
FUNCTION F_COPY_WORK_TO_MOUSIKOMI_TBL
RETURN VARCHAR2
IS
    vRET                            VARCHAR2(4);

    vMAX_UPD_DATE                   NUMBER;
    vCOMPARE_DATE                   NUMBER;

BEGIN
    -- L15_申込状況の最新の更新日時を取得
    SELECT MAX(TO_NUMBER(NVL(L15.KOUSINBI, '0') || NVL(L15.KOUSINJIKOKU, '0'))) AS UPDATE_DATE INTO vMAX_UPD_DATE
    FROM L15_MOUSIKOMI_JYOKYO_TBL L15
        LEFT JOIN 
        (
            SELECT DISTINCT KAMOKU_CODE, CLASS_CODE FROM ZZ_WK_L15_MOUSIKOMI_JYOKYO_TBL
        ) WK ON L15.KAMOKU_CODE = WK.KAMOKU_CODE AND L15.CLASS_CODE = WK.CLASS_CODE;

    vCOMPARE_DATE := TO_NUMBER(vPROC_START_TIME);

    IF (vCOMPARE_DATE - vMAX_UPD_DATE) > 0 THEN
        -- L15_申込状況から、L15_申込状況ワークに存在する科目・クラスコードが一致するレコードを削除＆挿入
        DELETE FROM L15_MOUSIKOMI_JYOKYO_TBL L15
        WHERE EXISTS 
        (
            SELECT DISTINCT KAMOKU_CODE, CLASS_CODE FROM ZZ_WK_L15_MOUSIKOMI_JYOKYO_TBL
        );

        INSERT INTO L15_MOUSIKOMI_JYOKYO_TBL SELECT * FROM ZZ_WK_L15_MOUSIKOMI_JYOKYO_TBL;

        vRET := PCY_BATCH_MOUSIKOMI_UKETUKE.cvGRP_KEKKA_KBN_SUCCESS;
    ELSE
        -- バッチ処理開始時間よりもあとに更新されたデータがL15_申込状況に存在する場合、排他エラーとみなす
        vRET := PCY_BATCH_MOUSIKOMI_UKETUKE.cvGRP_KEKKA_KBN_EXCLUSIVE_ERR;
    END IF;

    RETURN vRET;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END F_COPY_WORK_TO_MOUSIKOMI_TBL;

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
)
IS
BEGIN
    UPDATE ZZ_PARTNER_ENTRY_STATUS SET STATUS = tSTATUS, PROC_RESULT = tPROC_RESULT WHERE PROC_GRP_NO = tPROC_GRP_NO;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END P_UPDATE_PARTNER_ENTRY_STATUS;

-------------------------------------------------------------------------------
-- 機能：処理開始日の取得処理
-- 概要：処理開始日時または現在日付から年月日を切り出し返す
-- 引数：取得タイプ（0:処理開始日時、1:現在日付）
-------------------------------------------------------------------------------
FUNCTION getPROC_DATE(
    tGET_TYPE                       IN  CHAR
)
RETURN VARCHAR2
IS
    vDATE                           VARCHAR2(8);

BEGIN
    IF tGET_TYPE = PCY_BATCH_MOUSIKOMI_UKETUKE.cvPROC_DATE THEN
        vDATE := SUBSTR(vPROC_START_TIME, 1, 8);
    ELSE
        vDATE := TO_CHAR(SYSDATE, 'YYYYMMDD');
    END IF;

    RETURN vDATE;

END getPROC_DATE;

-------------------------------------------------------------------------------
-- 機能：処理開始時刻の取得処理
-- 概要：処理開始日時または現在日時から時分秒を切り出し返す
-- 引数：取得タイプ（0:処理開始日時、1:現在日付）
-------------------------------------------------------------------------------
FUNCTION getPROC_TIME(
    tGET_TYPE                       IN  CHAR
)
RETURN VARCHAR2
IS
    vTIME                           VARCHAR2(8);

BEGIN
    IF tGET_TYPE = PCY_BATCH_MOUSIKOMI_UKETUKE.cvPROC_DATE THEN
        vTIME := SUBSTR(vPROC_START_TIME, 9, 6);
    ELSE
        vTIME := TO_CHAR(SYSDATE, 'HH24MMSS');
    END IF;

    RETURN vTIME;

END getPROC_TIME;

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
)
IS
    PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
    UPDATE ZZ_BATCH_SEIGYO_TBL SET STATUS = tSTATUS WHERE BATCH_NAME = tBATCH_NAME;

    COMMIT;

END UPDATE_BATCH_SEIGYO_TBL;

-------------------------------------------------------------------------------
-- 機能：処理中フラグ取得処理
-- 概要：バッチの処理中フラグを取得する
-- 引数：
-------------------------------------------------------------------------------
FUNCTION GET_BATCH_STATUS(
    tBATCH_NAME                     IN  ZZ_BATCH_SEIGYO_TBL.BATCH_NAME%TYPE
)
RETURN CHAR
IS
    vRET                            ZZ_BATCH_SEIGYO_TBL.STATUS%TYPE;

BEGIN
    SELECT STATUS INTO vRET FROM ZZ_BATCH_SEIGYO_TBL WHERE BATCH_NAME = tBATCH_NAME;

    RETURN vRET;

END GET_BATCH_STATUS;

-------------------------------------------------------------------------------
-- 機能：エラーメッセージ取得処理
-- 概要：指定されたエラーメッセージを取得する
-- 引数：エラーコード
-------------------------------------------------------------------------------
FUNCTION GET_CHECK_ERR_MSG(
    tERR_CODE                       IN  ZZ_PARTNER_ENTRY_WK.PROC_RESULT%TYPE
)
RETURN VARCHAR2
IS
    vERR_MSG                        VARCHAR2(128);

BEGIN
    CASE tERR_CODE
        WHEN '2' THEN vERR_MSG := PCY_BATCH_MOUSIKOMI_UKETUKE.cvMSG_MOUSIKOMI_KIKAN_ERR;
        WHEN '3' THEN vERR_MSG := PCY_BATCH_MOUSIKOMI_UKETUKE.cvMSG_ALREADY_ENTRY_ERR;
        WHEN '4' THEN vERR_MSG := PCY_BATCH_MOUSIKOMI_UKETUKE.cvMSG_MANSEKI_ERR;
        WHEN '5' THEN vERR_MSG := PCY_BATCH_MOUSIKOMI_UKETUKE.cvMSG_CANCEL_KIKAN_ERR;
        WHEN '9' THEN vERR_MSG := PCY_BATCH_MOUSIKOMI_UKETUKE.cvMSG_UNEXPECTED_ERR;
        ELSE vERR_MSG := '';
    END CASE;

    RETURN vERR_MSG;

END GET_CHECK_ERR_MSG;

-------------------------------------------------------------------------------
-- 機能：ログファイルオープン
-- 概要：ログファイルを作成し、オープンする
-- 引数：
-------------------------------------------------------------------------------
PROCEDURE LOG_FILE_OPEN
IS
    vLOG_OUT_DIR                    VARCHAR2(255);
    vLOG_FILE_NAME                  VARCHAR2(64);

BEGIN
    -- CCP_PARAMよりログ出力ディレクトリを取得
    SELECT PARAM_VALUE INTO vLOG_OUT_DIR FROM CCP_PARAM WHERE PARAM_BUNRUI_NM = 'Base' AND PARAM_ID = 'MOUSIKOMI_BATCH_LOG_DIR';

    -- 出力ファイル名を取得    
    vLOG_FILE_NAME := REPLACE(PCY_BATCH_MOUSIKOMI_UKETUKE.cvLOG_FILE_TEMPLATE, '{0}', TO_CHAR(SYSDATE, 'yyyymmddhh24miss'));

    -- ログファイルオープン
    vLOG_FILE_HANDLE := UTL_FILE.FOPEN(vLOG_OUT_DIR, vLOG_FILE_NAME, 'w', 32767);

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END LOG_FILE_OPEN;

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
)
IS
    vMSG                            VARCHAR2(1024);
    vMSG_TYPE_STR                   VARCHAR2(20);

BEGIN
    IF UTL_FILE.IS_OPEN(vLOG_FILE_HANDLE) = TRUE THEN
        CASE tLOG_TYPE
            WHEN '0' THEN vMSG_TYPE_STR := PCY_BATCH_MOUSIKOMI_UKETUKE.cvMSG_TYPE_INFO;
            WHEN '1' THEN vMSG_TYPE_STR := PCY_BATCH_MOUSIKOMI_UKETUKE.cvMSG_TYPE_ERROR;
            WHEN '2' THEN vMSG_TYPE_STR := PCY_BATCH_MOUSIKOMI_UKETUKE.cvMSG_TYPE_WARNING;
            ELSE vMSG_TYPE_STR := '';
        END CASE;

        vMSG := REPLACE(PCY_BATCH_MOUSIKOMI_UKETUKE.cvMSG_TEMPLATE, '{0}', TO_CHAR(SYSDATE, 'yyyy-mm-dd HH24:MI:SS'));
        vMSG := REPLACE(vMSG, '{1}', vMSG_TYPE_STR);
        vMSG := REPLACE(vMSG, '{2}', tPROC_GRP_NO);
        vMSG := REPLACE(vMSG, '{3}', tPROC_ORDER);
        vMSG := REPLACE(vMSG, '{4}', tLOG_MSG);

        UTL_FILE.PUT_LINE(vLOG_FILE_HANDLE, vMSG);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        LOG_FILE_CLOSE;

END P_OUTPUT_LOG;

-------------------------------------------------------------------------------
-- 機能：ログファイルクローズ
-- 概要：ログファイルを閉じる
-- 引数：
-------------------------------------------------------------------------------
PROCEDURE LOG_FILE_CLOSE
IS
BEGIN
    IF UTL_FILE.IS_OPEN(vLOG_FILE_HANDLE) = TRUE THEN
        UTL_FILE.FCLOSE(vLOG_FILE_HANDLE);
    END IF;

END LOG_FILE_CLOSE;

FUNCTION TEST_MAIN(
    vUSER_NAME                  IN  VARCHAR2
) RETURN NUMBER
IS
    vCNT                        NUMBER := 0;

BEGIN
    UPDATE ZZ_BATCH_SEIGYO_TBL SET STATUS = '9' WHERE BATCH_NAME = PCY_BATCH_MOUSIKOMI_UKETUKE.vBatchID;

    COMMIT;

    RETURN vCNT;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;

END TEST_MAIN;

END PCY_BATCH_MOUSIKOMI_UKETUKE;