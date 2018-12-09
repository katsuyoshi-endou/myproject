VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CheckResultView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' 「チェック結果」シートビュークラス

Private m_thisWorksheet As Worksheet


' クラス内定数定義

' シート内の行位置定義
Private Enum LINE_POS
    SHEET_TITLE = 1
    SHEET_DISCRPT = 2
    LIST_TITLE = 3
    OUTPUT_START = 4
End Enum

' シート内の列位置定義
Private Enum COLUMN_POS
    ERR_RAISE_CELL = 2
    GID = 3
    PERSON_NAME = 4
    FIELD_NAME = 5
    ERROR_TYPE = 6
    ERR_CONTENT = 7
End Enum


' コンストラクタ
Private Sub Class_Initialize()
    Set m_thisWorksheet = Worksheets(RESULT_SHEET_NAME)
End Sub

' デストラクタ
Private Sub Class_Terminate()
    Set m_thisWorksheet = Nothing
End Sub

' *****************************
'  編集済みの最終行を取得する
' *****************************
Private Function getEditedLastRow() As Long
    Dim rowStart As Long: rowStart = 0
    Dim rowCount As Long: rowCount = 0

    With m_thisWorksheet
        rowStart = .UsedRange.row
        rowCount = .UsedRange.Rows.count
    End With

    getEditedLastRow = rowCount + rowStart - 1
End Function

' *********************************
'  チェック結果をシートに出力する
' *********************************
Public Sub outputCheckResult(checkResultList As Dictionary)
    Dim key As Variant
    Dim item As CheckResultInfoDto

    For Each key In checkResultList
        Set item = checkResultList.item(key)

        With m_thisWorksheet
        End With
    Next
End Sub

' ************************************************
'  チェック結果一覧をクリア（不要な行の削除）する
' ************************************************
Public Sub clearCheckResultList()
    Dim maxRow As Long: maxRow = LINE_POS.OUTPUT_START
    Dim delArea As String

    maxRow = getEditedLastRow()

    If maxRow >= LINE_POS.OUTPUT_START Then
        ' "4:10"の形式にして消す
        delArea = CStr(LINE_POS.OUTPUT_START) & ":" & CStr(maxRow)

        m_thisWorksheet.Range(delArea).Delete
    End If
End Sub

' ********************************************************
'  チェック結果一覧に罫線を引く（外枠：実線、内枠：点線）
' ********************************************************
Public Sub drawCheckResultListLines()
    Dim maxRow As Long: maxRow = LINE_POS.OUTPUT_START

    maxRow = getEditedLastRow()

    With m_thisWorksheet
        ' B3からGxx（xxは、編集済み最終行）の領域に罫線を引く
        .Range(.Cells(LINE_POS.LIST_TITLE, COLUMN_POS.ERR_RAISE_CELL), .Cells(maxRow, COLUMN_POS.ERR_CONTENT)).Borders.LineStyle = xlContinuous
        .Range(.Cells(LINE_POS.OUTPUT_START, COLUMN_POS.ERR_RAISE_CELL), .Cells(maxRow, COLUMN_POS.ERR_CONTENT)).Borders(xlInsideHorizontal).LineStyle = xlDot
    End With
End Sub


