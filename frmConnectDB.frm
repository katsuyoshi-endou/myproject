VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmConnectDB 
   Caption         =   "�f�[�^�x�[�X�ڑ�"
   ClientHeight    =   3240
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4470
   OleObjectBlob   =   "frmConnectDB.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmConnectDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Rem***************************************************************************
Rem FileName:frmConnectDB
Rem Function:�ڑ����_�C�A���O�e����
Rem Ver-Rev :01-01
Rem***************************************************************************
Rem All Rights Reserved. Copyright (C) 2003, Hitachi Systems & Services, Ltd.
Rem***************************************************************************

Public flgCancel As Boolean             ' �m�ڑ��n���m�L�����Z���n���̏�����U�蕪���邽�߂̃t���O
Public Show_frmConnectDB_flg As Boolean ' �ڑ����_�C�A���O�������I�ɕ���ꂽ�ꍇ�ADB�ڑ����s��Ȃ����߂̏��������s�����邽�߂̃t���O

Rem***************************************************************************
Rem Function:�f�[�^�x�[�X�ڑ����_�C�A���O������
Rem Ver-Rev :01-01
Rem***************************************************************************x
Public Sub frmConnectDB_Initialize()
    flgCancel = False               ' �����t���O��False�ɐݒ�
    Show_frmConnectDB_flg = False   ' �����I�ɕ���ꂽ�ꍇ�̃t���O��False�ɐݒ�
    
    frmConnectDB.chkSavePassword.value = True
    
End Sub

Rem***************************************************************************
Rem Function:�ڑ��{�^���������̏���
Rem Ver-Rev :01-01
Rem***************************************************************************
Private Sub btnConnectDB_Click()
    Dim ret As Integer
   
    ' �}�E�X�|�C���^�������v�ɕύX
'    Application.Cursor = xlWait
    
    ' �ڑ������񂪓��͂���Ă��邩�`�F�b�N����
    If frmConnectDB.txtConnectString.value = "" Then
        ' �G���[���b�Z�[�W��\�����A�t�H�[�J�X�ړ�
        ret = MsgBox(EER_DB_CONNECT_STR_NOT_INPUT, vbOKOnly + vbCritical)
        frmConnectDB.txtConnectString.SetFocus
        
        Exit Sub
    End If
    
    ' ���[�U�������͂���Ă��邩�`�F�b�N����
    If frmConnectDB.txtUsername.value = "" Then
        ' �G���[���b�Z�[�W��\�����A�t�H�[�J�X�ړ�
        ret = MsgBox(EER_DB_USERID_NOT_INPUT, vbOKOnly + vbCritical)
        frmConnectDB.txtUsername.SetFocus
        
        Exit Sub
    End If
    
    ' �p�X���[�h�����͂���Ă��邩�`�F�b�N����
    If frmConnectDB.txtPassword.value = "" Then
        ' �G���[���b�Z�[�W��\�����A�t�H�[�J�X�ړ�
        ret = MsgBox(ERR_DB_PASSWORD_NOT_INPUT, vbOKOnly + vbCritical)
        frmConnectDB.txtPassword.SetFocus
        
        Exit Sub
    End If
    
    ' �_�C�A���O�ɓ��͂��ꂽ���e���V�[�g�ɔ��f
    Worksheets(MAIN_SHEET_NAME).Range(DB_CONNECT_STR_CELL).value = frmConnectDB.txtConnectString.value
    Worksheets(MAIN_SHEET_NAME).Range(DB_USER_NAME_CELL).value = frmConnectDB.txtUsername.value
    
    If chkSavePassword = True Then
        Worksheets(MAIN_SHEET_NAME).Range(DB_PASSWORD_CELL).value = frmConnectDB.txtPassword.value
    End If
        
    Worksheets(MAIN_SHEET_NAME).Range(DB_KEEP_PASSWORD_CELL).value = chkSavePassword
    
    ' �ڑ��J�n
    '���͂��ꂽ�ڑ�������DBMS�ɐڑ��ł��邩�`�F�b�N
    If PZ_chkConnect() = True Then
        ' �ڑ��ݒ�_�C�A���O�����
        frmConnectDB.Hide
        ' �ڑ��{�^�����������ꂽ�ꍇ�͕��鏈���̃t���O��ON��Ԃ�
        frmConnectDB.Show_frmConnectDB_flg = True
    Else
        ' ���炩�̌����Ńf�[�^�x�[�X�֐ڑ����ł��Ȃ�����
        ret = MsgBox(ERR_DB_CONNECT, vbOKOnly + vbCritical)
        Exit Sub
    End If
End Sub

Rem***************************************************************************
Rem Function:�L�����Z���{�^���������̏���
Rem Ver-Rev :01-01
Rem***************************************************************************
Private Sub btnCancel_Click()
    frmConnectDB.flgCancel = True
    frmConnectDB.Show_frmConnectDB_flg = True    ' ����ɃL�����Z���{�^�����������ꂽ���ߕ��鏈���̃t���O��ON��Ԃ�
    frmConnectDB.Hide
End Sub


