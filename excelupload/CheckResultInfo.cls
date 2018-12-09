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

Private m_checkResults As Dictionary

Private Sub Class_Initialize()
    Set m_checkResults = New Dictionary
End Sub

Private Sub Class_Terminate()
    m_checkResults.RemoveAll

    Set m_checkResults = Nothing
End Sub

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
                errMsg = "異動先の組織名称が未入力です。" & vbCrLf & "異動実績は両方の欄に入力してください｡ "
            ElseIf fillId = "jinik_kaito_buyer_ninteikyu" Then
                errMsg = "バイヤー認定計画の認定級が未入力です。" & vbCrLf & "認定計画は両方の欄に入力してください｡ "
            ElseIf fillId = "jinik_kaito_touyo_keikaku" Then
                errMsg = "登用計画の等級群が未入力です。" & vbCrLf & "登用計画は両方の欄に入力してください｡ "
            ElseIf fillId = "jinik_kaito_genzai_tanto_gyomu" Then
                errMsg = "現在の担当業務が未入力です。"
            ElseIf fillId Like "jinik_kaito_ido_month_0?" Or fillId Like "jinik_kaito_shokumu_0?" Or fillId Like "jinik_kaito_jigyojo_0?" Or _
                    fillId Like "jinik_kaito_kyoten_0?" Or fillId Like "jinik_kaito_idosaki_0?" Or fillId Like "jinik_kaito_konin_youhi_0?" Then
                errMsg = "異動チェックをつけた年度には異動計画の必須項目（異動月、職務、事業場、拠点、異動先の組織名称、後任要否）を入力してください。"
            End If
        ' 改行文字存在チェック時
        Case ERROR_CHECK_TYPE.CRLF_CHECK
            errType = CHECK_RESULT_TYPE.TYPE_WARNING
            errMsg = "改行は半角スペースに変換しました。"
        ' 文字列長チェック時
        Case ERROR_CHECK_TYPE.LENGTH_CHECK
            If fillId = "jinik_kaito_other" Then
                errMsg = "1000文字以内で入力してください。"
            Else
                errMsg = "100文字以内で入力してください。"
            End If
        ' 整合性チェック時
        Case ERROR_CHECK_TYPE.CONSISTENT_CHECK
            If fillId = "jinik_kaito_buyer_jiki" Then
                errMsg = "バイヤー認定年度は、退職年度以前を指定してください。"
            ElseIf fillId = "jinik_kaito_buyer_ninteikyu" Then
                errMsg = "既にバイヤー2級のため、より上位の認定級を選択してください｡ "
            ElseIf fillId = "jinik_kaito_touyo_jiki" Then
                errMsg = "登用年度は、退職年度以前を指定してください。"
            ElseIf fillId = "jinik_kaito_touyo_keikaku" Then
                errMsg = "既に基幹職のため、より上位の等級群を選択してください｡ "
            End If
        ' 条件付き未入力チェック時
        Case ERROR_CHECK_TYPE.COND_MISSING_CHECK
            If fillId Like "jinik_kaito_idosaki_kyoten_0?" Then
                errMsg = "拠点が変更される場合は異動先拠点を入力してください。"
            ElseIf fillId = "jinik_kaito_konin_youken_0" Then
                errMsg = "後任が必要な場合は後任要件を入力してください。"
            End If
    End Select

    result.getErrCellAddr = addr
    result.setGuid = guid
    result.getPersonName = name
    result.getColumnName = colName
    result.getErrType = errType
    result.setErrContent = errMsg

    count = m_checkResults.count

    Call m_checkResults.Add(count + 1, result)

    Exit Sub

addCheckResult_Err:
    err.Raise err.Number, "addCheckResult", err.Description

End Sub

Public Function getCheckResults() As Dictionary
    Set getCheckResults = m_checkResults
End Function

