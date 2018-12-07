VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "EvalSheetView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' 評価シート共通クラス
' Viewクラスのようなもの

' 評価シート名
Private m_sheetName As String

' 評価シート名を設定する
'  @name 評価シート名
Public Property Let sheetName(name As String)
    m_sheetName = name
End Property

' 評価シートからチェック条件を取得する
Public Function getCheckRule() As Dictionary
    Dim column As Long
    Dim rules As Dictionary
    Dim cell As Range
    Dim rule As CheckRuleDto
    
    Set rules = New Dictionary
    
    On Error GoTo getCheckRule_Err
    
    Set cell = Worksheets(m_sheetName).Range(H_SHT_START_CELL)
        
    column = START_DATA_COL
    Do While cell.value <> ""
        If Len(cell.value) > 0 And Not (StrComp(cell.value, "-") = 0) Then
        
            Set rule = New CheckRuleDto
        
            ' 「項目名」から「固定値」まで
            rule.setCheckRule column, _
                              cell.Offset(0, 0).value, _
                              cell.Offset(1, 0).value, _
                              cell.Offset(2, 0).value, _
                              cell.Offset(3, 0).value, _
                              cell.Offset(4, 0).value, _
                              cell.Offset(5, 0).value, _
                              cell.Offset(6, 0).value

            ' 物理項目名をキーにして、チェック内容をDictionaryオブジェクトに格納
            rules.Add cell.Offset(1, 0).value, rule
        
            Set rule = Nothing
        End If
        column = column + 1
        
        Set cell = cell.Offset(0, 1)
    Loop
    
    Set getCheckRule = rules

    Exit Function

getCheckRule_Err:
    Set rules = Nothing

    Err.Raise Err.Number, "getCheckRule", Err.Description

End Function

' 評価シートの内容を2次元配列としてメモリ上に確保する
' シート内のセルへのアクセスが遅いとき用
Public Function getSheetArrayData() As Variant
    Dim maxRow As Long
    Dim maxCol As Long
    Dim rowStart As Long
    Dim rowCount As Long

    On Error GoTo getSheetArrayData_Err

    With Worksheets(m_sheetName)
        rowStart = .UsedRange.row
        rowCount = .UsedRange.Rows.Count
        maxRow = rowCount + rowStart - 1

        maxCol = .Cells(H_SHT_START_ROW, Columns.Count).End(xlToLeft).column

        ' シートの左上から編集範囲の右下
        getSheetArrayData = .Range(.Cells(1, 1), .Cells(maxRow, maxCol))
    End With

    Exit Function

getSheetArrayData_Err:
    Err.Raise Err.Number, "getSheetArrayData", Err.Description

End Function

' 評価シートの内容をRegSheetInfoDto のコレクションとして返す
Public Function getSheetDataToRegSheetInfoDto() As Collection
    Dim sheetData As Variant
    Dim data As RegSheetInfoDto
    Dim regData As Collection
    Dim row As Long, col As Long
    Dim colName As String, value As String, fixedValue As String
    Dim tmpValue As Variant

    On Error GoTo getSheetDataToRegSheetInfoDto_Err

    sheetData = getSheetArrayData()

    Set regData = New Collection

    For row = START_DATA_ROW To UBound(sheetData, 1)
        Set data = New RegSheetInfoDto

        For col = START_DATA_COL To UBound(sheetData, 2)
            colName = CStr(sheetData(PHY_COL_NAME_ROW_NUM, col))
            value = CStr(sheetData(row, col))
            fixedValue = CStr(sheetData(FIXED_VAL_ROW_NUM, col))

            If fixedValue <> "" And Len(fixedValue) > 0 Then
                ' 固定値が定義されていれば、その値で上書き
                value = fixedValue
            End If

            Select Case colName
                Case "PARTY"
                    data.party = value
                Case "GID"
                    data.guid = value
                Case "FORMAT"
                    data.format = value
                Case "STATUS_CD"
                    ' ステータスコードは、「コード : ステータス名」で記述されているので":"の前部分を取り出す
                    tmpValue = Split(value, ":")
                    data.statusCd = Trim(CStr(tmpValue(0)))
                Case "FLOW_PTN"
                    ' フローパターンは、「コード : フローパターン名」で記述されているので":"の前部分を取り出す
                    tmpValue = Split(value, ":")
                    data.flowPtn = Trim(CStr(tmpValue(0)))
                Case "ACTOR_1ST"
                    data.actor1st = value
                Case "ACTOR_2ND"
                    data.actor2nd = value
                Case "ACTOR_3RD"
                    data.actor3rd = value
                Case "ACTOR_4TH"
                    data.actor4th = value
                Case "-"
                Case Else
                    ' 上記以外はシート回答情報（FILL_IDは小文字に変換）
                    Call data.addFillData(LCase(colName), value)
            End Select
        Next col

        regData.Add data

        Set data = Nothing
    Next row

    Set getSheetDataToRegSheetInfoDto = regData

    Exit Function

getSheetDataToRegSheetInfoDto_Err:
    Err.Raise Err.Number, "getSheetDataToRegSheetInfoDto", Err.Description

End Function
