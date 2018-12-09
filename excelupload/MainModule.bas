Attribute VB_Name = "MainModule"
Option Explicit

' *********************************
' 「エラーチェック実施」ボタン押下
' *********************************
Public Sub ErrorCheckButtonClick()
    Dim chkResult As Long: chkResult = 0
    Dim rsltMsg As String: rsltMsg = ""

    Dim control As SheetControl

    On Error GoTo ErrorCheckButtonClick_Err

    ' カーソルを砂時計に
'    Application.Cursor = xlWait

    Set control = New SheetControl
    
    ' エラーチェック処理を実行
    Call control.executeSheetCheck

'    Application.Cursor = xlDefault

    ' 実行結果により処理完了メッセージを切り替える
    If chkResult = CHECK_RESULT.CHK_NO_ERROR Then
        MsgBox MSG_CHECK_NO_ERROR, vbInformation + vbOKOnly
    Else
        MsgBox MSG_CHECK_ERROR, vbExclamation + vbOKOnly
    End If

    Set control = Nothing

    Exit Sub

ErrorCheckButtonClick_Err:
'    Application.Cursor = xlDefault

    Set control = Nothing

    MsgBox ERR_RAISED_MSG + vbCrLf + err.Description, vbCritical + vbOKOnly

End Sub

