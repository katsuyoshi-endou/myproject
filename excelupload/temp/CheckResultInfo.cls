VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CheckResultInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private m_checkResults As Dictionary                    ' エラーチェック結果
Private m_nWarningCount As Long                         ' チェック警告数
Private m_nErrorCount As Long                           ' チェックエラー数

Private Sub Class_Initialize()
    Set m_checkResults = New Dictionary

    m_nErrorCount = 0
    m_nWarningCount = 0
End Sub

Private Sub Class_Terminate()
    m_checkResults.RemoveAll

    Set m_checkResults = Nothing
End Sub

Public Function getCheckResults() As Dictionary
    Set getCheckResults = m_checkResults
End Function

Public Function getCheckWarningCount() As Long
    getCheckWarningCount = m_nWarningCount
End Function

Public Function getCheckErrorCount() As Long
    getCheckErrorCount = m_nErrorCount
End Function

' 機能：エラー・警告情報をエラーチェック結果オブジェクトに格納する
' 引数：
'   addr    : A1形式のセルのアドレス
'   guid    : GID
'   name    : 氏名
'   fillId  : 回答ID
'   colName : 回答項目名（日本語）
'   chkType : ERROR_CHECK_TYPE（エラーチェック種別）
' 戻り値：なし
Public Sub addCheckResult(addr As String, guid As String, name As String, fillId As String, colName As String, chkType As ERROR_CHECK_TYPE)
    Dim count As Long
    Dim errMsg As String
    Dim errType As CHECK_RESULT_TYPE: errType = CHECK_RESULT_TYPE.TYPE_ERROR
    Dim result As CheckResultInfoDto

    On Error GoTo addCheckResult_Err

    Set result = New CheckResultInfoDto

    Select Case chkType
        ' 未入力チェック時
        Case ERROR_CHECK_TYPE.MISSING_CHECK
            If fillId = "jinik_kaito_ido_place" Then
                ' 異動先の組織名称が未入力です。" & vbCrLf & "異動実績は両方の欄に入力してください。
                errMsg = MSG_MISSING_ERR_IDO_PLACE
            ElseIf fillId = "jinik_kaito_buyer_ninteikyu" Then
                ' バイヤー認定計画の認定級が未入力です。" & vbCrLf & "認定計画は両方の欄に入力してください。
                errMsg = MSG_MISSING_ERR_BUYER_NINTEIKYU
            ElseIf fillId = "jinik_kaito_touyo_keikaku" Then
                ' 登用計画の等級群が未入力です。" & vbCrLf & "登用計画は両方の欄に入力してください。
                errMsg = MSG_MISSING_ERR_TOUYO_KEIKAKU
            ElseIf fillId = "jinik_kaito_genzai_tanto_gyomu" Then
                ' 現在の担当業務が未入力です。
                errMsg = MSG_MISSING_ERR_GENZAI_TANTO_GYOMU
            ElseIf fillId Like "jinik_kaito_ido_month_0?" Or fillId Like "jinik_kaito_shokumu_0?" Or fillId Like "jinik_kaito_jigyojo_0?" Or _
                    fillId Like "jinik_kaito_kyoten_0?" Or fillId Like "jinik_kaito_idosaki_0?" Or fillId Like "jinik_kaito_konin_youhi_0?" Then
                ' 異動チェックをつけた年度には異動計画の必須項目（異動月、職務、事業場、拠点、異動先の組織名称、後任要否）を入力してください。
                errMsg = MSG_MISSING_ERR_KAITO
            End If
        ' 改行文字存在チェック時
        Case ERROR_CHECK_TYPE.CRLF_CHECK
            errType = CHECK_RESULT_TYPE.TYPE_WARNING
            ' 改行は半角スペースに変換しました。
            errMsg = MSG_CRLF_WARN_MSG
        ' 文字列長チェック時
        Case ERROR_CHECK_TYPE.LENGTH_CHECK
            If fillId = "jinik_kaito_other" Then
                ' 「備考」は1000文字以内
                errMsg = Replace(MSG_LENGTH_ERR_MSG, "{0}", "1000")
            Else
                ' 「備考」以外は100文字以内
                errMsg = Replace(MSG_LENGTH_ERR_MSG, "{0}", "100")
            End If
        ' 整合性チェック時
        Case ERROR_CHECK_TYPE.CONSISTENT_CHECK
            If fillId = "jinik_kaito_buyer_jiki" Then
                ' バイヤー認定年度は、退職年度以前を指定してください。
                errMsg = MSG_CONSIS_ERR_BUYER_JIKI
            ElseIf fillId = "jinik_kaito_buyer_ninteikyu" Then
                ' 既にバイヤー2級のため、より上位の認定級を選択してください。
                errMsg = MSG_CONSIS_ERR_BUYER_NINTEIKYU
            ElseIf fillId = "jinik_kaito_touyo_jiki" Then
                ' 登用年度は、退職年度以前を指定してください。
                errMsg = MSG_CONSIS_ERR_TOUYO_JIKI
            ElseIf fillId = "jinik_kaito_touyo_keikaku" Then
                ' 既に基幹職のため、より上位の等級群を選択してください。
                errMsg = MSG_CONSIS_ERR_TOUYO_KEIKAKU
            End If
        ' 条件付き未入力チェック時
        Case ERROR_CHECK_TYPE.COND_MISSING_CHECK
            If fillId Like "jinik_kaito_idosaki_kyoten_0?" Then
                ' 拠点が変更される場合は異動先拠点を入力してください。
                errMsg = MSG_COND_MISS_ERR_IDOSAKI_KYOTEN
            ElseIf fillId Like "jinik_kaito_konin_youken_0?" Then
                ' 後任が必要な場合は後任要件を入力してください。
                errMsg = MSG_COND_MISS_ERR_KONIN_YOUKEN
            End If
        ' 範囲チェック時
        Case ERROR_CHECK_TYPE.RANGE_CHECK
            errType = CHECK_RESULT_TYPE.TYPE_ERROR
            ' 入力規則内の値を選択してください。
            errMsg = MSG_RANGE_ERR_MSG
    End Select

    With result
        .ErrCellAddr = addr
        .OwnGuid = guid
        .PersonName = name
        .ColumnName = colName
        .ErrResultType = errType
        .ErrMsgContent = errMsg
    End With

    count = m_checkResults.count

    ' keyは、1からの連番
    Call m_checkResults.Add(count + 1, result)

    If errType = CHECK_RESULT_TYPE.TYPE_ERROR Then
        m_nErrorCount = m_nErrorCount + 1
    ElseIf errType = CHECK_RESULT_TYPE.TYPE_WARNING Then
        m_nWarningCount = m_nWarningCount + 1
    End If

    Exit Sub

addCheckResult_Err:
    If result Is Nothing Then
        Set result = Nothing
    End If

    err.Raise err.Number, "addCheckResult", err.Description

End Sub

' 機能：エラー・警告情報をエラーチェック結果オブジェクトに格納する
' 引数：
'   addr    : A1形式のセルのアドレス
'   guid    : GID
'   name    : 氏名
'   fillId  : 回答ID
'   colName : 回答項目名（日本語）
'   chkType : ERROR_CHECK_TYPE（エラーチェック種別）
'   errMsg  : エラーメッセージ
' 戻り値：なし
Public Sub addCheckResultWithErrMsg(addr As String, guid As String, name As String, colName As String, errType As CHECK_RESULT_TYPE, errMsg As String)
    Dim count As Long
    Dim result As CheckResultInfoDto

    On Error GoTo addCheckResultWithErrMsg_Err

    Set result = New CheckResultInfoDto

    With result
        .ErrCellAddr = addr
        .OwnGuid = guid
        .PersonName = name
        .ColumnName = colName
        .ErrResultType = errType
        .ErrMsgContent = errMsg
    End With

    count = m_checkResults.count

    Call m_checkResults.Add(count + 1, result)

    If errType = CHECK_RESULT_TYPE.TYPE_ERROR Then
        m_nErrorCount = m_nErrorCount + 1
    ElseIf errType = CHECK_RESULT_TYPE.TYPE_WARNING Then
        m_nWarningCount = m_nWarningCount + 1
    End If

    Set result = Nothing

    Exit Sub

addCheckResultWithErrMsg_Err:
    err.Raise err.Number, "addCheckResultWithErrMsg", err.Description

End Sub

