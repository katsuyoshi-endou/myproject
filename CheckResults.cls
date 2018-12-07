VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CheckResults"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' チェック結果を格納するクラス
Private errors As Dictionary                ' チェック結果

' コンストラクタ
Private Sub Class_Initialize()
    Set errors = New Dictionary
End Sub

' デストラクタ
Private Sub Class_Terminate()
    errors.RemoveAll

    Set errors = Nothing
End Sub

' エラー件数を返す
Public Property Get Count() As Long
    Count = errors.Count
End Property

' チェック結果を格納する
'  @name 評価シート名
'  @row エラー行位置
'  @stype エラー種別
'  @content エラー内容
Public Sub addCheckResult(name As String, row As String, stype As Long, content As String)
    Dim error As ErrorItemDto
    
    On Error GoTo addCheckResult_Err

    Set error = New ErrorItemDto

    Call error.setCheck(name, row, stype, content)

    Call errors.Add(CStr(errors.Count + 1), error)
    
    Set error = Nothing

    Exit Sub

addCheckResult_Err:
    Set error = Nothing

    Err.Raise Err.Number, "addCheckResult", Err.Description

End Sub

' チェックエラーオブジェクトのキー（1からの連番）を返す
Public Function getKeys() As Variant
    getKeys = errors.keys
End Function

' キー（1からの連番）に一致する要素（チェック内容）を返す
'  @key キー
Public Function getError(key As String) As Variant
    On Error GoTo getError_Err

    Set getError = errors.Item(key)

    Exit Function

getError_Err:
    Err.Raise Err.Number, "getError", Err.Description

End Function

