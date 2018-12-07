Attribute VB_Name = "CommonModule"
' ���ʏ������W���[��
Option Explicit

' �^�p�R�[�h���擾����
'  @party PARTY
'  @nendo �N�x
'  @sheetName �]���V�[�g��
'
'  �߂�l�F�^�p�R�[�h
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
        ' PARTY - �N�x + "T" - �V�[�g�� - ����
        ret = UCase(party) & "-" & tmpNendo & "T-" & tmp
    End If

    getSheetOperationCd = ret
End Function

' �����R�[�h���擾����
'  @sheetName �]���V�[�g��
'  @format �t�H�[�}�b�g�i�R���s�e���V�[�]���ȊO�́A""�j
'
'  �߂�l�F�����R�[�h
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

' �����œn���ꂽ�N�x��"YYYY"�`���ɕϊ�����
' ��{�I�ɂ́A"FY99"�`���̔N�x��"YYYY"�`���̔N�x�ɕϊ�����i"YYYY"�`���͂��̂܂ܕԂ��j
'  @nendo �N�x
'
'  �߂�l�FYYYY�`���̔N�x
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
        .pattern = "^FY[0-9]{2}$"       ' ���͌`����"FY99"
        
        If .Test(nendo) = True Then
            ret = Replace(UCase(nendo), "FY", y)
        Else
            ' "FY99"�`���łȂ��Ƃ��A1900����2099�N�܂ł̓��͂�����
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

