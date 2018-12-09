Attribute VB_Name = "ConstDefModule"
Option Explicit

' 定数定義用モジュール
' 定数やメッセージの定義はすべてここに記載するように


' ****************
' 定数関連の定義
' ****************

' シート名定義
Public Const WARNING_SHEET_NAME As String = "警告"
Public Const MAIN_SHEET_NAME As String = "人材育成計画"
Public Const RESULT_SHEET_NAME As String = "チェック結果"


' ラベル定義
Public Const TITLE_UPLOAD_ENABLE_MSG = "アップロード可"
Public Const TITLE_UPLOAD_DISABLE_MSG = "アップロード不可"
Public Const SUB_TITLE_UPLOAD_DISABLE_MSG = "（チェック結果シートを参照してください）"
Public Const SUB_TITLE_NO_CHECK_MSG = "（エラーチェック未実施）"


' メッセージ関連
Public Const ERR_RAISED_MSG As String = "エラーが発生しました。"

Public Const MSG_CHECK_NO_ERROR As String = "エラーチェックが終了しました。" + vbCrLf + "エラーはありません。"
Public Const MSG_CHECK_ERROR As String = "エラーチェックが終了しました。" + vbCrLf + "チェック結果シートを確認してください。"


' ****************************
' その他（列挙型など）の定義
' ****************************
Enum UPLOAD_TYPE
    UPLOAD_ENABLE = 0
    UPLOAD_DISABLE = 1
End Enum

Enum CHECK_RESULT
    CHK_NO_ERROR = 0
    CHK_WARNING = 1
    CHK_ERROR = 2
End Enum

Enum CHECK_RESULT_TYPE
    TYPE_ERROR = 1
    TYPE_WARNING = 2
End Enum

Enum ERROR_CHECK_TYPE
    MISSING_CHECK = 1                       ' 未入力チェック
    CRLF_CHECK = 2                          ' 改行文字存在チェック
    LENGTH_CHECK = 3                        ' 文字列長チェック
    CONSISTENT_CHECK = 4                    ' 整合性チェック
    COND_MISSING_CHECK = 5                  ' 条件付き未入力チェック
End Enum

