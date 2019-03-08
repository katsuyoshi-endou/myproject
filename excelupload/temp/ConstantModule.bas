Attribute VB_Name = "ConstantModule"
Option Explicit

' 定数定義用モジュール
' 定数やメッセージの定義はすべてここに記載するように


' ****************
' 定数関連の定義
' ****************

Public Const BOOK_PROTECT_PASSWORD As String = "jinik_upload"
Public Const SHEET_PROTECT_PASSWORD As String = "jinik_upload"

' シート名定義
Public Const WARNING_SHEET_NAME As String = "警告"
Public Const MAIN_SHEET_NAME As String = "人材育成計画"
Public Const RESULT_SHEET_NAME As String = "チェック結果"
Public Const MASTER_SHEET_NAME As String = "master"


' ラベル定義
Public Const TITLE_UPLOAD_ENABLE_MSG = "アップロード可"
Public Const TITLE_UPLOAD_DISABLE_MSG = "アップロード不可"
Public Const SUB_TITLE_UPLOAD_DISABLE_MSG = "（チェック結果シートを参照してください）"
Public Const SUB_TITLE_NO_CHECK_MSG = "（エラーチェック未実施）"


' メッセージ関連
Public Const ERR_RAISED_MSG As String = "エラーが発生しました。"

Public Const MSG_CHECK_NO_ERROR As String = "エラーチェックが終了しました。" + vbCrLf + "エラーはありません。"
Public Const MSG_CHECK_ERROR As String = "エラーチェックが終了しました。" + vbCrLf + "チェック結果シートを確認してください。"

Public Const CONFIRM_DATA_ERASE_MSG As String = "グレーアウトしている項目については、データを保持しません。" & vbCrLf & "よろしいですか？"
Public Const CONFIRM_SAVE_MSG As String = "保存します。よろしいですか？" & vbCrLf & "エラーチェックが行われていないため、アップロードできません。" & vbCrLf & "アップロードするには「エラーチェック実施」でエラーチェックを行う必要があります。"
Public Const CONFIRM_CHK_RSLT_SAVE_MSG As String = "チェック結果を保存します。よろしいですか？"
Public Const CONFIRM_EXCEL_BOOK_SAVE_MSG As String = "ファイルが変更されています。" + vbCrLf + "保存します。よろしいですか？"


' エラーチェックメッセージ
Public Const MSG_MISSING_ERR_IDO_PLACE As String = "異動先の組織名称が未入力です。" & vbCrLf & "異動実績は両方の欄に入力してください。 "
Public Const MSG_MISSING_ERR_BUYER_NINTEIKYU As String = "バイヤー認定計画の認定級が未入力です。" & vbCrLf & "認定計画は両方の欄に入力してください。"
Public Const MSG_MISSING_ERR_TOUYO_KEIKAKU As String = "登用計画の等級群が未入力です。" & vbCrLf & "登用計画は両方の欄に入力してください。"
Public Const MSG_MISSING_ERR_GENZAI_TANTO_GYOMU As String = "現在の担当業務が未入力です。"
Public Const MSG_MISSING_ERR_KAITO As String = "異動チェックをつけた年度には異動計画の必須項目（異動月、職務、事業場、拠点、異動先の組織名称、後任要否）を入力してください。"
Public Const MSG_LENGTH_ERR_MSG As String = "{0}文字以内で入力してください。"
Public Const MSG_CONSIS_ERR_BUYER_JIKI As String = "バイヤー認定年度は、退職年度以前を指定してください。"
Public Const MSG_CONSIS_ERR_BUYER_NINTEIKYU As String = "既にバイヤー2級のため、より上位の認定級を選択してください。"
Public Const MSG_CONSIS_ERR_TOUYO_JIKI As String = "登用年度は、退職年度以前を指定してください。"
Public Const MSG_CONSIS_ERR_TOUYO_KEIKAKU As String = "既に基幹職のため、より上位の等級群を選択してください。"
Public Const MSG_COND_MISS_ERR_IDOSAKI_KYOTEN As String = "拠点が変更される場合は異動先拠点を入力してください。"
Public Const MSG_COND_MISS_ERR_KONIN_YOUKEN As String = "後任が必要な場合は後任要件を入力してください。"
Public Const MSG_RANGE_ERR_MSG As String = "リスト内の値を選択してください。"

Public Const MSG_CRLF_WARN_MSG = "改行は半角スペースに変換しました。"


Public Const ADDR_UPLOAD_STATUS_TITLE As String = "B4"             ' アップロード可/不可のセル位置
Public Const ADDR_UPLOAD_STATUS_SUB_TITLE As String = "B7"         ' アップロード可/不可のサブタイトルのセル位置
Public Const ADDR_FIRST_JINIK_DATA As String = "B17"               ' 人材育成計画データ先頭位置
Public Const ADDR_LAST_JINIK_DATA As String = "CY17"               ' 人材育成計画データ終了位置
Public Const ADDR_SHEET_NENDO As String = "AM13"                   ' シートの年度が入っている位置


' アップロード可否表示セルの背景色定義（COLOR INDEX）
Public Const CELL_BKCOLOR_ERROR As Variant = 3                      ' 「アップロード不可」のときの背景色（赤）
Public Const CELL_BKCOLOR_NO_ERROR As Variant = 5                   ' 「アップロード可」のときの背景色（青）


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
    RANGE_CHECK = 6                         ' 範囲チェック
End Enum

