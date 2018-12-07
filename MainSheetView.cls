VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "MainSheetView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' 「メイン」シートクラス
' Viewクラスのようなもの

' （自身の）シート名
Private thisWorksheet As Worksheet

' コンストラクタ
Private Sub Class_Initialize()
    Set thisWorksheet = Worksheets(MAIN_SHEET_NAME)
End Sub

' デストラクタ
Private Sub Class_Terminate()
    Set thisWorksheet = Nothing
End Sub

' 接続文字列を取得
Public Property Get ConnectStr() As String
    ConnectStr = thisWorksheet.Range(DB_CONNECT_STR_CELL).value
End Property

' 接続ユーザ名を取得
Public Property Get DBUser() As String
    DBUser = thisWorksheet.Range(DB_USER_NAME_CELL).value
End Property

' 接続パスワードを取得
Public Property Get DBPassword() As String
    DBPassword = thisWorksheet.Range(DB_PASSWORD_CELL).value
End Property

' パスワード保存を取得
Public Property Get KeepPassword() As Boolean
    If StrComp(UCase(thisWorksheet.Range(DB_KEEP_PASSWORD_CELL).value), "TRUE") = 0 Then
        KeepPassword = True
    Else
        KeepPassword = False
    End If
End Property

' ODBCドライバ名を取得
Public Property Get ODBCDriver() As String
    ODBCDriver = thisWorksheet.Range(DB_ODBC_DRIVER_NAME_CELL).value
End Property

' 処理結果をシートに書き込む
'  @sheetName 評価シート名
'  @rsCnt 処理件数
Public Function outputRegResult(sheetName As String, rsCnt As Long) As Long
    Dim cell As Range
    
    On Error GoTo outputRegResult_Err
    
    Set cell = thisWorksheet.Range(M_START_CELL)

    Do While cell.Offset(0, REL_POS_EVAL_SHEET).value <> ""
        ' 「評価シート名」が同じところへ書き込む
        If StrComp(UCase(cell.Offset(0, REL_POS_EVAL_SHEET).value), UCase(sheetName)) = 0 Then
            ' 登録日時と登録件数
            cell.Offset(0, REL_POS_REG_DATE).value = format(Now, "YYYY/MM/DD hh:mm:ss")
            cell.Offset(0, REL_POS_REG_COUNT).value = CStr(rsCnt) & " 件"
            
            Exit Do
        End If
        
        Set cell = cell.Offset(1, 0)
    Loop
    
    Set cell = Nothing
    
    outputRegResult = 0
    
    Exit Function
    
outputRegResult_Err:
    Err.Raise Err.Number, "outputRegResult", Err.Description

End Function

' 登録指示の表から○のチェックが付けられたシートの情報を取得
Public Function getMaruCheckedSheets() As Dictionary
    Dim sheets As Dictionary
    Dim sheetNendo As Dictionary

    Dim cell As Range

    Set sheets = New Dictionary
    
    On Error GoTo getMaruCheckedSheets_Err
    
    Set cell = thisWorksheet.Range(M_START_CELL)
        
    Do While cell.Offset(0, REL_POS_EVAL_SHEET).value <> ""
        If cell.Offset(0, REL_POS_REG_CHECK).value = "○" Then
            Set sheetNendo = New Dictionary

            ' 評価シート名、年度
            sheetNendo.Add cell.Offset(0, REL_POS_EVAL_SHEET).value, cell.Offset(0, REL_POS_REG_NENDO).value

            sheets.Add CStr(cell.value), sheetNendo
        End If
        
        Set cell = cell.Offset(1, 0)
    Loop
    
    Set getMaruCheckedSheets = sheets

    Exit Function
    
getMaruCheckedSheets_Err:
    Set sheets = Nothing
    Err.Raise Err.Number, "getMaruCheckedSheets", Err.Description
    
End Function

' DB接続文字列を取得
Public Function getConnectString() As String
    Dim ret As String
    Dim ODBCDriver As String
    
    With thisWorksheet
        ODBCDriver = .Range(DB_ODBC_DRIVER_NAME_CELL).value  ' ODBCドライバの指定
    
        ' ODBCドライバの指定があるかを判別
        If Len(ODBCDriver) > 0 Then
            ret = "Driver={" & ODBCDriver & "}"                                 ' ODBCドライバの指定
            ret = ret & ";DBQ=" & .Range(DB_CONNECT_STR_CELL).value             ' 接続文字列の指定
            ret = ret & ";UID=" & .Range(DB_USER_NAME_CELL).value               ' ユーザ名の指定
            ret = ret & ";PWD=" & .Range(DB_PASSWORD_CELL).value                ' パスワードの指定
        Else
            ret = "Provider=OraOLEDB.Oracle"                                    ' Oracle-ODBCの指定
            ret = ret & ";Data Source=" & .Range(DB_CONNECT_STR_CELL).value     ' 接続文字列の指定
            ret = ret & ";User ID=" & .Range(DB_USER_NAME_CELL).value           ' ユーザ名の指定
            ret = ret & ";Password=" & .Range(DB_PASSWORD_CELL).value           ' パスワードの指定
        End If
    End With
    
    ' 接続情報を返す
    getConnectString = ret
End Function

' 評価シート名に一致する年度を取得する
' ここでは、年度をそのまま返す（"20XX"には変換しない）
'  @sheetName 評価シート名
Public Function getSheetNendo(sheetName As String) As String
    Dim cell As Range
    Dim row As Long: row = 0
    Dim lgcSheetName As String
    Dim nendo As String: nendo = ""

    Set cell = thisWorksheet.Range(M_START_CELL)

    Do While cell.Offset(row, REL_POS_EVAL_SHEET).value <> ""
        lgcSheetName = cell.Offset(row, REL_POS_EVAL_SHEET).value
        If StrComp(sheetName, lgcSheetName, vbTextCompare) = 0 Then
            nendo = cell.Offset(row, REL_POS_REG_NENDO).value

            Exit Do
        End If

        row = row + 1
    Loop
    Set cell = Nothing

    getSheetNendo = nendo
End Function

' シートをチェックする
' 次の内容をチェックする
' 　・処理の対象が選択されているか
' 　・「年度」が指定されているか
'
' 戻り値：0（エラーなし）、-1（年度未入力エラー）
Public Function checkSheet() As Long
    Dim ret As Long: ret = MAIN_SHEET_CHK_RSLT.NO_CHECK_ERROR
    Dim checkedSheets As Dictionary
    Dim key As Variant
    Dim shtName As Variant

    Set checkedSheets = getMaruCheckedSheets()

    If checkedSheets.Count = 0 Then
        ret = MAIN_SHEET_CHK_RSLT.NOT_SELECTED_ERROR
    Else
        ' 「年度」の入力チェック
        For Each key In checkedSheets
            For Each shtName In checkedSheets.Item(key)
                If Len(checkedSheets.Item(key).Item(shtName)) = 0 Then
                    ret = MAIN_SHEET_CHK_RSLT.NENDO_NO_INPUT_ERROR
                End If
            Next shtName
        Next key

        Set shtName = Nothing
        Set key = Nothing
    End If

    Set checkedSheets = Nothing

    checkSheet = ret

End Function

