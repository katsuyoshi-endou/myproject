CREATE OR REPLACE PACKAGE BODY PLPKG_CONVERT_SIMEI_NO AS

FUNCTION MAIN RETURN NUMBER
AS
    vRETURN             NUMBER;

BEGIN
    -- 実行前チェック処理
    vRETURN := CHECK_PROCESS_MAIN_PROC_EXECUTE();
    IF vRETURN <> 0 THEN
        RETURN vRETURN;
    END IF;

    -- 打替え対象社員情報（CONV_PERSONAL_TBL）のレコード作成処理
    vRETURN := CREATE_CONV_PERSONAL_TBL();
    IF vRETURN <> 0 THEN
        ROLLBACK;

        RETURN vRETURN;
    END IF;
    
    COMMIT;    

    RETURN 0;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        
        RETURN 1;

END MAIN;

-- 打ち替えメイン処理の実行前のチェック
FUNCTION CHECK_PROCESS_MAIN_PROC_EXECUTE RETURN NUMBER
AS
    vRTN_CODE           NUMBER;
    vREC_CNT1           PLS_INTEGER;
    vREC_CNT2           PLS_INTEGER;

BEGIN
    vRTN_CODE := 0;

    --打替え用のワークテーブルの両方、もしくは一方にレコードがなければ何もしない
    SELECT COUNT(*) INTO vREC_CNT1 FROM CONV_RULE_TBL;

    SELECT COUNT(*) INTO vREC_CNT2 FROM CONV_TARGET_COLUMN_TBL;

    IF vREC_CNT1 = 0 OR vREC_CNT2 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('');
        vRTN_CODE := 1;
    END IF;

    RETURN vRTN_CODE;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END CHECK_PROCESS_MAIN_PROC_EXECUTE;

-- 打替え対象社員情報（CONV_PERSONAL_TBL）のレコード作成処理
FUNCTION CREATE_CONV_PERSONAL_TBL RETURN NUMBER
AS
    vREC_CNT            PLS_INTEGER;

    -- CONV_PERSONAL_TBL用カーソル定義
    CURSOR curPERSONAL_INFO
    IS
        SELECT TRIM(SIMEI_NO) AS SIMEI_NO FROM T01_PERSONAL_TBL;

    -- CONV_RULE_TBL用カーソル定義
    CURSOR curCONV_RULE
    IS
        SELECT 
            OLD_SIMEI_NO,
            NEW_SIMEI_NO  
        FROM CONV_RULE_TBL;

BEGIN
    -- 打ち替え対象社員情報テーブルのレコードクリア
    DELETE FROM CONV_PERSONAL_TBL;
    
    -- T01_PERSONAL_TBLにいる社員をすべて打替え対象社員情報テーブル（CONV_PERSONAL_TBL）へコピー
    -- このとき「新氏名No」は、一律'0900' + （旧）氏名Noで格納する
    FOR recPERSONAL IN curPERSONAL_INFO LOOP
        IF LENGTH(recPERSONAL.SIMEI_NO) <= 6 THEN
            INSERT INTO CONV_PERSONAL_TBL( OLD_SIMEI_NO, NEW_SIMEI_NO ) VALUES( recPERSONAL.SIMEI_NO, '0900' || recPERSONAL.SIMEI_NO );
        ELSE
            -- '0900'を付加すると桁あふれを起こす場合は、ログを出力して次へ
            DBMS_OUTPUT.PUT_LINE('10桁を超えそうです！！ >> ' || recPERSONAL.SIMEI_NO);
        END IF;
    END LOOP;

    -- 打替えルールに載っている人はここで「新氏名No」を正しいIDで上書き
    FOR recCONV_RULE IN curCONV_RULE LOOP
        UPDATE CONV_PERSONAL_TBL SET NEW_SIMEI_NO = recCONV_RULE.NEW_SIMEI_NO WHERE OLD_SIMEI_NO = recCONV_RULE.OLD_SIMEI_NO;
        
        vREC_CNT := SQL%ROWCOUNT;
        IF vREC_CNT = 0 THEN
            -- 更新件数が、0件のときは打替えルールに載っているが対象がいないというログを出力
            DBMS_OUTPUT.PUT_LINE('みつからないよ！！');
        END IF;
    END LOOP;

    RETURN 0;
    
EXCEPTION
    WHEN OTHERS THEN
        IF curPERSONAL_INFO%ISOPEN THEN
            CLOSE curPERSONAL_INFO;
        END IF;

        IF curCONV_RULE%ISOPEN THEN
            CLOSE curCONV_RULE;
        END IF;

        RAISE;

END CREATE_CONV_PERSONAL_TBL;

-- 「氏名No」項目の更新処理
FUNCTION UPDATE_SIMEINO_COLUMNS RETURN NUMBER
AS
    vSQL        VARCHAR2(1000);

    -- 打替え対象社員情報テーブル用のカーソル定義
    CURSOR curCONV_PERSONAL
    IS
        SELECT
            OLD_SIMEI_NO,
            NEW_SIMEI_NO
        FROM CONV_PERSONAL_TBL;

    -- 打替え先カラム情報テーブル用のカーソル定義
    CURSOR curCONV_COLUMNS
    IS
        SELECT
            TABLE_NAME,
            COLUMN_NAME
        FROM CONV_TARGET_COLUMN_TBL 
        WHERE CONV_FLG = '1' 
        ORDER BY TABLE_NAME, COLUMN_NAME;

BEGIN
    FOR recPERSONAL_INFO IN curCONV_PERSONAL LOOP
        FOR recCONV_COLUMN IN curCONV_COLUMNS LOOP
            vSQL := 'UPDATE ' || recCONV_COLUMN.TABLE_NAME || ' SET ' || recCONV_COLUMN.COLUMN_NAME || ' = :NEW_ID WHERE ' || recCONV_COLUMN.COLUMN_NAME || ' = ' || recPERSONAL_INFO.OLD_SIMEI_NO;

            IF ( recCONV_COLUMN.TABLE_NAME = 'PERSONAL_PROFILE_IMPORT' AND recCONV_COLUMN.COLUMN_NAME = 'SIMEI_NO_FLG' ) OR ( recCONV_COLUMN.TABLE_NAME = 'T01_PERSONAL_TBL' AND recCONV_COLUMN.COLUMN_NAME = 'SIMEI_NO_FLG' ) THEN
                -- 上記のテーブル・カラムについてのみ形式が、'3' + 氏名Noとなる
                EXECUTE IMMEDIATE vSQL USING '3' || recPERSONAL_INFO.NEW_SIMEI_NO;
            ELSE
                EXECUTE IMMEDIATE vSQL USING recPERSONAL_INFO.NEW_SIMEI_NO;
            END IF;
        END LOOP;
    END LOOP;

    RETURN 0;

EXCEPTION
    WHEN OTHERS THEN
        IF curCONV_PERSONAL%ISOPEN THEN
            CLOSE curCONV_PERSONAL;
        END IF;

        IF curCONV_COLUMNS%ISOPEN THEN
            CLOSE curCONV_COLUMNS;
        END IF;

        RAISE;

END UPDATE_SIMEINO_COLUMNS;

END PLPKG_CONVERT_SIMEI_NO;
/
