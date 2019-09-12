CREATE OR REPLACE PACKAGE PLPKG_CONVERT_SIMEI_NO AS 

-- パッケージ名
cvFunctionName              CONSTANT VARCHAR2(40) := 'PLPKG_CONVERT_SIMEI_NO';

-----------------------------------------------
-- 機能   ：氏名No打ち替えメイン処理
-- 戻り値 ：終了コード
-----------------------------------------------
FUNCTION MAIN RETURN NUMBER;

-- 打ち替えメイン処理の実行前のチェック
FUNCTION CHECK_PROCESS_MAIN_PROC_EXECUTE RETURN NUMBER;

-- 打替え対象社員情報（CONV_PERSONAL_TB）Lのレコード作成処理
FUNCTION CREATE_CONV_PERSONAL_TBL RETURN NUMBER;

-- 「氏名No」項目の更新処理
FUNCTION UPDATE_SIMEINO_COLUMNS RETURN NUMBER;

END PLPKG_CONVERT_SIMEI_NO;
/
