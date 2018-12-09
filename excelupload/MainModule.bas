Attribute VB_Name = "MainModule"
Option Explicit

' *********************************
' �u�G���[�`�F�b�N���{�v�{�^������
' *********************************
Public Sub ErrorCheckButtonClick()
    Dim chkResult As Long: chkResult = 0
    Dim rsltMsg As String: rsltMsg = ""

    Dim control As SheetControl

    On Error GoTo ErrorCheckButtonClick_Err

    ' �J�[�\���������v��
'    Application.Cursor = xlWait

    Set control = New SheetControl
    
    ' �G���[�`�F�b�N���������s
    Call control.executeSheetCheck

'    Application.Cursor = xlDefault

    ' ���s���ʂɂ�菈���������b�Z�[�W��؂�ւ���
    If chkResult = CHECK_RESULT.CHK_NO_ERROR Then
        MsgBox MSG_CHECK_NO_ERROR, vbInformation + vbOKOnly
    Else
        MsgBox MSG_CHECK_ERROR, vbExclamation + vbOKOnly
    End If

    Set control = Nothing

    Exit Sub

ErrorCheckButtonClick_Err:
'    Application.Cursor = xlDefault

    Set control = Nothing

    MsgBox ERR_RAISED_MSG + vbCrLf + err.Description, vbCritical + vbOKOnly

End Sub

