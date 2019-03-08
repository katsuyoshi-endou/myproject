Attribute VB_Name = "JinikCheckModule"
Option Explicit

' *********************************
' �u�G���[�`�F�b�N���{�v�{�^������
' *********************************
Public Sub ErrorCheckButtonClick()
    Dim chkResult As Long: chkResult = 0
    Dim rsltMsg As String

    Dim control As SheetControl

    On Error GoTo ErrorCheckButtonClick_Err

    Dim jinikView As New JinikSheetView
    Dim resultView As New CheckResultView
    Dim masterView As New MasterSheetView

    Set control = New SheetControl

    With control
        .JinikSheetView = jinikView
        .CheckResultView = resultView
        .MasterSheetView = masterView
    End With

    ' �J�[�\���������v��
    Application.Cursor = xlWait

    ' �`�F�b�N�������̓C�x���g�̔����𖳌�������уV�[�g�̃��b�N���O��
    Application.EnableEvents = False
    Call jinikView.setSheetProtect(False)

    ' �G���[�`�F�b�N���������s
    chkResult = control.executeSheetCheck

    If chkResult = CHECK_RESULT.CHK_NO_ERROR Or chkResult = CHECK_RESULT.CHK_WARNING Then
        Call jinikView.setStatusString(TITLE_UPLOAD_ENABLE_MSG, "", CHECK_RESULT.CHK_NO_ERROR)
    Else
        Call jinikView.setStatusString(TITLE_UPLOAD_DISABLE_MSG, SUB_TITLE_UPLOAD_DISABLE_MSG, CHECK_RESULT.CHK_ERROR)
    End If

    Call jinikView.setSheetProtect(True)
    Application.EnableEvents = True

    Application.Cursor = xlDefault

    ' ���s���ʂɂ�菈���������b�Z�[�W��؂�ւ���
    If chkResult = CHECK_RESULT.CHK_NO_ERROR Or chkResult = CHECK_RESULT.CHK_WARNING Then
        MsgBox MSG_CHECK_NO_ERROR, vbInformation + vbOKOnly
    Else
        MsgBox MSG_CHECK_ERROR, vbExclamation + vbOKOnly
    End If

    ' ���\�[�X�̉��
    Set jinikView = Nothing
    Set resultView = Nothing
    Set masterView = Nothing

    Set control = Nothing

    ' �ҏW�ςݍς݃t���O�����Z�b�g
    Call setJinikSheetEdited(False)
    ' �G���[�`�F�b�N�ς݃t���O���Z�b�g
    Call setErrorChecked(True)

    Exit Sub

ErrorCheckButtonClick_Err:
    Application.Cursor = xlDefault

    If control Is Nothing Then
        Set control = Nothing
    End If

    If jinikView Is Nothing Then
        Set jinikView = Nothing
    End If

    If resultView Is Nothing Then
        Set resultView = Nothing
    End If

    MsgBox ERR_RAISED_MSG + vbCrLf + err.Description, vbCritical + vbOKOnly

End Sub

