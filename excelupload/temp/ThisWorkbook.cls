VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Private bBiaClose As Boolean                ' ����o�R�ŕۑ����Ă΂ꂽ���H�iTrue : �Ă΂ꂽ�AFalse : �Ă΂�Ă��Ȃ��j

' �@�\�F���[�N�u�b�N�I�[�v�����̏���
'       �E�e�V�[�g�̕\���^��\�����s��
'       �E�l�ވ琬�v��V�[�g�̕\�����A�V�[�g�̏������������s��
' �����F�Ȃ�
' �߂�l�F�Ȃ�
Private Sub Workbook_Open()
    ThisWorkbook.Unprotect Password:=BOOK_PROTECT_PASSWORD

    On Error Resume Next

    Application.ScreenUpdating = False

    ' ���C���V�[�g����\���̂Ƃ��A���C���V�[�g�ƃ`�F�b�N���ʃV�[�g��\��
    If ThisWorkbook.Sheets(MAIN_SHEET_NAME).Visible <> True Then
        ThisWorkbook.Sheets(MAIN_SHEET_NAME).Visible = True
        ThisWorkbook.Sheets(RESULT_SHEET_NAME).Visible = True
    End If

    ' �x���V�[�g���\������Ă���Ƃ��A�x���V�[�g���\��
    If ThisWorkbook.Sheets(WARNING_SHEET_NAME).Visible <> False Then
        ThisWorkbook.Sheets(WARNING_SHEET_NAME).Visible = False
    End If

    Application.ScreenUpdating = True

    On Error GoTo 0

    If ThisWorkbook.Sheets(MAIN_SHEET_NAME).Visible = True Then
        Call initialJinikSheetActivation
    End If

    ' �e�t���O��������
    Call setJinikSheetEdited(False)
    Call setErrorChecked(False)
    Call setChkRsltSheetEdited(False)

    ThisWorkbook.protect Password:=BOOK_PROTECT_PASSWORD

    Exit Sub
End Sub

' �@�\�F���[�N�u�b�N�̕ۑ��O����
' �����F
'   SaveAsUI :
'   Cancel   : �L�����Z���t���O�iTRUE : �ۑ����������Ȃ��j
' �߂�l�F�Ȃ�
Private Sub Workbook_BeforeSave(ByVal SaveAsUI As Boolean, Cancel As Boolean)
    Dim ret As Long

    Cancel = True

    '����o�R�ŌĂ΂�Ă��Ȃ��ꍇ�́A�����ŃO���[���ڂ�j�����邩�ǂ�������
    If bBiaClose = False Then
        ' �O���[�A�E�g���Ă��鍀�ڂɂ��ẮA�f�[�^��ێ����܂���B��낵���ł����H
        ret = MsgBox(CONFIRM_DATA_ERASE_MSG, vbQuestion + vbYesNo)
        If ret = vbNo Then
            Cancel = True
            bBiaClose = False
            Exit Sub
        End If

        ' �Ȃɂ�����ҏW����Ă���΁A�u�A�b�v���[�h�s�i�G���[�`�F�b�N�����{�j�v�ɂ���
        If isJinikSheetEdited() = True Then
            Call setUploadStatusString(TITLE_UPLOAD_DISABLE_MSG, SUB_TITLE_NO_CHECK_MSG, CHECK_RESULT.CHK_ERROR)
        End If
    Else
        ' ����o�R�̂Ƃ��́AWorkbook_BeforeClose�ŏ�������̂ŁA�����ł͉������Ȃ�
    End If

    ' �O���[�A�E�g���Ă��鍀�ڂ̒l��j������
    Call clearDataDisabledFields

    Call controlSheetsBeforeSave

    ' ��Ԃ����Ƃɖ߂�
    Call setJinikSheetEdited(False)
    Call setErrorChecked(False)
    Call setChkRsltSheetEdited(False)

    bBiaClose = False

    ThisWorkbook.Saved = True
End Sub


' �@�\�F���[�N�u�b�N�����O�̏���
' �����F
'   Cancel : ����L�����Z���t���O�iTRUE : ���[�N�u�b�N����Ȃ��j
' �߂�l�F�Ȃ�
Private Sub Workbook_BeforeClose(Cancel As Boolean)
    Dim ret As Long

    If isJinikSheetEdited() = False And isErrorChecked() = False And isChkRsltSheetEdited() = False Then
        ' ���[�N�u�b�N�̏����������ōs���邱�ƈȊO�ɃV�[�g���X�V����Ă��Ȃ��Ƃ��A�����̍X�V���Ȃ��������Ƃɂ���
        Me.Saved = True
        Exit Sub
    ElseIf isErrorChecked() = True And isJinikSheetEdited() = False Then
        ' �G���[�`�F�b�N�������Ă���Ƃ��A�`�F�b�N���ʂ��Ƃ��Ă����悤�ɕۑ������߂�
        ' �`�F�b�N���ʂ�ۑ����܂��B��낵���ł����H
        ret = MsgBox(CONFIRM_CHK_RSLT_SAVE_MSG, vbQuestion + vbYesNo)
        If ret = vbYes Then
            bBiaClose = True
            Call controlSheetsBeforeClose
            Exit Sub
        Else
            ' �u�������v�̂Ƃ��́A�ۑ�������Excel�I��
            Me.Saved = True
            Exit Sub
        End If
    ElseIf isErrorChecked() = False And isJinikSheetEdited() = True Then
        ' �G���[�`�F�b�N�͂����A�ҏW�݂̂��Ă���Ƃ�
        ' �ۑ����܂��B��낵���ł����H" & vbCrLf & "�G���[�`�F�b�N���s���Ă��Ȃ����߁A�A�b�v���[�h�ł��܂���B" & vbCrLf & "�A�b�v���[�h����ɂ́u�G���[�`�F�b�N���ĕۑ��v�ŃG���[�`�F�b�N���s���K�v������܂��B
        ret = MsgBox(CONFIRM_SAVE_MSG, vbQuestion + vbYesNoCancel)
        If ret = vbYes Then
            ' �O���[�A�E�g���Ă��鍀�ڂɂ��ẮA�f�[�^��ێ����܂���B��낵���ł����H
            ret = MsgBox(CONFIRM_DATA_ERASE_MSG, vbQuestion + vbYesNo)
            If ret = vbNo Then
                Me.Saved = True
                Cancel = True
                Exit Sub
            End If

            If isJinikSheetEdited() = True Then
                Call setUploadStatusString(TITLE_UPLOAD_DISABLE_MSG, SUB_TITLE_NO_CHECK_MSG, CHECK_RESULT.CHK_ERROR)
            End If

            bBiaClose = True
            Call controlSheetsBeforeClose
            Exit Sub
        ElseIf ret = vbNo Then
            ' �u�������v�̂Ƃ��́A�X�V��j������Excel�I��
            Me.Saved = True
            Exit Sub
        ElseIf ret = vbCancel Then
            ' �u�L�����Z���v�̂Ƃ��́AExcel�͏I�������ɖ߂�
            Me.Saved = True
            Cancel = True
            Exit Sub
        End If
    ElseIf isErrorChecked() = True And isJinikSheetEdited() = True Then
        ' �V�[�g���ҏW����Ă��āA�G���[�`�F�b�N�����Ă���Ƃ�
        ' �t�@�C�����ύX����Ă��܂��B& vbCrLf & �ۑ����܂��B��낵���ł����H
        ret = MsgBox(CONFIRM_EXCEL_BOOK_SAVE_MSG, vbQuestion + vbYesNo)
        If ret = vbYes Then
            bBiaClose = True
            Call controlSheetsBeforeClose
            Exit Sub
        Else
            ' �u�������v�̂Ƃ��́A�ۑ�������Excel�I��
            Me.Saved = True
            Exit Sub
        End If
    End If
End Sub

' �@�\�F���[�N�u�b�N�����ۂ̊e�V�[�g�̕\������
' �����F�Ȃ�
' �߂�l�F�Ȃ�
Private Sub controlSheetsBeforeClose()

    ' �C�x���g�̔����Ɖ�ʍX�V���~
    Application.EnableEvents = False
    Application.ScreenUpdating = False

    ' ���[�N�u�b�N�ی������
    ThisWorkbook.Unprotect Password:=BOOK_PROTECT_PASSWORD

    ' �e�V�[�g�̕\���𐧌�
    With ThisWorkbook
        .Sheets(WARNING_SHEET_NAME).Visible = True      ' �u�x���v�V�[�g���A�N�e�B�u�\��
        .Sheets(WARNING_SHEET_NAME).Activate
        .Sheets(MAIN_SHEET_NAME).Visible = False        ' �u�l�ވ琬�v��v�V�[�g���\��
        .Sheets(RESULT_SHEET_NAME).Visible = False      ' �u�`�F�b�N���ʁv�V�[�g���\��
        .Sheets(MASTER_SHEET_NAME).Visible = False      ' �umaster�v�V�[�g���\��

        ' ���[�N�u�b�N��ی�
        .protect Password:=BOOK_PROTECT_PASSWORD

        ' �V�[�g�̕\���𐧌䂵�����Ƃŕۑ�����
        .Save
    End With

    ' �C�x���g�̔����Ɖ�ʍX�V�̐�����ĊJ
    Application.EnableEvents = True
    Application.ScreenUpdating = True
End Sub

' �@�\�F���[�N�u�b�N�ۑ����̊e�V�[�g�̕\������
' �����F�Ȃ�
' �߂�l�F�Ȃ�
Private Sub controlSheetsBeforeSave()
    Dim actSheet As Worksheet
    Dim actCell As Range
    Dim scrlRow As Long
    Dim scrlCol As Long
    Dim WarnSheetVisible As Boolean
    Dim MainSheetVisible As Boolean
    Dim ChkRsltSheetVisible As Boolean
    Dim MasterSheetVisible As Boolean

    ' �C�x���g�̔����Ɖ�ʍX�V���~
    Application.EnableEvents = False
    Application.ScreenUpdating = False

    ' �A�N�e�B�u�ȃV�[�g�̏�ԁi�Z���ʒu��X�N���[���̍s��j
    Set actSheet = ActiveSheet
    Set actCell = ActiveCell
    scrlRow = ActiveWindow.ScrollRow
    scrlCol = ActiveWindow.ScrollColumn

    With ThisWorkbook
        ' ���[�N�u�b�N�̕ی������
        .Unprotect Password:=BOOK_PROTECT_PASSWORD

        ' �e�V�[�g�̕\���𐧌�
        .Sheets(WARNING_SHEET_NAME).Visible = True      ' �u�x���v�V�[�g���A�N�e�B�u�\��
        .Sheets(WARNING_SHEET_NAME).Activate
        .Sheets(MAIN_SHEET_NAME).Visible = False        ' �u�l�ވ琬�v��v�V�[�g���\��
        .Sheets(RESULT_SHEET_NAME).Visible = False      ' �u�`�F�b�N���ʁv�V�[�g���\��
        .Sheets(MASTER_SHEET_NAME).Visible = False      ' �umaster�v�V�[�g���\��

        ' �V�[�g�ɕی����������Ԃŕۑ�
        .protect Password:=BOOK_PROTECT_PASSWORD

        .Save

        ' �ēx�A���[�N�u�b�N�̕ی������
        .Unprotect Password:=BOOK_PROTECT_PASSWORD

        ' �e�V�[�g�̕\���𐧌�
        .Sheets(MAIN_SHEET_NAME).Visible = True         ' �u�l�ވ琬�v��v�V�[�g��\��
        .Sheets(RESULT_SHEET_NAME).Visible = True       ' �u�`�F�b�N���ʁv�V�[�g��\��
        .Sheets(MASTER_SHEET_NAME).Visible = False      ' �umaster�v�V�[�g�͔�\���i�̂܂܁j
        .Sheets(WARNING_SHEET_NAME).Visible = False     ' �u�x���v�V�[�g�͔�\��

        ' ���[�N�u�b�N��ی�
        .protect Password:=BOOK_PROTECT_PASSWORD
    End With

    ' �V�[�g�̕\�������Ƃɖ߂�
    actSheet.Activate
    cells(1, 1).Select
    ActiveWindow.ScrollRow = scrlRow
    ActiveWindow.ScrollColumn = scrlCol

    ' �C�x���g�̔����Ɖ�ʍX�V�̐�����ĊJ
    Application.EnableEvents = True
    Application.ScreenUpdating = True
End Sub
