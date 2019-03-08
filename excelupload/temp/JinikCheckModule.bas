Attribute VB_Name = "JinikCheckModule"
Option Explicit

' *********************************
' 「エラーチェック実施」ボタン押下
' *********************************
Public Sub ErrorCheckButtonClick()
    Dim chkResult As Long: chkResult = 0
    Dim rsltMsg As String

    Dim control As SheetControl

    On Error GoTo ErrorCheckButtonClick_Err

    Dim jinikView As New JinikSheetView
    Dim resultView As New CheckResultView
    Dim masterView As New MasterSheetView

    Set control = New SheetControl

    With control
        .JinikSheetView = jinikView
        .CheckResultView = resultView
        .MasterSheetView = masterView
    End With

    ' カーソルを砂時計に
    Application.Cursor = xlWait

    ' チェック処理中はイベントの発生を無効化およびシートのロックを外す
    Application.EnableEvents = False
    Call jinikView.setSheetProtect(False)

    ' エラーチェック処理を実行
    chkResult = control.executeSheetCheck

    If chkResult = CHECK_RESULT.CHK_NO_ERROR Or chkResult = CHECK_RESULT.CHK_WARNING Then
        Call jinikView.setStatusString(TITLE_UPLOAD_ENABLE_MSG, "", CHECK_RESULT.CHK_NO_ERROR)
    Else
        Call jinikView.setStatusString(TITLE_UPLOAD_DISABLE_MSG, SUB_TITLE_UPLOAD_DISABLE_MSG, CHECK_RESULT.CHK_ERROR)
    End If

    Call jinikView.setSheetProtect(True)
    Application.EnableEvents = True

    Application.Cursor = xlDefault

    ' 実行結果により処理完了メッセージを切り替える
    If chkResult = CHECK_RESULT.CHK_NO_ERROR Or chkResult = CHECK_RESULT.CHK_WARNING Then
        MsgBox MSG_CHECK_NO_ERROR, vbInformation + vbOKOnly
    Else
        MsgBox MSG_CHECK_ERROR, vbExclamation + vbOKOnly
    End If

    ' リソースの解放
    Set jinikView = Nothing
    Set resultView = Nothing
    Set masterView = Nothing

    Set control = Nothing

    ' 編集済み済みフラグをリセット
    Call setJinikSheetEdited(False)
    ' エラーチェック済みフラグをセット
    Call setErrorChecked(True)

    Exit Sub

ErrorCheckButtonClick_Err:
    Application.Cursor = xlDefault

    If control Is Nothing Then
        Set control = Nothing
    End If

    If jinikView Is Nothing Then
        Set jinikView = Nothing
    End If

    If resultView Is Nothing Then
        Set resultView = Nothing
    End If

    MsgBox ERR_RAISED_MSG + vbCrLf + err.Description, vbCritical + vbOKOnly

End Sub

