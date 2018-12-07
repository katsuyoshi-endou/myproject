VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ErrorItemDto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' チェックエラークラス（dtoクラスのようなもの）

Private errSheetName As String          ' エラーシート名
Private errRow As String                ' エラー発生行
Private errType As Long                 ' エラー種別
Private errContent As String            ' エラー内容

' コンストラクタ
Private Sub Class_Initialize()
    errType = -1
End Sub

' デストラクタ
Private Sub Class_Terminate()

End Sub

' プロパティに対するアクセス

' 「シート名」
Public Function getSheetName() As String
    getSheetName = errSheetName
End Function

Public Sub setSheetName(name As String)
    errSheetName = name
End Sub

' エラー発生行
Public Function getRow() As String
    getRow = errRow
End Function

Public Sub setRow(row As String)
    errRow = row
End Sub

' エラー種別
Public Function getType() As String
    getType = errType
End Function

Public Function getTypeStr() As String
    Dim str As String
    
    Select Case errType
        ' 情報
        Case ERROR_TYPE.CHK_INFO
            str = CHK_INFO_MSG
        ' 警告
        Case ERROR_TYPE.CHK_WARNING
            str = CHK_WARNING_MSG
        ' エラー
        Case ERROR_TYPE.CHK_ERROR
            str = CHK_ERROR_MSG
        Case Else
            str = ""
    End Select
    
    getTypeStr = str
End Function

Public Sub setType(tp As String)
    errType = tp
End Sub

' 「エラー内容」
Public Function getContent() As String
    getContent = errContent
End Function

Public Sub setContent(con As String)
    errContent = con
End Sub

Public Sub setCheck(sheetNm As String, row As String, stype As Long, content As String)
    errSheetName = sheetNm
    errRow = row
    errType = stype
    errContent = content
End Sub
