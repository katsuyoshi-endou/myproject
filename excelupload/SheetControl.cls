VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SheetControl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' �R���g�[���[���N���X�̂悤�Ȃ���
' �u�l�ވ琬�v��v�V�[�g�̃r���[��`���i�[���Ă����A�����̐�����s��

Private m_WarnSheetView As WarnSheetView
Private m_JinikSheetView As JinikSheetView
Private m_CheckResultView As CheckResultView


' �R���X�g���N�^
Private Sub Class_Initialize()
    Set m_WarnSheetView = New WarnSheetView
    Set m_JinikSheetView = New JinikSheetView
    Set m_CheckResultView = New CheckResultView
End Sub

' �f�X�g���N�^
Private Sub Class_Terminate()
    Set m_WarnSheetView = Nothing
    Set m_JinikSheetView = Nothing
    Set m_CheckResultView = Nothing
End Sub

Public Property Let WarnSheetView(view As WarnSheetView)
    Set m_WarnSheetView = view
End Property

Public Property Let JinikSheetView(view As JinikSheetView)
    Set m_JinikSheetView = view
End Property

Public Property Let CheckResultView(view As CheckResultView)
    Set m_CheckResultView = view
End Property

' *************************************
'  �l�ވ琬�v��V�[�g�̃`�F�b�N���s��
' *************************************
Public Function executeSheetCheck() As Long
    Dim properties As Dictionary
    Dim jinikData As Dictionary
    
    On Error GoTo executeSheetCheck_Err

    Set properties = getSheetFieldProperties()
    
    Set jinikData = m_JinikSheetView.getSheetContentsFromMapping(properties)

    Call checkSheetContents(jinikData, properties)

    properties.RemoveAll
    
    Set properties = Nothing

    jinikData.RemoveAll

    Set jinikData = Nothing

    Exit Function

executeSheetCheck_Err:
    err.Raise err.Number, "executeSheetCheck", err.Description

End Function

Private Function checkSheetContents(jinikSheetData As Dictionary, properties As Dictionary) As CheckResultInfo
    Dim key As Variant
    Dim fillId As String
    Dim condStr As String
    Dim id As Variant
    Dim data As Variant
    Dim dto As JinikSheetInfoDto
    Dim propDto As FieldProperty
    Dim chkResults As CheckResultInfo

    On Error GoTo checkSheetContents_Err

    Set chkResults = New CheckResultInfo

    ' Dictionary�^�̎��o���́A�i�[��������
    For Each key In jinikSheetData
        Set dto = data.item(key)

        For Each id In dto.getFillData
            data = dto.getFillData.item(id)

            Set propDto = properties.item(id)

            If propDto.isCheck = True Then
                If propDto.REQUIRED_CHECK = True Then
                    If data(2) = "" Then
                        Call chkResults.addCheckResult(data(0), dto.getGuid, dto.getPersonName, CStr(id), data(1), ERROR_CHECK_TYPE.MISSING_CHECK)
                    End If
                ElseIf propDto.CRLF_CHECK = True Then
                    If isExistCrLf(CStr(data(2))) = True Then
                        Call chkResults.addCheckResult(data(0), dto.getGuid, dto.getPersonName, CStr(id), data(1), ERROR_CHECK_TYPE.CRLF_CHECK)
                    End If
                ElseIf propDto.MAX_LENGTH > 0 Then
                    If Len(data(2)) > propDto.MAX_LENGTH Then
                        Call chkResults.addCheckResult(data(0), dto.getGuid, dto.getPersonName, CStr(id), data(1), ERROR_CHECK_TYPE.LENGTH_CHECK)
                    End If
                ElseIf propDto.COND_REQ_CHECK <> "" Then
                    condStr = propDto.COND_REQ_CHECK
                    If condStr <> "" And data(2) = "" Then
                        Call chkResults.addCheckResult(data(0), dto.getGuid, dto.getPersonName, CStr(id), data(1), ERROR_CHECK_TYPE.COND_MISSING_CHECK)
                    End If
                ElseIf propDto.CUSTOM_CHECK = True Then
                    Select Case CStr(id)
                        Case "jinik_kaito_buyer_jiki"
                            
                    End Select
                End If
            Else
                Exit For
            End If

            Set propDto = Nothing
        Next

        Set dto = Nothing
    Next

    Set checkSheetContents = chkResults

    Exit Function

checkSheetContents_Err:
    err.Raise err.Number, "checkSheetContents", err.Description

End Function

' �ސE�\��N�x�Ƃ̔�r
Private Function compareWithTaishokuYoteiNendo(nendo As String) As Boolean
    
End Function

' �ސE�\��N�x���擾����
Private Function getTaishokuYoteiNendo() As String

End Function

Private Function isExistCrLf(str As String) As Boolean
    Dim ret As Boolean: ret = False

    '// CR���܂܂�邩�`�F�b�N
    If InStr(str, vbCr) > 0 Then
        ret = True
    End If
    
    '// LF���܂܂�邩�`�F�b�N
    If InStr(str, vbLf) > 0 Then
        ret = True
    End If
    
    '// CRLF���܂܂�邩�`�F�b�N
    If InStr(str, vbCrLf) > 0 Then
        ret = True
    End If
    
    '// CR��LF���܂܂�邩�`�F�b�N
    If InStr(str, vbCr) > 0 And InStr(str, vbLf) > 0 Then
        ret = True
    End If

    isExistCrLf = ret
End Sub
End Sub