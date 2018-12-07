Attribute VB_Name = "ConstModule"
' メッセージ関連の共通モジュール
' ツール内で使用するメッセージ類をここで定義する
Option Explicit


' 共通メッセージ
Public Const ERR_RAISED_MSG As String = "エラーが発生しました。"

Public Const ERR_SHEET_NOT_SELECTED As String = "メインシートにて、エラーチェックまたは登録対象のシートが設定されていません。"
Public Const ERR_SHEET_NENDO_NOT_INPUT As String = "メインシートにて、エラーチェックまたは登録対象の「年度」が指定されていません"


' ユーザ定義エラー番号＆メッセージ（ユーザ定義のエラー番号は513-65535のあいだ）
' Oracle パッケージ呼び出しエラー
Public Const USER_ERR_CD_PACKAGE_CALL As Long = 555
Public Const USER_ERR_MSG_PACKAGE_CALL As String = "パッケージ:[{0}]の呼び出し、もしくは実行に失敗しました。"


' データベース接続関連
Public Const EER_DB_CONNECT_STR_NOT_INPUT As String = "接続文字列を入力してください｡"
Public Const EER_DB_USERID_NOT_INPUT As String = "ユーザー名を入力してください。"
Public Const ERR_DB_PASSWORD_NOT_INPUT As String = "パスワードを入力してください。"
Public Const ERR_DB_CONNECT As String = "データベースへ接続できませんでした。" + vbCr + "接続設定内容、データベース等を確認してください。"
Public Const ERR_DB_UNEXPECTED As String = "エラーが発生しました。発生個所は、{0}Sheetの{1}番目の行です。"


' データチェック関連
Public Const CHK_INFO_MSG As String = "情報"
Public Const CHK_WARNING_MSG As String = "警告"
Public Const CHK_ERROR_MSG As String = "エラー"

Public Const CHECK_NO_ERROR As String = "エラーはありません。"

Public Const ERR_NOT_CREATE_TARGET As String = "入力されたGIDはシート作成対象ではありません。"
Public Const ERR_NOT_EXIST_GID As String = "入力された{0}のGIDは在籍していない従業員です。"
Public Const ERR_MISSING As String = "{0}が未入力です。"
Public Const ERR_SAME_GID As String = "同一のGIDが入力されています。"
Public Const ERR_MAX_LENGTH As String = "{0}は{1}文字以内で入力してください。"
Public Const ERR_INVALID_FORMAT As String = "{0}の入力形式に誤りがあります。"
Public Const ERR_RANGE_0_TO_100 As String = "{0}は0～100の半角数字を入力してください。"
Public Const ERR_INPUT_CRLF As String = "{0}に改行文字が含まれています。改行文字は使用できません。"

Public Const WARN_DEFAULT_STATUS_CD As String = "ステータスコードが指定されていません。デフォルトのステータスコードが指定されます。"
Public Const WARN_DEFAULT_FLOW_PTN As String = "フローパターンが指定されていません。「通常フロー(1-4次)」が指定されます。"

Public Const CHECK_COMPLETED_MSG As String = "エラーチェックが終了しました。エラー一覧シートを確認してください。"


' 登録関連
Public Const REGISTED_COMPLETED_MSG As String = "登録が完了しました。"
Public Const REGISTRATION_ERR_MSG As String = "異常エラーが存在します。エラー一覧シートを確認してください。"
Public Const REGISTRATION_WARN_MSG As String = "警告エラーが存在します。登録してよろしいですか。"


' ***********************
' 評価シート名
' ***********************
Public Const GYOSEKI_HYOKA_JP As String = "業績評価（一般職）"
Public Const GYOSEKI_HYOKA_EN As String = "PerformanceEvaluation"
Public Const COMP_HYOKA_JP As String = "コンピテンシー評価（一般職）"
Public Const COMP_HYOKA_EN As String = "CompetencyEvaluation"
Public Const CAREER_DEV_ME_JP As String = "管理職評価・キャリア開発（M,E等級）"
Public Const CAREER_DEV_ME_EN As String = "Appraisal & Development(M,E)"
Public Const CAREER_DEV_S_JP As String = "管理職評価・キャリア開発（S等級）"
Public Const CAREER_DEV_S_EN As String = "Appraisal & Development(S)"


' ***********************
' チェックルールの定義
' ***********************
Public Const CHK_COLUMN_PARTY As String = "PARTY"
Public Const CHK_COLUMN_GID As String = "GID"
Public Const CHK_COLUMN_ACTOR_1ST As String = "ACTOR_1ST"
Public Const CHK_COLUMN_ACTOR_2ND As String = "ACTOR_2ND"
Public Const CHK_COLUMN_ACTOR_3RD As String = "ACTOR_3RD"
Public Const CHK_COLUMN_ACTOR_4TH As String = "ACTOR_4TH"

Public Const CHK_INPUT_TYPE_STRING_JP As String = "文字列"
Public Const CHK_INPUT_TYPE_STRING_EN As String = "Character String"
Public Const CHK_PATTERN_NO_CRLF_JP As String = "改行不可"
Public Const CHK_PATTERN_NO_CRLF_EN As String = "Not line break"
Public Const CHK_PATTERN_YYYY As String = "YYYY"
Public Const CHK_PATTERN_YYYYMM As String = "YYYY/MM"
Public Const CHK_PATTERN_YYYYMMDD As String = "YYYY/MM/DD"


' ***********************
' その他の定義
' ***********************
Public Const MAIN_SHEET_NAME As String = "メイン"
Public Const ERR_LIST_SHEET_NAME As String = "エラー一覧"

' 人事ユーザID
Public Const JINJI_USER_ID As String = "ZZZZZZ"


' メインシート上の処理の起点（"B15"）
Public Const M_START_CELL As String = "B15"
Public Const M_START_ROW As Long = 15                       ' セル：B15の行位置
Public Const M_START_COL As Long = 2                        ' セル：B15の列位置

' メインシートの処理を指示する表の各項目のB列を起点とした相対位置
Public Const REL_POS_REG_CHECK As Long = 1                  ' 「登録」列位置
Public Const REL_POS_REG_NENDO As Long = 3                  ' 「年度」列位置
Public Const REL_POS_EVAL_SHEET As Long = 5                 ' 「評価シート名」列位置
Public Const REL_POS_REG_DATE As Long = 12                  ' 「登録日時」列位置
Public Const REL_POS_REG_COUNT As Long = 17                 ' 「登録件数」列位置

' 各評価シートのデータ開始行（"B12"）
Public Const START_DATA_CELL As String = "B12"
Public Const START_DATA_ROW As Long = 12
Public Const START_DATA_COL As Long = 2

' 各評価シートのデータ取得の起点（"B4"）
Public Const H_SHT_START_CELL As String = "B4"
Public Const H_SHT_START_ROW As Long = 4
Public Const H_SHT_START_COL As Long = 2

' 各評価シートのシート回答情報取得の起点（"K4"）
Public Const H_FILL_START_CELL As String = "K4"
Public Const H_FILL_START_ROW As Long = 4
Public Const H_FILL_START_COL As Long = 11

' 評価シートの行位置の定義
Public Const LGC_COL_NAME_ROW_NUM As Long = 4           ' （論理）項目名
Public Const PHY_COL_NAME_ROW_NUM As Long = 5           ' （物理）カラム名
Public Const REQUIRED_ROW_NUM As Long = 6               ' 必須
Public Const DATA_ATTR_ROW_NUM As Long = 7              ' 属性
Public Const DATA_LENGTH_ROW_NUM As Long = 8            ' 桁数
Public Const INPUT_TYPE_ROW_NUM As Long = 9             ' 入力形式
Public Const FIXED_VAL_ROW_NUM As Long = 10             ' 固定値





' エラー一覧シートの各項目のセル・列位置
Public Const ERR_LIST_WRITE_START_CELL As String = "B3"
Public Const ERR_LIST_SHEET_NAME_COL As Long = 2                ' 「シート」列
Public Const ERR_LIST_ERROR_ROW_COL As Long = 3                 ' 「エラーExcel行」列
Public Const ERR_LIST_ERR_TYPE_COL As Long = 4                  ' 「エラー種別」列
Public Const ERR_LIST_ERR_CONTENT_COL As Long = 5               ' 「エラー内容」列

' DB接続情報が記載されているメインシート上のセル位置
Public Const DB_CONNECT_STR_CELL As String = "B5"               ' 接続文字列
Public Const DB_USER_NAME_CELL As String = "G5"                 ' ユーザ名
Public Const DB_PASSWORD_CELL As String = "J5"                  ' パスワード
Public Const DB_KEEP_PASSWORD_CELL As String = "M5"             ' パスワード保存可否
Public Const DB_ODBC_DRIVER_NAME_CELL As String = "E8"          ' ODBCドライバ


' ***********************
' その他の定義（列挙型）
' ***********************

' エラー種別
Enum ERROR_TYPE
    CHK_INFO = 1
    CHK_WARNING = 2
    CHK_ERROR = 3
End Enum

' 入力文字の属性（未使用）
Enum CHECK_TEXT_ATTR
    ATTR_STRING = 1
    ATTR_NUMERIC = 2
End Enum

Enum CHK_SHEET_STATUS
    NOT_TARGET = 0              ' 登録しない（"○"がついていない）
    CHECK_OK = 1                ' 登録可（エラーなし）
    CHECK_WARNING = 2           ' 登録可（警告あり）
    CHECK_ERROR = 3             ' 登録不可（エラーあり）
    NOT_CHECKED = 9             ' 未チェック
End Enum

' 「メイン」シートのチェック結果
Enum MAIN_SHEET_CHK_RSLT
    NO_CHECK_ERROR = 0          ' エラーなし
    NOT_SELECTED_ERROR = -1     ' 処理対象が未選択
    NENDO_NO_INPUT_ERROR = -2   ' 「年度」未入力エラー
End Enum

