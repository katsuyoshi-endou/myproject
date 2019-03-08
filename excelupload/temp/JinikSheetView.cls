VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "JinikSheetView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' 「人材育成計画」シートビュークラス

Private m_thisWorksheet As Worksheet


' コンストラクタ
Private Sub Class_Initialize()
    Set m_thisWorksheet = Worksheets(MAIN_SHEET_NAME)

End Sub

' デストラクタ
Private Sub Class_Terminate()
    Set m_thisWorksheet = Nothing

End Sub

' 機能：アップロード可否欄の文字列を取得する
' 引数：なし
' 戻り値：アップロード可否文字列
Public Function getUploadStatusString() As String
    getUploadStatusString = m_thisWorksheet.Range(ADDR_UPLOAD_STATUS_TITLE).value
End Function

' 機能：アップロード可否の文字列をセットする
' 引数：
'   title    : タイトル（"アップロード可" or "アップロード不可"）
'   subtitle : サブタイトル
' 戻り値：なし
Public Sub setStatusString(title As String, subtitle As String, result As CHECK_RESULT)
    Dim clrIndex As Variant

    m_thisWorksheet.Range(ADDR_UPLOAD_STATUS_TITLE).value = title
    m_thisWorksheet.Range(ADDR_UPLOAD_STATUS_SUB_TITLE).value = subtitle

    If result = CHECK_RESULT.CHK_ERROR Then
        clrIndex = CELL_BKCOLOR_ERROR
    Else
        clrIndex = CELL_BKCOLOR_NO_ERROR
    End If

    m_thisWorksheet.Range(ADDR_UPLOAD_STATUS_TITLE).Interior.ColorIndex = clrIndex
    m_thisWorksheet.Range(ADDR_UPLOAD_STATUS_SUB_TITLE).Interior.ColorIndex = clrIndex
End Sub

' 機能：シートの年度を取得する
' 引数：なし
' 戻り値：シートの年度
Public Property Get SheetNendo() As String
    Dim str As String

    str = m_thisWorksheet.Range(ADDR_SHEET_NENDO).value

    SheetNendo = Replace(str, "年度", "")
End Property

' 機能：シートの編集済みの最終行を取得する
' 引数：なし
' 戻り値：編集済みの最終行
Private Function getEditedLastRow() As Long
    With m_thisWorksheet
        ' データ出力先頭位置（"B17"）の1行上を基準に編集済みの最終行を取得する
        getEditedLastRow = .Range(ADDR_FIRST_JINIK_DATA).Offset(-1, 0).End(xlDown).row
    End With
End Function

' 機能：引数で指定された情報に基づいてシートの値を取得し、JinikSheetInfoDto型のディクショナリオブジェクトにして返す
' 引数：
'   mapping : 項目のプロパティ情報
' 戻り値：シート回答情報
Public Function getSheetContentsFromMapping(mapping As Dictionary) As Dictionary
    Dim i As Long
    Dim value As String
    Dim address As String
    Dim key As Variant
    Dim lastRow As Long
    Dim prop As FieldProperty
    Dim dto As JinikSheetInfoDto
    Dim retObj As Dictionary

    On Error GoTo getSheetContentsFromMapping_Err

    Set retObj = New Dictionary

    lastRow = getEditedLastRow()

    With m_thisWorksheet
        For i = .Range(ADDR_FIRST_JINIK_DATA).row To lastRow
            If .cells(i, STATUS_NM_CLMN_POS).value = "" Then
                Exit For
            End If

            Set dto = New JinikSheetInfoDto

            ' シートの年度を設定
            dto.SheetNendo = Me.SheetNendo

            For Each key In mapping
                Set prop = mapping.item(key)

                value = getCellValue(i, prop.COLUMN_POS)
                If prop.FILL_ID = "STATUS_NM" Or prop.PHY_COL_NAME = "ステータス" Then
                    dto.statusName = value
                ElseIf prop.FILL_ID = "OWN_GUID" Or prop.PHY_COL_NAME = "GID" Then
                    dto.OwnGuid = value
                ElseIf prop.FILL_ID = "OWN_PERSON_NAME" Or prop.PHY_COL_NAME = "名前" Then
                    dto.PersonName = value
                Else
                    address = .Range("A1").Offset(i - 1, prop.COLUMN_POS - 1).address(False, False)

                    Call dto.addSheetFillData(prop.FILL_ID, address, prop.PHY_COL_NAME, value)
                End If

                Set prop = Nothing
            Next

            Call retObj.Add(i, dto)

            Set dto = Nothing
        Next i
    End With

    Set getSheetContentsFromMapping = retObj

    Exit Function

getSheetContentsFromMapping_Err:
    If retObj Is Nothing Then
        retObj.RemoveAll
        Set retObj = Nothing
    End If

    If dto Is Nothing Then
        Set dto = Nothing
    End If

    err.Raise err.Number, "getSheetContentsFromMapping", err.Description

End Function

' 機能：引数で指定されたセル位置の値を取得する
' 引数：
'   row    : 行
'   column : 列
' 戻り値：セルの値
'         ※セルが使用不可（背景色がグレー）のときは、空文字を返す
Private Function getCellValue(row As Long, column As Long) As String
    Dim value As String: value = ""

    With m_thisWorksheet.cells(row, column)
        ' ステータス欄(B列)から異動計画（直近）の後任要件欄(AE列)までは、使用不可だけど値を取得する
        If column >= STATUS_NM_CLMN_POS And column <= JINIK_KAITO_KONIN_YOUKEN_CHOKKIN_CLMN_POS Then
            value = .value
        Else
            If .Interior.Color <> COLOR_CELL_DISABLED Then
                value = .value
            End If
        End If
    End With

    getCellValue = value
End Function

' 機能：指定されたセル位置に値を書き込む
'       ※本処理を呼び出す際、シートの保護がかかっていないか、書き込みによってChangeイベントが発生することを考慮すること
' 引数：
'   addr  : 書き込みセル位置（A1形式）
'   value : 書き込む値
' 戻り値：なし
Public Sub setCellValue(addr As String, value As String)
    Dim row As Long
    Dim column As Long

    On Error GoTo setCellValue_Err

    With m_thisWorksheet
        row = .Range(addr).row
        column = .Range(addr).column

        .cells(row, column).value = value
    End With

    Exit Sub

setCellValue_Err:
    ' 書き込めなくてもなにもしない

End Sub

' 機能：シートの保護/解除を設定する
' 引数：
'   protect : TRUE : 保護する、FALSE : 解除する
' 戻り値：なし
Public Sub setSheetProtect(protect As Boolean)

    With m_thisWorksheet
        If protect = True Then
            .protect AllowFormattingColumns:=True, Password:=SHEET_PROTECT_PASSWORD
        Else
            .Unprotect Password:=SHEET_PROTECT_PASSWORD
        End If
    End With
End Sub

