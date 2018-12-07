Attribute VB_Name = "MainModule"
Option Explicit

' メインモジュール
' ボタン押下時のマクロを記述する
'   ここでは、データベース接続処理関連、メイン・エラー一覧・各評価シートの共通ビュークラスの生成
'   および処理を制御するコントロールクラス（のようなもの）を生成して関連付ける


' 「エラーチェック」ボタン押下
Public Sub clickErrorCheckButton()
    Dim ret As Long
    
    Dim mainView As New MainSheetView
    Dim errView As New ErrorListView
    Dim evalView As New EvalSheetView
    
    Dim sheetCtrl As SheetControl

    Dim connect As DBConnection

    Dim chkedSheets As Dictionary

    On Error GoTo clickErrorCheckButton_Err

    ' 「メイン」シートのチェック
    ret = mainView.checkSheet()
    If ret = MAIN_SHEET_CHK_RSLT.NOT_SELECTED_ERROR Then
        ' 処理対象がひとつも選択されていない
        MsgBox ERR_SHEET_NOT_SELECTED, vbExclamation + vbOKOnly

        Exit Sub
    ElseIf ret = MAIN_SHEET_CHK_RSLT.NENDO_NO_INPUT_ERROR Then
        ' 処理対象の評価シートに「年度」が未記入
        MsgBox ERR_SHEET_NENDO_NOT_INPUT, vbExclamation + vbOKOnly

        Exit Sub
    End If

    '接続情報の設定
    If setConnectionString() = False Then
        Exit Sub ' 接続情報の設定が失敗した場合はここで処理を終了
    End If

    'キャンセルの場合は、処理を中断
    If frmConnectDB.flgCancel = True Then
        Exit Sub
    End If

    ' カーソルを砂時計
    Application.Cursor = xlWait

    ' DBへのコネクションを確立
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
    
    ' エラーチェック
    ret = sheetCtrl.checkErrorMain()
    If ret < 0 Then
        Application.Cursor = xlDefault

        connect.closeConnection
        Set connect = Nothing
        Set sheetCtrl = Nothing

        Exit Sub
    End If

    Application.Cursor = xlDefault
    ' DBへのコネクションを切断
    connect.closeConnection

    Set connect = Nothing
    Set sheetCtrl = Nothing

    ' 「エラーチェックが終了しました。エラー一覧シートを確認してください。」
    MsgBox CHECK_COMPLETED_MSG, vbOKOnly + vbInformation
    
    Exit Sub

clickErrorCheckButton_Err:
    Application.Cursor = xlDefault
    
    connect.closeConnection

    Set sheetCtrl = Nothing
    Set connect = Nothing

    MsgBox ERR_RAISED_MSG & vbCrLf & Err.Description, vbCritical + vbOKOnly

End Sub


' 「登録」ボタン押下
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

    ' 「メイン」シートのチェック
    ret = mainView.checkSheet()
    If ret = MAIN_SHEET_CHK_RSLT.NOT_SELECTED_ERROR Then
        ' 処理対象がひとつも選択されていない
        MsgBox ERR_SHEET_NOT_SELECTED, vbExclamation + vbOKOnly

        Exit Sub
    ElseIf ret = MAIN_SHEET_CHK_RSLT.NENDO_NO_INPUT_ERROR Then
        ' 処理対象の評価シートに「年度」が未記入
        MsgBox ERR_SHEET_NENDO_NOT_INPUT, vbExclamation + vbOKOnly

        Exit Sub
    End If

    '接続情報の設定
    If setConnectionString() = False Then
        Exit Sub ' 接続情報の設定が失敗した場合はここで処理を終了
    End If

    'キャンセルの場合は、処理を中断
    If frmConnectDB.flgCancel = True Then
        Exit Sub
    End If

    ' カーソルを砂時計
    Application.Cursor = xlWait

    ' DBへのコネクションを確立
    Set connect = New DBConnection

    Call connect.setConnectString(mainView.getConnectString())

    connect.openConnection
    
    sheetCtrl.DBConnection = connect

    ' エラーチェック
    ret = sheetCtrl.checkErrorMain()
    If ret < 0 Then
        Application.Cursor = xlDefault

        connect.closeConnection
        Set connect = Nothing
        Set sheetCtrl = Nothing

        Exit Sub
    End If
    
    ' "○"がついているシートが登録可能であるか
    If sheetCtrl.isRegisteredMaruCheckSheets() = False Then
        Application.Cursor = xlDefault

        Exit Sub
    End If
    
    ' 登録処理
    ret = sheetCtrl.registerSheetMain()
    If ret < 0 Then
        Application.Cursor = xlDefault

        connect.closeConnection
   
        Set connect = Nothing
        Set sheetCtrl = Nothing
        
        Exit Sub
    End If
    
    Application.Cursor = xlDefault

    ' DBへのコネクションを切断
    connect.closeConnection

    Set connect = Nothing

    Set sheetCtrl = Nothing

    ' 「登録が完了しました」
    MsgBox REGISTED_COMPLETED_MSG, vbOKOnly + vbInformation
    
    Exit Sub

clickRegisterButton_Err:
    Application.Cursor = xlDefault

    connect.closeConnection

    Set connect = Nothing
    Set sheetCtrl = Nothing

    MsgBox ERR_RAISED_MSG & vbCrLf & Err.Description, vbCritical + vbOKOnly

End Sub

