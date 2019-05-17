VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CheckResultInfoDto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private m_errCellAddr As String                     ' �G���[�����Z���ʒu
Private m_guid As String                            ' GID
Private m_personName As String                      ' ����
Private m_columnName As String                      ' ���ږ�
Private m_errType As CHECK_RESULT_TYPE              ' �G���[�`�F�b�N���
Private m_errContent As String                      ' �G���[���b�Z�[�W���e

Public Property Get ErrCellAddr() As String
    ErrCellAddr = m_errCellAddr
End Property

Public Property Let ErrCellAddr(addr As String)
    m_errCellAddr = addr
End Property

Public Property Get OwnGuid() As String
    OwnGuid = m_guid
End Property

Public Property Let OwnGuid(g As String)
    m_guid = g
End Property

Public Property Get PersonName() As String
    PersonName = m_personName
End Property

Public Property Let PersonName(name As String)
    m_personName = name
End Property

Public Property Get ColumnName() As String
    ColumnName = m_columnName
End Property

Public Property Let ColumnName(name As String)
    m_columnName = name
End Property

Public Property Get ErrResultType() As CHECK_RESULT_TYPE
    ErrResultType = m_errType
End Property

Public Property Let ErrResultType(errType As CHECK_RESULT_TYPE)
    m_errType = errType
End Property

Public Property Get ErrMsgContent() As String
    ErrMsgContent = m_errContent
End Property

Public Property Let ErrMsgContent(content As String)
    m_errContent = content
End Property

' �@�\�F�����Ɏw�肳�ꂽ�l���N���X�ϐ��Ɋi�[����
' �����F
'   addr    : �G���[�����Z���ʒu
'   guid    : GID
'   name    : ����
'   column  : �񓚍��ږ�
'   err     : CHECK_RESULT_TYPE�i�`�F�b�N�G���[��ʁj
'   content : �G���[���b�Z�[�W
' �߂�l�F�Ȃ�
Public Sub setAll(addr As String, guid As String, name As String, column As String, err As CHECK_RESULT_TYPE, content As String)
    m_errCellAddr = addr
    m_guid = guid
    m_personName = name
    m_columnName = column
    m_errType = err
    m_errContent = content
End Sub

' �@�\�F�`�F�b�N�G���[��ʂɑΉ�������{�ꕶ�����Ԃ�
' �����F�Ȃ�
' �߂�l�F�G���[�`�F�b�N��ʕ�����
Public Function getErrTypeString() As String
    Dim str As String

    Select Case m_errType
        Case CHECK_RESULT_TYPE.TYPE_WARNING
            str = "�x��"
        Case CHECK_RESULT_TYPE.TYPE_ERROR
            str = "�G���["
    End Select

    getErrTypeString = str
End Function
