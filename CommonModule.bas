Attribute VB_Name = "CommonModule"
' 共通処理モジュール
Option Explicit

' 運用コードを取得する
'  @party PARTY
'  @nendo 年度
'  @sheetName 評価シート名
'
'  戻り値：運用コード
Public Function getSheetOperationCd(party As String, nendo As String, sheetName As String) As String
    Dim ret As String: ret = ""
    Dim tmp As String: tmp = ""
    Dim tmpNendo As String
    
    If StrComp(GYOSEKI_HYOKA_JP, sheetName, vbTextCompare) = 0 Then
        tmp = "gysk-ja"
    ElseIf StrComp(GYOSEKI_HYOKA_EN, sheetName, vbTextCompare) = 0 Then
        tmp = "gysk-en"
    ElseIf StrComp(COMP_HYOKA_JP, sheetName, vbTextCompare) = 0 Then
        tmp = "comp-ja"
    ElseIf StrComp(COMP_HYOKA_EN, sheetName, vbTextCompare) = 0 Then
        tmp = "comp-en"
    ElseIf StrComp(CAREER_DEV_ME_JP, sheetName, vbTextCompare) = 0 Or StrComp(CAREER_DEV_S_JP, sheetName, vbTextCompare) = 0 Then
        tmp = "pmds-ja"
    ElseIf StrComp(CAREER_DEV_ME_EN, sheetName, vbTextCompare) = 0 Or StrComp(CAREER_DEV_S_EN, sheetName, vbTextCompare) = 0 Then
        tmp = "pmds-en"
    End If

    tmpNendo = convNendo(nendo)

    If Len(party) > 0 And Len(tmpNendo) > 0 And Len(tmp) > 0 Then
        ' PARTY - 年度 + "T" - シート名 - 言語
        ret = UCase(party) & "-" & tmpNendo & "T-" & tmp
    End If

    getSheetOperationCd = ret
End Function

' 書式コードを取得する
'  @sheetName 評価シート名
'  @format フォーマット（コンピテンシー評価以外は、""）
'
'  戻り値：書式コード
Public Function getSheetFormCd(sheetName As String, Optional format As String = "") As String
    Dim ret As String: ret = ""

    If StrComp(GYOSEKI_HYOKA_JP, sheetName, vbTextCompare) = 0 Then
        ret = "frm-gysk-ja"
    ElseIf StrComp(GYOSEKI_HYOKA_EN, sheetName, vbTextCompare) = 0 Then
        ret = "frm-gysk-en"
    ElseIf StrComp(COMP_HYOKA_JP, sheetName, vbTextCompare) = 0 Then
        ret = "frm-comp-" & UCase(format) & "-ja"
    ElseIf StrComp(COMP_HYOKA_EN, sheetName, vbTextCompare) = 0 Then
        ret = "frm-comp-" & UCase(format) & "-en"
    ElseIf StrComp(CAREER_DEV_ME_JP, sheetName, vbTextCompare) = 0 Then
        ret = "frm-pmds-ME-ja"
    ElseIf StrComp(CAREER_DEV_ME_EN, sheetName, vbTextCompare) = 0 Then
        ret = "frm-pmds-ME-en"
    ElseIf StrComp(CAREER_DEV_S_JP, sheetName, vbTextCompare) = 0 Then
        ret = "frm-pmds-S-ja"
    ElseIf StrComp(CAREER_DEV_S_EN, sheetName, vbTextCompare) = 0 Then
        ret = "frm-pmds-S-en"
    End If

    getSheetFormCd = ret
End Function

' 引数で渡された年度を"YYYY"形式に変換する
' 基本的には、"FY99"形式の年度を"YYYY"形式の年度に変換する（"YYYY"形式はそのまま返す）
'  @nendo 年度
'
'  戻り値：YYYY形式の年度
Public Function convNendo(nendo As String) As String
    Dim reg As RegExp
    Dim y As String
    Dim ret As String: ret = ""

    On Error GoTo convNendo_Err

    Set reg = New RegExp

    y = Left(year(Date), 2)
    
    With reg
        .Global = True
        .IgnoreCase = False
        .pattern = "^FY[0-9]{2}$"       ' 入力形式が"FY99"
        
        If .Test(nendo) = True Then
            ret = Replace(UCase(nendo), "FY", y)
        Else
            ' "FY99"形式でないとき、1900から2099年までの入力も許可
            .pattern = "^(19|20)[0-9]{2}$"
            If .Test(nendo) = True Then
                ret = nendo
            End If
        End If
    End With

    Set reg = Nothing

    convNendo = ret

    Exit Function

convNendo_Err:
    convNendo = ""

End Function

