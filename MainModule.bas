Attribute VB_Name = "MainModule"
Option Explicit

' ���C�����W���[��
' �{�^���������̃}�N�����L�q����
'   �����ł́A�f�[�^�x�[�X�ڑ������֘A�A���C���E�G���[�ꗗ�E�e�]���V�[�g�̋��ʃr���[�N���X�̐���
'   ����я����𐧌䂷��R���g���[���N���X�i�̂悤�Ȃ��́j�𐶐����Ċ֘A�t����


' �u�G���[�`�F�b�N�v�{�^������
Public Sub clickErrorCheckButton()
    Dim ret As Long
    
    Dim mainView As New MainSheetView
    Dim errView As New ErrorListView
    Dim evalView As New EvalSheetView
    
    Dim sheetCtrl As SheetControl

    Dim connect As DBConnection

    Dim chkedSheets As Dictionary

    On Error GoTo clickErrorCheckButton_Err

    ' �u���C���v�V�[�g�̃`�F�b�N
    ret = mainView.checkSheet()
    If ret = MAIN_SHEET_CHK_RSLT.NOT_SELECTED_ERROR Then
        ' �����Ώۂ��ЂƂ��I������Ă��Ȃ�
        MsgBox ERR_SHEET_NOT_SELECTED, vbExclamation + vbOKOnly

        Exit Sub
    ElseIf ret = MAIN_SHEET_CHK_RSLT.NENDO_NO_INPUT_ERROR Then
        ' �����Ώۂ̕]���V�[�g�Ɂu�N�x�v�����L��
        MsgBox ERR_SHEET_NENDO_NOT_INPUT, vbExclamation + vbOKOnly

        Exit Sub
    End If

    '�ڑ����̐ݒ�
    If setConnectionString() = False Then
        Exit Sub ' �ڑ����̐ݒ肪���s�����ꍇ�͂����ŏ������I��
    End If

    '�L�����Z���̏ꍇ�́A�����𒆒f
    If frmConnectDB.flgCancel = True Then
        Exit Sub
    End If

    ' �J�[�\���������v
    Application.Cursor = xlWait

    ' DB�ւ̃R�l�N�V�������m��
    Set connect = New DBConnection

    connect.setConnectString mainView.getConnectString()

    connect.openConnection
    
    Set sheetCtrl = New SheetControl
    
    With sheetCtrl
        .MainSheetView = mainView
        .ErrorListView = errView
        .EvalSheetView = evalView
        .DBConnection = connect
    End With
    
    ' �G���[�`�F�b�N
    ret = sheetCtrl.checkErrorMain()
    If ret < 0 Then
        Application.Cursor = xlDefault

        connect.closeConnection
        Set connect = Nothing
        Set sheetCtrl = Nothing

        Exit Sub
    End If

    Application.Cursor = xlDefault
    ' DB�ւ̃R�l�N�V������ؒf
    connect.closeConnection

    Set connect = Nothing
    Set sheetCtrl = Nothing

    ' �u�G���[�`�F�b�N���I�����܂����B�G���[�ꗗ�V�[�g���m�F���Ă��������B�v
    MsgBox CHECK_COMPLETED_MSG, vbOKOnly + vbInformation
    
    Exit Sub

clickErrorCheckButton_Err:
    Application.Cursor = xlDefault
    
    connect.closeConnection

    Set sheetCtrl = Nothing
    Set connect = Nothing

    MsgBox ERR_RAISED_MSG & vbCrLf & Err.Description, vbCritical + vbOKOnly

End Sub


' �u�o�^�v�{�^������
Public Sub clickRegisterButton()
    Dim ret As Long
    
    Dim mainView As New MainSheetView
    Dim errView As New ErrorListView
    Dim evalView As New EvalSheetView
    
    Dim sheetCtrl As SheetControl
    Dim connect As DBConnection

    On Error GoTo clickRegisterButton_Err
    
    Set sheetCtrl = New SheetControl
    
    With sheetCtrl
        .MainSheetView = mainView
        .EvalSheetView = evalView
        .ErrorListView = errView
    End With

    ' �u���C���v�V�[�g�̃`�F�b�N
    ret = mainView.checkSheet()
    If ret = MAIN_SHEET_CHK_RSLT.NOT_SELECTED_ERROR Then
        ' �����Ώۂ��ЂƂ��I������Ă��Ȃ�
        MsgBox ERR_SHEET_NOT_SELECTED, vbExclamation + vbOKOnly

        Exit Sub
    ElseIf ret = MAIN_SHEET_CHK_RSLT.NENDO_NO_INPUT_ERROR Then
        ' �����Ώۂ̕]���V�[�g�Ɂu�N�x�v�����L��
        MsgBox ERR_SHEET_NENDO_NOT_INPUT, vbExclamation + vbOKOnly

        Exit Sub
    End If

    '�ڑ����̐ݒ�
    If setConnectionString() = False Then
        Exit Sub ' �ڑ����̐ݒ肪���s�����ꍇ�͂����ŏ������I��
    End If

    '�L�����Z���̏ꍇ�́A�����𒆒f
    If frmConnectDB.flgCancel = True Then
        Exit Sub
    End If

    ' �J�[�\���������v
    Application.Cursor = xlWait

    ' DB�ւ̃R�l�N�V�������m��
    Set connect = New DBConnection

    Call connect.setConnectString(mainView.getConnectString())

    connect.openConnection
    
    sheetCtrl.DBConnection = connect

    ' �G���[�`�F�b�N
    ret = sheetCtrl.checkErrorMain()
    If ret < 0 Then
        Application.Cursor = xlDefault

        connect.closeConnection
        Set connect = Nothing
        Set sheetCtrl = Nothing

        Exit Sub
    End If
    
    ' "��"�����Ă���V�[�g���o�^�\�ł��邩
    If sheetCtrl.isRegisteredMaruCheckSheets() = False Then
        Application.Cursor = xlDefault

        Exit Sub
    End If
    
    ' �o�^����
    ret = sheetCtrl.registerSheetMain()
    If ret < 0 Then
        Application.Cursor = xlDefault

        connect.closeConnection
   
        Set connect = Nothing
        Set sheetCtrl = Nothing
        
        Exit Sub
    End If
    
    Application.Cursor = xlDefault

    ' DB�ւ̃R�l�N�V������ؒf
    connect.closeConnection

    Set connect = Nothing

    Set sheetCtrl = Nothing

    ' �u�o�^���������܂����v
    MsgBox REGISTED_COMPLETED_MSG, vbOKOnly + vbInformation
    
    Exit Sub

clickRegisterButton_Err:
    Application.Cursor = xlDefault

    connect.closeConnection

    Set connect = Nothing
    Set sheetCtrl = Nothing

    MsgBox ERR_RAISED_MSG & vbCrLf & Err.Description, vbCritical + vbOKOnly

End Sub

