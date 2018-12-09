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

Private m_errCellAddr As String
Private m_guid As String
Private m_personName As String
Private m_columnName As String
Private m_errType As CHECK_RESULT_TYPE
Private m_errContent As String

Public Property Get getErrCellAddr() As String
    getErrCellAddr = m_errCellAddr
End Property

Public Property Let setErrCellAddr(addr As String)
    m_errCellAddr = addr
End Property

Public Property Get getGuid() As String
    getGuid = m_guid
End Property

Public Property Let setGuid(g As String)
    m_guid = g
End Property

Public Property Get getPersonName() As String
    getPersonName = m_personName
End Property

Public Property Let setPersonName(name As String)
    m_personName = name
End Property

Public Property Get getColumnName() As String
    getColumnName = m_columnName
End Property

Public Property Let setColumnName(name As String)
    m_columnName = name
End Property

Public Property Get getErrType() As CHECK_RESULT_TYPE
    getErrType = m_errType
End Property

Public Property Let setErrType(errType As CHECK_RESULT_TYPE)
    m_errType = errType
End Property

Public Property Get getErrContent() As String
    getErrContent = m_errContent
End Property

Public Property Let setErrContent(content As String)
    m_errContent = content
End Property

' コンストラクタ
Private Sub Class_Initialize()
End Sub

' デストラクタ
Private Sub Class_Terminate()
End Sub

Public Sub setAll(addr As String, guid As String, name As String, COLUMN As String, err As CHECK_RESULT_TYPE, content As String)
    m_errCellAddr = addr
    m_guid = guid
    m_personName = name
    m_columnName = COLUMN
    m_errType = err
    m_errContent = content
End Sub
