VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Private Sub Worksheet_Change(ByVal Target As Range)
    Dim i As Long
    Dim j As Long
    Dim k As Long
    Dim row As Long
    Dim column As Long

    On Error GoTo Worksheet_Change_Err

    If ActiveSheet.Range(ADDR_FIRST_JINIK_DATA).row > Target.row Then
        Exit Sub
    End If

    Call setJinikSheetEdited(True)
    Call setErrorChecked(False)

    ' いったん、シートの保護を解除して書式をセットする
    ActiveSheet.Unprotect Password:=SHEET_PROTECT_PASSWORD

    Application.ScreenUpdating = False

    For i = 1 To Target.Areas.count
        For j = 0 To Target.Areas(i).Rows.count - 1
            row = Target.Areas(i).row + j
    
            For k = 0 To Target.Areas(i).Columns.count - 1
                column = Target.Areas(i).column + k
    
                ' 処理を振り分け
                If isEventArea(FIELD_IDO_COLUMN_POS, column) = True Then
                    ' 1年後～5年後＆予定の「異動」が変更されたとき
                    Call execIdoChangeEvent(row, column)
                ElseIf isEventArea(FIELD_TAISHOKU_COLUMN_POS, column) = True Then
                    ' 1年後～5年後の「退職」が変更されたとき
                    Call execTaishokuChangeEvent(row, column)
                ElseIf isEventArea(FIELD_KYOTEN_COLUMN_POS, column) = True Then
                    ' 1年後～5年後＆予定の「拠点」が変更されたとき
                    Call execKyotenChangeEvent(row, column)
                ElseIf isEventArea(FIELD_YOUHI_COLUMN_POS, column) = True Then
                    ' 1年後～5年後＆予定の「後任要否」が変更されたとき
                    Call execKouninYouhiChangeEvent(row, column)
                ElseIf column >= START_COLUMN_KEIKAKU_AREA And column <= END_COLUMN_KEIKAKU_AREA Then
                    ' 上記以外の（担当業務・異動）計画入力エリアが変更されたとき
                    Call execKeikakuAreaChangeEvent(row, column)
                ElseIf column = JINIK_KAITO_BUYER_JIKI_CLMN_POS Or column = JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS Then
                    Call setBuyerFieldsAvailable(row)
                ElseIf column = JINIK_KAITO_TOUYO_JIKI_CLMN_POS Or column = JINIK_KAITO_TOUYO_KEIKAKU_CLMN_POS Then
                    Call setTouyoKeikakuAvailable(row)
                ElseIf column = JINIK_KAITO_IDO_MONTH_CLMN_POS Or column = JINIK_KAITO_IDO_PLACE_CLMN_POS Then
                    Call setIdoJissekiAavailable(row)
                ElseIf column = JINIK_KAITO_GENZAI_TANTO_GYOMU_CLMN_POS Then
                    Call setFieldAvailable(row, column, EDIT_TYPE.CELL_REQUIRED)
                ElseIf column = JINIK_KAITO_OTHER_CLMN_POS Then
                    Call setFieldAvailable(row, column, EDIT_TYPE.CELL_OPTION)
                Else
                    ' 上記以外は何もしない
                End If
            Next k
        Next j
    Next i

    Application.ScreenUpdating = True

    ActiveSheet.protect AllowFormattingColumns:=True, Password:=SHEET_PROTECT_PASSWORD

    Exit Sub

Worksheet_Change_Err:
    Application.ScreenUpdating = True

    MsgBox ERR_RAISED_MSG & err.Description, vbCritical + vbOKOnly

End Sub

' Worksheet_Changeの発生した列が処理を行う対象の列かどうか判定する
Private Function isEventArea(Target As String, column As Long) As Boolean
    Dim ret As Boolean: ret = False
    Dim i As Long
    Dim values() As String

    If Target <> "" Or Len(Target) > 0 Then
        values = Split(Target, ",")

        For i = 0 To UBound(values, 1)
            If CLng(values(i)) = column Then
                ret = True
                Exit For
            End If
        Next i
    End If

    isEventArea = ret
End Function
