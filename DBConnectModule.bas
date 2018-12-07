Attribute VB_Name = "DBConnectModule"
Option Explicit

Public cn As ADODB.connection  ' ODBCオブジェクト（コネクション）

Rem***************************************************************************
Rem Function:データベース接続設定ダイアログ表示
Rem Ver-Rev :01-01
Rem***************************************************************************
Function setConnectionString() As Boolean
    ' 各変数定義
    Dim b_nullChk As String ' ヌルチェック用文字列
    
    ' 初期化
    setConnectionString = True

    frmConnectDB.frmConnectDB_Initialize    ' 接続情報ダイアログの初期化処理
        
    Call changeDialogForm       'ダイアログ表示項目切り替え
    
    frmConnectDB.txtConnectString.value = Worksheets(MAIN_SHEET_NAME).Range(DB_CONNECT_STR_CELL).value  ' 接続文字列
    frmConnectDB.txtUsername.value = Worksheets(MAIN_SHEET_NAME).Range(DB_USER_NAME_CELL).value       ' ユーザ名

    If UCase(Worksheets(MAIN_SHEET_NAME).Range(DB_KEEP_PASSWORD_CELL).value) = "TRUE" Then
        frmConnectDB.txtPassword.value = Worksheets(MAIN_SHEET_NAME).Range(DB_PASSWORD_CELL).value       ' パスワード
    Else
        frmConnectDB.txtPassword.value = ""
    End If

    b_nullChk = Worksheets(MAIN_SHEET_NAME).Range(DB_KEEP_PASSWORD_CELL).value
    If b_nullChk = "" Then
        frmConnectDB.chkSavePassword = True ' デフォルトはチェックON状態
    End If

    frmConnectDB.Show   ' データベース接続設定ダイアログ表示
    
    frmConnectDB.Hide   ' 制御が戻ってきたのでダイアログを消去
    
    ' ダイアログの「閉じる」が押下されたので、DBへの接続を行わない処理へ進む
    If frmConnectDB.Show_frmConnectDB_flg = False Then
        frmConnectDB.flgCancel = True
    End If
    
    '制御が帰ってきたあとの処理
    If frmConnectDB.flgCancel = True Then
        '取消ボタンを押下した場合は False を返す
        setConnectionString = False
    End If
End Function

Rem***************************************************************************
Rem Function:ダイアログ表示項目切り替え
Rem Ver-Rev :01-03
Rem***************************************************************************
Public Sub changeDialogForm()
    
    frmConnectDB.lblConnectString = "接続文字列"
    frmConnectDB.txtSchema.Locked = True
    frmConnectDB.txtSchema.BackColor = &H8000000F

End Sub

Rem***************************************************************************
Rem Function:データベース接続情報の作成
Rem Ver-Rev :01-01
Rem***************************************************************************
Function PZ_GetConnectStr() As String
    Dim ret As String
    Dim ODBCDriver As String

    ODBCDriver = Worksheets(MAIN_SHEET_NAME).Range(DB_ODBC_DRIVER_NAME_CELL).value  ' ODBCドライバの指定

    ' ODBCドライバの指定があるかを判別
    If Len(ODBCDriver) > 0 Then
        ret = "Driver={" & ODBCDriver & "}"                                 ' ODBCドライバの指定
        ret = ret & ";DBQ=" & frmConnectDB.txtConnectString.value           ' 接続文字列の指定
        ret = ret & ";UID=" & frmConnectDB.txtUsername.value                ' ユーザ名の指定
        ret = ret & ";PWD=" & frmConnectDB.txtPassword.value                ' パスワードの指定
    Else
        ret = "Provider=OraOLEDB.Oracle"                                    ' Oracle-ODBCの指定
        ret = ret & ";Data Source=" & frmConnectDB.txtConnectString.value   ' 接続文字列の指定
        ret = ret & ";User ID=" & frmConnectDB.txtUsername.value            ' ユーザ名の指定
        ret = ret & ";Password=" & frmConnectDB.txtPassword.value           ' パスワードの指定
    End If
    
    ' 接続情報を返す
    PZ_GetConnectStr = ret
End Function

Rem***************************************************************************
Rem Function:データベースへの接続確認
Rem Ver-Rev :01-01
Rem***************************************************************************
Function PZ_chkConnect() As Boolean
    Dim strSQL As String
    
    Dim cn As ADODB.connection
    Dim rs As ADODB.Recordset
    
   ' マウスポインタを砂時計に変更
    Application.Cursor = xlWait
    
    PZ_chkConnect = True

    On Error GoTo err_chkConnect
    Set cn = New ADODB.connection

    '接続確認実行
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
    ' 接続ができなかった
    Set rs = Nothing
    Set cn = Nothing
    PZ_chkConnect = False
    Application.Cursor = xlDefault  ' マウスポインタを戻す

End Function

