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

Private m_errCellAddr As String                     ' エラー発生セル位置
Private m_guid As String                            ' GID
Private m_personName As String                      ' 氏名
Private m_columnName As String                      ' 項目名
Private m_errType As CHECK_RESULT_TYPE              ' エラーチェック種別
Private m_errContent As String                      ' エラーメッセージ内容

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

' 機能：引数に指定された値をクラス変数に格納する
' 引数：
'   addr    : エラー発生セル位置
'   guid    : GID
'   name    : 氏名
'   column  : 回答項目名
'   err     : CHECK_RESULT_TYPE（チェックエラー種別）
'   content : エラーメッセージ
' 戻り値：なし
Public Sub setAll(addr As String, guid As String, name As String, column As String, err As CHECK_RESULT_TYPE, content As String)
    m_errCellAddr = addr
    m_guid = guid
    m_personName = name
    m_columnName = column
    m_errType = err
    m_errContent = content
End Sub

' 機能：チェックエラー種別に対応する日本語文字列を返す
' 引数：なし
' 戻り値：エラーチェック種別文字列
Public Function getErrTypeString() As String
    Dim str As String

    Select Case m_errType
        Case CHECK_RESULT_TYPE.TYPE_WARNING
            str = "警告"
        Case CHECK_RESULT_TYPE.TYPE_ERROR
            str = "エラー"
    End Select

    getErrTypeString = str
End Function

