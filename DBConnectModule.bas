Attribute VB_Name = "DBConnectModule"
Option Explicit

Public cn As ADODB.connection  ' ODBC�I�u�W�F�N�g�i�R�l�N�V�����j

Rem***************************************************************************
Rem Function:�f�[�^�x�[�X�ڑ��ݒ�_�C�A���O�\��
Rem Ver-Rev :01-01
Rem***************************************************************************
Function setConnectionString() As Boolean
    ' �e�ϐ���`
    Dim b_nullChk As String ' �k���`�F�b�N�p������
    
    ' ������
    setConnectionString = True

    frmConnectDB.frmConnectDB_Initialize    ' �ڑ����_�C�A���O�̏���������
        
    Call changeDialogForm       '�_�C�A���O�\�����ڐ؂�ւ�
    
    frmConnectDB.txtConnectString.value = Worksheets(MAIN_SHEET_NAME).Range(DB_CONNECT_STR_CELL).value  ' �ڑ�������
    frmConnectDB.txtUsername.value = Worksheets(MAIN_SHEET_NAME).Range(DB_USER_NAME_CELL).value       ' ���[�U��

    If UCase(Worksheets(MAIN_SHEET_NAME).Range(DB_KEEP_PASSWORD_CELL).value) = "TRUE" Then
        frmConnectDB.txtPassword.value = Worksheets(MAIN_SHEET_NAME).Range(DB_PASSWORD_CELL).value       ' �p�X���[�h
    Else
        frmConnectDB.txtPassword.value = ""
    End If

    b_nullChk = Worksheets(MAIN_SHEET_NAME).Range(DB_KEEP_PASSWORD_CELL).value
    If b_nullChk = "" Then
        frmConnectDB.chkSavePassword = True ' �f�t�H���g�̓`�F�b�NON���
    End If

    frmConnectDB.Show   ' �f�[�^�x�[�X�ڑ��ݒ�_�C�A���O�\��
    
    frmConnectDB.Hide   ' ���䂪�߂��Ă����̂Ń_�C�A���O������
    
    ' �_�C�A���O�́u����v���������ꂽ�̂ŁADB�ւ̐ڑ����s��Ȃ������֐i��
    If frmConnectDB.Show_frmConnectDB_flg = False Then
        frmConnectDB.flgCancel = True
    End If
    
    '���䂪�A���Ă������Ƃ̏���
    If frmConnectDB.flgCancel = True Then
        '����{�^�������������ꍇ�� False ��Ԃ�
        setConnectionString = False
    End If
End Function

Rem***************************************************************************
Rem Function:�_�C�A���O�\�����ڐ؂�ւ�
Rem Ver-Rev :01-03
Rem***************************************************************************
Public Sub changeDialogForm()
    
    frmConnectDB.lblConnectString = "�ڑ�������"
    frmConnectDB.txtSchema.Locked = True
    frmConnectDB.txtSchema.BackColor = &H8000000F

End Sub

Rem***************************************************************************
Rem Function:�f�[�^�x�[�X�ڑ����̍쐬
Rem Ver-Rev :01-01
Rem***************************************************************************
Function PZ_GetConnectStr() As String
    Dim ret As String
    Dim ODBCDriver As String

    ODBCDriver = Worksheets(MAIN_SHEET_NAME).Range(DB_ODBC_DRIVER_NAME_CELL).value  ' ODBC�h���C�o�̎w��

    ' ODBC�h���C�o�̎w�肪���邩�𔻕�
    If Len(ODBCDriver) > 0 Then
        ret = "Driver={" & ODBCDriver & "}"                                 ' ODBC�h���C�o�̎w��
        ret = ret & ";DBQ=" & frmConnectDB.txtConnectString.value           ' �ڑ�������̎w��
        ret = ret & ";UID=" & frmConnectDB.txtUsername.value                ' ���[�U���̎w��
        ret = ret & ";PWD=" & frmConnectDB.txtPassword.value                ' �p�X���[�h�̎w��
    Else
        ret = "Provider=OraOLEDB.Oracle"                                    ' Oracle-ODBC�̎w��
        ret = ret & ";Data Source=" & frmConnectDB.txtConnectString.value   ' �ڑ�������̎w��
        ret = ret & ";User ID=" & frmConnectDB.txtUsername.value            ' ���[�U���̎w��
        ret = ret & ";Password=" & frmConnectDB.txtPassword.value           ' �p�X���[�h�̎w��
    End If
    
    ' �ڑ�����Ԃ�
    PZ_GetConnectStr = ret
End Function

Rem***************************************************************************
Rem Function:�f�[�^�x�[�X�ւ̐ڑ��m�F
Rem Ver-Rev :01-01
Rem***************************************************************************
Function PZ_chkConnect() As Boolean
    Dim strSQL As String
    
    Dim cn As ADODB.connection
    Dim rs As ADODB.Recordset
    
   ' �}�E�X�|�C���^�������v�ɕύX
    Application.Cursor = xlWait
    
    PZ_chkConnect = True

    On Error GoTo err_chkConnect
    Set cn = New ADODB.connection

    '�ڑ��m�F���s
    cn.ConnectionString = PZ_GetConnectStr()
    cn.Open
    
    strSQL = "SELECT COUNT(*) FROM TAB"
    Set rs = New ADODB.Recordset
    rs.Open strSQL, cn, adOpenForwardOnly, adLockReadOnly
    
    cn.Close
    Set rs = Nothing
    Set cn = Nothing

    Exit Function

err_chkConnect:
    ' �ڑ����ł��Ȃ�����
    Set rs = Nothing
    Set cn = Nothing
    PZ_chkConnect = False
    Application.Cursor = xlDefault  ' �}�E�X�|�C���^��߂�

End Function

