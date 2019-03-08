VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Private bBiaClose As Boolean                ' 閉じる経由で保存が呼ばれたか？（True : 呼ばれた、False : 呼ばれていない）

' 機能：ワークブックオープン時の処理
'       ・各シートの表示／非表示を行う
'       ・人材育成計画シートの表示時、シートの初期化処理を行う
' 引数：なし
' 戻り値：なし
Private Sub Workbook_Open()
    ThisWorkbook.Unprotect Password:=BOOK_PROTECT_PASSWORD

    On Error Resume Next

    Application.ScreenUpdating = False

    ' メインシートが非表示のとき、メインシートとチェック結果シートを表示
    If ThisWorkbook.Sheets(MAIN_SHEET_NAME).Visible <> True Then
        ThisWorkbook.Sheets(MAIN_SHEET_NAME).Visible = True
        ThisWorkbook.Sheets(RESULT_SHEET_NAME).Visible = True
    End If

    ' 警告シートが表示されているとき、警告シートを非表示
    If ThisWorkbook.Sheets(WARNING_SHEET_NAME).Visible <> False Then
        ThisWorkbook.Sheets(WARNING_SHEET_NAME).Visible = False
    End If

    Application.ScreenUpdating = True

    On Error GoTo 0

    If ThisWorkbook.Sheets(MAIN_SHEET_NAME).Visible = True Then
        Call initialJinikSheetActivation
    End If

    ' 各フラグを初期化
    Call setJinikSheetEdited(False)
    Call setErrorChecked(False)
    Call setChkRsltSheetEdited(False)

    ThisWorkbook.protect Password:=BOOK_PROTECT_PASSWORD

    Exit Sub
End Sub

' 機能：ワークブックの保存前処理
' 引数：
'   SaveAsUI :
'   Cancel   : キャンセルフラグ（TRUE : 保存処理をしない）
' 戻り値：なし
Private Sub Workbook_BeforeSave(ByVal SaveAsUI As Boolean, Cancel As Boolean)
    Dim ret As Long

    Cancel = True

    '閉じる経由で呼ばれていない場合は、ここでグレー項目を破棄するかどうか聞く
    If bBiaClose = False Then
        ' グレーアウトしている項目については、データを保持しません。よろしいですか？
        ret = MsgBox(CONFIRM_DATA_ERASE_MSG, vbQuestion + vbYesNo)
        If ret = vbNo Then
            Cancel = True
            bBiaClose = False
            Exit Sub
        End If

        ' なにかしら編集されていれば、「アップロード不可（エラーチェック未実施）」にする
        If isJinikSheetEdited() = True Then
            Call setUploadStatusString(TITLE_UPLOAD_DISABLE_MSG, SUB_TITLE_NO_CHECK_MSG, CHECK_RESULT.CHK_ERROR)
        End If
    Else
        ' 閉じる経由のときは、Workbook_BeforeCloseで処理するので、ここでは何もしない
    End If

    ' グレーアウトしている項目の値を破棄する
    Call clearDataDisabledFields

    Call controlSheetsBeforeSave

    ' 状態をもとに戻す
    Call setJinikSheetEdited(False)
    Call setErrorChecked(False)
    Call setChkRsltSheetEdited(False)

    bBiaClose = False

    ThisWorkbook.Saved = True
End Sub


' 機能：ワークブックを閉じる前の処理
' 引数：
'   Cancel : 閉じるキャンセルフラグ（TRUE : ワークブックを閉じない）
' 戻り値：なし
Private Sub Workbook_BeforeClose(Cancel As Boolean)
    Dim ret As Long

    If isJinikSheetEdited() = False And isErrorChecked() = False And isChkRsltSheetEdited() = False Then
        ' ワークブックの初期化処理で行われること以外にシートが更新されていないとき、それらの更新をなかったことにする
        Me.Saved = True
        Exit Sub
    ElseIf isErrorChecked() = True And isJinikSheetEdited() = False Then
        ' エラーチェックだけしているとき、チェック結果をとっておくように保存を勧める
        ' チェック結果を保存します。よろしいですか？
        ret = MsgBox(CONFIRM_CHK_RSLT_SAVE_MSG, vbQuestion + vbYesNo)
        If ret = vbYes Then
            bBiaClose = True
            Call controlSheetsBeforeClose
            Exit Sub
        Else
            ' 「いいえ」のときは、保存せずにExcel終了
            Me.Saved = True
            Exit Sub
        End If
    ElseIf isErrorChecked() = False And isJinikSheetEdited() = True Then
        ' エラーチェックはせず、編集のみしているとき
        ' 保存します。よろしいですか？" & vbCrLf & "エラーチェックが行われていないため、アップロードできません。" & vbCrLf & "アップロードするには「エラーチェックして保存」でエラーチェックを行う必要があります。
        ret = MsgBox(CONFIRM_SAVE_MSG, vbQuestion + vbYesNoCancel)
        If ret = vbYes Then
            ' グレーアウトしている項目については、データを保持しません。よろしいですか？
            ret = MsgBox(CONFIRM_DATA_ERASE_MSG, vbQuestion + vbYesNo)
            If ret = vbNo Then
                Me.Saved = True
                Cancel = True
                Exit Sub
            End If

            If isJinikSheetEdited() = True Then
                Call setUploadStatusString(TITLE_UPLOAD_DISABLE_MSG, SUB_TITLE_NO_CHECK_MSG, CHECK_RESULT.CHK_ERROR)
            End If

            bBiaClose = True
            Call controlSheetsBeforeClose
            Exit Sub
        ElseIf ret = vbNo Then
            ' 「いいえ」のときは、更新を破棄してExcel終了
            Me.Saved = True
            Exit Sub
        ElseIf ret = vbCancel Then
            ' 「キャンセル」のときは、Excelは終了せずに戻る
            Me.Saved = True
            Cancel = True
            Exit Sub
        End If
    ElseIf isErrorChecked() = True And isJinikSheetEdited() = True Then
        ' シートも編集されていて、エラーチェックもしているとき
        ' ファイルが変更されています。& vbCrLf & 保存します。よろしいですか？
        ret = MsgBox(CONFIRM_EXCEL_BOOK_SAVE_MSG, vbQuestion + vbYesNo)
        If ret = vbYes Then
            bBiaClose = True
            Call controlSheetsBeforeClose
            Exit Sub
        Else
            ' 「いいえ」のときは、保存せずにExcel終了
            Me.Saved = True
            Exit Sub
        End If
    End If
End Sub

' 機能：ワークブックを閉じる際の各シートの表示制御
' 引数：なし
' 戻り値：なし
Private Sub controlSheetsBeforeClose()

    ' イベントの発生と画面更新を停止
    Application.EnableEvents = False
    Application.ScreenUpdating = False

    ' ワークブック保護を解除
    ThisWorkbook.Unprotect Password:=BOOK_PROTECT_PASSWORD

    ' 各シートの表示を制御
    With ThisWorkbook
        .Sheets(WARNING_SHEET_NAME).Visible = True      ' 「警告」シートをアクティブ表示
        .Sheets(WARNING_SHEET_NAME).Activate
        .Sheets(MAIN_SHEET_NAME).Visible = False        ' 「人材育成計画」シートを非表示
        .Sheets(RESULT_SHEET_NAME).Visible = False      ' 「チェック結果」シートを非表示
        .Sheets(MASTER_SHEET_NAME).Visible = False      ' 「master」シートを非表示

        ' ワークブックを保護
        .protect Password:=BOOK_PROTECT_PASSWORD

        ' シートの表示を制御したあとで保存処理
        .Save
    End With

    ' イベントの発生と画面更新の制御を再開
    Application.EnableEvents = True
    Application.ScreenUpdating = True
End Sub

' 機能：ワークブック保存時の各シートの表示制御
' 引数：なし
' 戻り値：なし
Private Sub controlSheetsBeforeSave()
    Dim actSheet As Worksheet
    Dim actCell As Range
    Dim scrlRow As Long
    Dim scrlCol As Long
    Dim WarnSheetVisible As Boolean
    Dim MainSheetVisible As Boolean
    Dim ChkRsltSheetVisible As Boolean
    Dim MasterSheetVisible As Boolean

    ' イベントの発生と画面更新を停止
    Application.EnableEvents = False
    Application.ScreenUpdating = False

    ' アクティブなシートの状態（セル位置やスクロールの行列）
    Set actSheet = ActiveSheet
    Set actCell = ActiveCell
    scrlRow = ActiveWindow.ScrollRow
    scrlCol = ActiveWindow.ScrollColumn

    With ThisWorkbook
        ' ワークブックの保護を解除
        .Unprotect Password:=BOOK_PROTECT_PASSWORD

        ' 各シートの表示を制御
        .Sheets(WARNING_SHEET_NAME).Visible = True      ' 「警告」シートをアクティブ表示
        .Sheets(WARNING_SHEET_NAME).Activate
        .Sheets(MAIN_SHEET_NAME).Visible = False        ' 「人材育成計画」シートを非表示
        .Sheets(RESULT_SHEET_NAME).Visible = False      ' 「チェック結果」シートを非表示
        .Sheets(MASTER_SHEET_NAME).Visible = False      ' 「master」シートを非表示

        ' シートに保護をかけた状態で保存
        .protect Password:=BOOK_PROTECT_PASSWORD

        .Save

        ' 再度、ワークブックの保護を解除
        .Unprotect Password:=BOOK_PROTECT_PASSWORD

        ' 各シートの表示を制御
        .Sheets(MAIN_SHEET_NAME).Visible = True         ' 「人材育成計画」シートを表示
        .Sheets(RESULT_SHEET_NAME).Visible = True       ' 「チェック結果」シートを表示
        .Sheets(MASTER_SHEET_NAME).Visible = False      ' 「master」シートは非表示（のまま）
        .Sheets(WARNING_SHEET_NAME).Visible = False     ' 「警告」シートは非表示

        ' ワークブックを保護
        .protect Password:=BOOK_PROTECT_PASSWORD
    End With

    ' シートの表示をもとに戻す
    actSheet.Activate
    cells(1, 1).Select
    ActiveWindow.ScrollRow = scrlRow
    ActiveWindow.ScrollColumn = scrlCol

    ' イベントの発生と画面更新の制御を再開
    Application.EnableEvents = True
    Application.ScreenUpdating = True
End Sub

