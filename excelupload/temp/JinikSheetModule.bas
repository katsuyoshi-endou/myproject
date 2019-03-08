Attribute VB_Name = "JinikSheetModule"
Option Explicit

' 「人材育成計画」シートのシート内の操作（入力イベントなど）に関する処理用のモジュール
' 「エラーチェック実施」ボタン押下時の処理は、ここには記載していません。
' 　（JinikCheckModuleからの処理を参照してください。）

Public Const COLOR_CELL_REQUIRED As Long = 13353215                         ' RGB(255,192,203) >> 255+192*256+203*256*256
Public Const COLOR_CELL_DISABLED As Long = 12632256                         ' RGB(224,224,224) >> 224+224*256+224*256*256
Public Const COLOR_CELL_OPTION As Long = 13434879                           ' RGB(255,255,204) >> 255+255*256+204*256*256

Public Const COLOR_CELL_CLEAR As Long = 0

' イベント処理が必要なセル定義
' それぞれの項目の列位置（番号）をカンマ区切りで（処理により、Split関数で配列に変換するため）
Public Const FIELD_IDO_COLUMN_POS As String = "39,50,61,72,83,94"           ' （担当業務計画）異動
Public Const FIELD_YOTEI_IDO_COLUMN_POS As String = "94"                    ' （担当業務計画）異動（予定のみ）
Public Const FIELD_TAISHOKU_COLUMN_POS As String = "40,51,62,73,84"         ' （担当業務計画）退職
Public Const FIELD_KYOTEN_COLUMN_POS As String = "45,56,67,78,89,98"        ' （異動計画）拠点（予定含む）
Public Const FIELD_YOUHI_COLUMN_POS As String = "48,59,70,81,92,101"        ' （異動計画）後任要否（予定含む）
Public Const FIELD_TANTO_GYOMU_COLUMN_POS As String = "41,52,63,74,85,95"   ' （担当業務計画）担当業務

Public Const START_COLUMN_KEIKAKU_AREA As Long = 39                         ' （担当業務・異動）計画入力エリアの開始列位置
Public Const END_COLUMN_KEIKAKU_AREA As Long = 102                          ' （担当業務・異動）計画入力エリアの終了列位置

Private Const JINIK_EDIT_START_CELL As String = "B17"                       ' 編集開始位置

Private Const JINIK_EDIT_END_COLUMN_POS As Long = 103                       ' 編集最終列位置


' 編集エリア内の罫線用定義（指定したセルの右に実線の罫線を引くための定義）
Private Const DEF_RIGHT_BORDER_CELLS As String = "2,3,19,20,23,31,33,35,37,38,41,49,52,60,63,71,74,82,85,93,95,102"


' 各項目の「異動」項目から見た相対位置（予定は除く）
Private Enum REL_POS
    JINIK_KAITO_IDO = 0                         ' （担当業務計画）「異動」
    JINIK_KAITO_TAISHOKU = 1                    ' （担当業務計画）「退職」
    JINIK_KAITO_TANTO_GYOMU = 2                 ' （担当業務計画）「担当業務」
    JINIK_KAITO_IDO_MONTH = 3                   ' （異動計画）「異動月」
    JINIK_KAITO_SHOKUMU = 4                     ' （異動計画）「職務」
    JINIK_KAITO_JIGYOJO = 5                     ' （異動計画）「事業場」
    JINIK_KAITO_KYOTEN = 6                      ' （異動計画）「拠点」
    JINIK_KAITO_IDOSAKI_KYOTEN = 7              ' （異動計画）「異動先拠点」
    JINIK_KAITO_IDOSAKI = 8                     ' （異動計画）「異動先の組織」
    JINIK_KAITO_KONIN_YOUHI = 9                 ' （異動計画）「後任要否」
    JINIK_KAITO_KONIN_YOUKEN = 10               ' （異動計画）「後任要件」
End Enum

' （予定の）各項目の「異動」項目から見た相対位置（「退職」と「異動月」なし）
Private Enum REL_YOTEI_POS
    JINIK_KAITO_IDO = 0                         ' （担当業務計画）「異動」
    JINIK_KAITO_TANTO_GYOMU = 1                 ' （担当業務計画）「担当業務」
    JINIK_KAITO_SHOKUMU = 2                     ' （異動計画）「職務」
    JINIK_KAITO_JIGYOJO = 3                     ' （異動計画）「事業場」
    JINIK_KAITO_KYOTEN = 4                      ' （異動計画）「拠点」
    JINIK_KAITO_IDOSAKI_KYOTEN = 5              ' （異動計画）「異動先拠点」
    JINIK_KAITO_IDOSAKI = 6                     ' （異動計画）「異動先の組織」
    JINIK_KAITO_KONIN_YOUHI = 7                 ' （異動計画）「後任要否」
    JINIK_KAITO_KONIN_YOUKEN = 8                ' （異動計画）「後任要件」
End Enum

Public Enum EDIT_TYPE
    CELL_CLEAR = 0                              ' クリア
    CELL_REQUIRED = 1                           ' 入力必須
    CELL_DISABLED = 2                           ' 使用不可
    CELL_OPTION = 3                             ' 任意入力
    CELL_ERROR = 9                              ' 入力エラー
End Enum

Private m_bJinikSheetEdited As Boolean          ' 「人材育成計画」シートが更新されているか（TRUE : 更新済み、FALSE : 未更新）
Private m_bErrChecked As Boolean                ' エラーチェックを実施済みか（TRUE : 実施、FALSE : 未実施）
                                                ' チェック実施後にシートの更新があれば、フラグはリセットする
Private m_bChkRsltSheetEdited As Boolean        ' 「チェック結果」シートが更新されているか（TRUE : 更新済み、FALSE : 未更新）

Public Sub setJinikSheetEdited(edit As Boolean)
    m_bJinikSheetEdited = edit
End Sub

Public Function isJinikSheetEdited() As Boolean
    isJinikSheetEdited = m_bJinikSheetEdited
End Function

Public Function setErrorChecked(chk As Boolean)
    m_bErrChecked = chk
End Function

Public Function isErrorChecked() As Boolean
    isErrorChecked = m_bErrChecked
End Function

Public Function setChkRsltSheetEdited(edit As Boolean)
    m_bChkRsltSheetEdited = edit
End Function

Public Function isChkRsltSheetEdited() As Boolean
    isChkRsltSheetEdited = m_bChkRsltSheetEdited
End Function

' 機能：指定されたセルの書式（ロック・背景色）を設定する
'       ※本処理を呼び出すときは、シートの保護が解除されていること
' 引数：
'   row      : 行
'   column   : 列
'   editType : EDIT_TYPE（編集種別）
' 戻り値：なし
Private Sub setCellProperty(row As Long, column As Long, editType As EDIT_TYPE)
    With Worksheets(MAIN_SHEET_NAME)
        Select Case editType
            Case EDIT_TYPE.CELL_CLEAR
                .cells(row, column).Locked = False
                .cells(row, column).Interior.ColorIndex = COLOR_CELL_CLEAR
            Case EDIT_TYPE.CELL_REQUIRED
                .cells(row, column).Locked = False

                If .cells(row, column).value = "" Then
                    .cells(row, column).Interior.Color = COLOR_CELL_REQUIRED
                Else
                    .cells(row, column).Interior.ColorIndex = COLOR_CELL_CLEAR
                End If
            Case EDIT_TYPE.CELL_DISABLED
                .cells(row, column).Locked = True
                .cells(row, column).Interior.Color = COLOR_CELL_DISABLED
            Case EDIT_TYPE.CELL_OPTION
                .cells(row, column).Locked = False
                If .cells(row, column).value = "" Then
                    .cells(row, column).Interior.Color = COLOR_CELL_OPTION
                Else
                    .cells(row, column).Interior.ColorIndex = COLOR_CELL_CLEAR
                End If
        End Select
    End With
End Sub


' 機能：（担当業務計画）「異動」（予定以外）が変更されたときの処理
' 引数：
'   row    : 行
'   column : 列
' 戻り値：なし
Public Sub execIdoChangeEvent(row As Long, column As Long)
    Dim value As String

    On Error GoTo execIdoChangeEvent_Err

    ' （予定）「異動」のときは、別途処理する（項目の内容に違いがあり表示がずれるため）
    If FIELD_YOTEI_IDO_COLUMN_POS = column Then
        Call execIdoYoteiChangeEvent(row, column)

        Exit Sub
    End If

    With Worksheets(MAIN_SHEET_NAME)
        value = .cells(row, column).value

        If value = "○" Then
            ' 各項目に対していろいろする
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDO, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_TAISHOKU, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_TANTO_GYOMU, EDIT_TYPE.CELL_OPTION)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDO_MONTH, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_SHOKUMU, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_JIGYOJO, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_KYOTEN, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDOSAKI_KYOTEN, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDOSAKI, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_KONIN_YOUHI, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_KONIN_YOUKEN, EDIT_TYPE.CELL_DISABLED)

            ' 「拠点」の変更イベントが発生したかのように処理する
            Call execKyotenChangeEvent(row, column + REL_POS.JINIK_KAITO_KYOTEN)

            ' 「後任要否」の変更イベントが発生したかのように処理する
            Call execKouninYouhiChangeEvent(row, column + REL_POS.JINIK_KAITO_KONIN_YOUHI)
        Else
            ' 各項目に対していろいろする
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDO, EDIT_TYPE.CELL_OPTION)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_TAISHOKU, EDIT_TYPE.CELL_OPTION)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_TANTO_GYOMU, EDIT_TYPE.CELL_OPTION)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDO_MONTH, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_SHOKUMU, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_JIGYOJO, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_KYOTEN, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDOSAKI_KYOTEN, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDOSAKI, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_KONIN_YOUHI, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_KONIN_YOUKEN, EDIT_TYPE.CELL_DISABLED)
        End If
    End With

    Exit Sub

execIdoChangeEvent_Err:
    err.Raise err.Number, "execIdoChangeEvent", err.Description

End Sub

' 機能：（担当業務計画）「異動」（予定）が変更されたときの処理
' 引数：
'   row    : 行
'   column : 列
' 戻り値：なし
Public Sub execIdoYoteiChangeEvent(row As Long, column As Long)
    Dim value As String

    On Error GoTo execIdoChangeEvent_Err

    With Worksheets(MAIN_SHEET_NAME)
        value = .cells(row, column).value

        If value = "○" Then
            ' 各項目に対していろいろする
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_IDO, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_TANTO_GYOMU, EDIT_TYPE.CELL_OPTION)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_SHOKUMU, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_JIGYOJO, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_KYOTEN, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_IDOSAKI_KYOTEN, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_IDOSAKI, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_KONIN_YOUHI, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_KONIN_YOUKEN, EDIT_TYPE.CELL_DISABLED)

            ' 「拠点」の変更イベントが発生したかのように処理する
            Call execKyotenChangeEvent(row, column + REL_YOTEI_POS.JINIK_KAITO_KYOTEN)

            ' 「後任要否」の変更イベントが発生したかのように処理する
            Call execKouninYouhiChangeEvent(row, column + REL_YOTEI_POS.JINIK_KAITO_KONIN_YOUHI)
        Else
            ' 各項目に対していろいろする
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_IDO, EDIT_TYPE.CELL_OPTION)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_TANTO_GYOMU, EDIT_TYPE.CELL_OPTION)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_SHOKUMU, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_JIGYOJO, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_KYOTEN, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_IDOSAKI_KYOTEN, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_IDOSAKI, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_KONIN_YOUHI, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_KONIN_YOUKEN, EDIT_TYPE.CELL_DISABLED)
        End If
    End With

    Exit Sub

execIdoChangeEvent_Err:
    err.Raise err.Number, "execIdoChangeEvent", err.Description

End Sub

' 機能：（担当業務計画）「退職」が変更されたときの処理
' 引数：
'   row    : 行
'   column : 列
' 戻り値：なし
Public Sub execTaishokuChangeEvent(row As Long, column As Long)
    Dim value As String

    With Worksheets(MAIN_SHEET_NAME)
        value = .cells(row, column).value

        If value = "○" Then
            ' 列位置の相対指定は、「異動」を基準としているため、「退職」の選択時は-1する
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDO - 1, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_TAISHOKU - 1, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_TANTO_GYOMU - 1, EDIT_TYPE.CELL_OPTION)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDO_MONTH - 1, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_SHOKUMU - 1, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_JIGYOJO - 1, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_KYOTEN - 1, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDOSAKI_KYOTEN - 1, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDOSAKI - 1, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_KONIN_YOUHI - 1, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_KONIN_YOUKEN - 1, EDIT_TYPE.CELL_DISABLED)

            Call setAllFieldsPropertyByTaishoku(row, column, True)
        Else
            ' いったん書式をクリアしたあと、「異動」、「拠点」、「後任要否」の変更イベント呼び出し
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDO - 1, EDIT_TYPE.CELL_OPTION)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_TAISHOKU - 1, EDIT_TYPE.CELL_OPTION)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_TANTO_GYOMU - 1, EDIT_TYPE.CELL_OPTION)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDO_MONTH - 1, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_SHOKUMU - 1, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_JIGYOJO - 1, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_KYOTEN - 1, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDOSAKI_KYOTEN - 1, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_IDOSAKI - 1, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_KONIN_YOUHI - 1, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + REL_POS.JINIK_KAITO_KONIN_YOUKEN - 1, EDIT_TYPE.CELL_CLEAR)

            Call execIdoChangeEvent(row, column + REL_POS.JINIK_KAITO_IDO - 1)

            Call setAllFieldsPropertyByTaishoku(row, column, False)
        End If

        ' 退職予定者フラグの更新
        Call setTaishokuYoteiFlag(row, column)
    End With
End Sub

' 機能：（担当業務計画）「退職」が変更されたときの当該年度以降の処理
' 引数：
'   row     : 行
'   column  : 列
'   retired : 「退職」チェック状態（TRUE : 「退職」が選択された、FALSE : 「退職」の選択が外された）
' 戻り値：なし
Private Sub setAllFieldsPropertyByTaishoku(row As Long, column As Long, retired As Boolean)
    Dim i As Long
    Dim idx As Long
    Dim cols() As String
    Dim bMitei As Boolean: bMitei = False

    On Error GoTo setAllFieldsPropertyByTaishoku_Err

    ' 「退職」の列位置を文字列から配列に変換
    cols = Split(FIELD_TAISHOKU_COLUMN_POS, ",")

    ' どの年度よりあとを入力不可とするか
    For i = 0 To UBound(cols, 1)
        If CLng(cols(i)) > column Then
            idx = CLng(cols(i))
            Exit For
        End If
    Next i

    ' 未定のひとつ前の年度に退職が設定された場合
    If idx = 0 And column = JINIK_KAITO_TAISHOKU_05_CLMN_POS Then
        ' 未定の場合、「異動」欄の右隣を退職欄とみなして処理する
        idx = JINIK_KAITO_IDO_06_CLMN_POS + 1
        bMitei = True
    End If

    With Worksheets(MAIN_SHEET_NAME)
        If retired = True Then
            .Range(.cells(row, idx - 1), .cells(row, END_COLUMN_KEIKAKU_AREA)).Locked = True
            .Range(.cells(row, idx - 1), .cells(row, END_COLUMN_KEIKAKU_AREA)).Interior.Color = COLOR_CELL_DISABLED
        Else
            .Range(.cells(row, idx - 1), .cells(row, END_COLUMN_KEIKAKU_AREA)).Locked = False
            .Range(.cells(row, idx - 1), .cells(row, END_COLUMN_KEIKAKU_AREA)).Interior.ColorIndex = COLOR_CELL_CLEAR

            For i = 0 To UBound(cols, 1)
                If CLng(cols(i)) > column Then
                    Call execIdoChangeEvent(row, CLng(cols(i)) - 1)
                End If
            Next i

            If bMitei = True Then
                Call execIdoYoteiChangeEvent(row, JINIK_KAITO_IDO_06_CLMN_POS)
            End If
        End If
    End With

    Exit Sub

setAllFieldsPropertyByTaishoku_Err:
    err.Raise err.Number, "setAllFieldsPropertyByTaishoku", err.Description

End Sub


' 機能：（異動計画）「拠点」が変更されたときの処理
' 引数：
'   row     : 行
'   column  : 列
' 戻り値：なし
Public Sub execKyotenChangeEvent(row As Long, column As Long)
    Dim kyoten As String

    On Error GoTo execKyotenChangeEvent_Err

    With Worksheets(MAIN_SHEET_NAME)
        kyoten = .cells(row, column).value
        If kyoten = "" Then
            ' 「拠点」が空欄のとき、「拠点」は必須入力指定、ひとつ右隣の「異動先拠点」は使用不可にする
            Call setCellProperty(row, column, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_DISABLED)
        ElseIf kyoten = "変更なし" Then
            ' 「拠点」が"変更なし"のとき、「拠点」は書式クリア、ひとつ右隣の「異動先拠点」は使用不可にする
            Call setCellProperty(row, column, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_DISABLED)
        Else
            Call setCellProperty(row, column, EDIT_TYPE.CELL_CLEAR)

            If .cells(row, column + 1).value = "" Then
                ' 「異動先拠点」が未入力なら必須入力指定
                Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_REQUIRED)
            Else
                ' 「異動先拠点」が入力済みなら書式クリア
                Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_CLEAR)
            End If
        End If
    End With

    Exit Sub

execKyotenChangeEvent_Err:
    err.Raise err.Number, "execKyotenChangeEvent", err.Description

End Sub

' 機能：（異動計画）「後任要否」が変更されたときの処理
' 引数：
'   row     : 行
'   column  : 列
' 戻り値：なし
Public Sub execKouninYouhiChangeEvent(row As Long, column As Long)
    Dim value As String

    On Error GoTo execKouninYouhiChangeEvent_Err

    With Worksheets(MAIN_SHEET_NAME)
        value = .cells(row, column).value
        If value = "" Then
            ' 「後任要否」が空欄のとき、「後任要否」は必須入力指定、ひとつ右隣の「後任要件」は使用不可
            Call setCellProperty(row, column, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_DISABLED)
        ElseIf value = "要" Then
            ' 「後任要否」が"要"のとき、「後任要否」は書式クリア、ひとつ右隣の「後任要件」は入力状況に応じて使用可/不可
            Call setCellProperty(row, column, EDIT_TYPE.CELL_REQUIRED)

            If .cells(row, column + 1).value = "" Then
                Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_REQUIRED)
            Else
                Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_CLEAR)
            End If
        ElseIf value = "不要" Then
            ' 「後任要否」が"不要"のとき、「後任要否」は書式クリア、ひとつ右隣の「後任要件」は使用不可
            Call setCellProperty(row, column, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_DISABLED)
        End If
    End With

    Exit Sub

execKouninYouhiChangeEvent_Err:
    err.Raise err.Number, "execKouninYouhiChangeEvent", err.Description

End Sub

' 機能：（担当業務・異動）計画入力エリアが変更されたときの処理
'       ※「異動」、「退職」、「拠点」、「後任要否」の変更イベントは別途実施済み
'       「担当業務」欄は、処理対象外（変更に伴う使用可/不可の制御を行わないため）
' 引数：
'   row     : 行
'   column  : 列
' 戻り値：なし
Public Sub execKeikakuAreaChangeEvent(row As Long, column As Long)
    Dim value As String
    Dim bgColor As Long

    With Worksheets(MAIN_SHEET_NAME)
        value = .cells(row, column).value
        bgColor = .cells(row, column).Interior.Color

        If value <> "" And (bgColor = COLOR_CELL_REQUIRED Or bgColor = COLOR_CELL_OPTION) Then
            Call setCellProperty(row, column, EDIT_TYPE.CELL_CLEAR)
        ElseIf value = "" Then
            If InStr(FIELD_TANTO_GYOMU_COLUMN_POS, column) > 0 Then
                Call setCellProperty(row, column, EDIT_TYPE.CELL_OPTION)
            Else
                Call setCellProperty(row, column, EDIT_TYPE.CELL_REQUIRED)
            End If
        End If
    End With
End Sub

' 機能：「人材育成計画」シートの初期化処理
'       ・バイヤー認定計画欄の活性/非活性（社員属性のバイヤー認定級が"1級"のとき、非活性）
'       ・登用計画欄の活性/非活性（社員属性の等級群が"経営職"のとき、非活性）
'   ・入力イベント時と同じ内容の活性/非活性化処理
' 引数：なし
' 戻り値：なし
Public Sub initialJinikSheetActivation()
    Dim i As Long
    Dim row As Long
    Dim status As String
    Dim col As Variant
    Dim cols() As String

    On Error GoTo initialJinikSheetActivation_Err

    Application.Cursor = xlWait

    Application.ScreenUpdating = False

    With Worksheets(MAIN_SHEET_NAME)
        .Unprotect Password:=SHEET_PROTECT_PASSWORD

        ' 「ステータス」欄に記載のある行を対象に
        i = 0
        Do Until .Range(JINIK_EDIT_START_CELL).Offset(i, 0).value = ""
            row = .Range(JINIK_EDIT_START_CELL).Offset(i, 0).row

            ' 「ステータス」欄から「異動計画（直近）後任要件」までを使用不可
            Call setDisabledCellRanges(row, STATUS_NM_CLMN_POS, JINIK_KAITO_KONIN_YOUKEN_CHOKKIN_CLMN_POS)

            status = .Range(JINIK_EDIT_START_CELL).Offset(i, 0).value
            If status = "計画入力中" Then
                cols = Split(FIELD_IDO_COLUMN_POS, ",")
                For Each col In cols
                    If .cells(row, CLng(col) + 1).value = "○" Then
                        ' 「退職」に"○"がついている場合
                        Call execTaishokuChangeEvent(row, CLng(col) + 1)

                        Exit For
                    Else
                        Call execIdoChangeEvent(row, CLng(col))
                    End If
                Next

                ' 現在の担当業務の活性・非活性
                Call setFieldAvailable(row, JINIK_KAITO_GENZAI_TANTO_GYOMU_CLMN_POS, EDIT_TYPE.CELL_REQUIRED)

                ' バイヤー認定欄の活性・非活性
                Call setBuyerFieldsAvailable(row)

                ' 登用計画欄の活性・非活性
                Call setTouyoKeikakuAvailable(row)

                ' 備考欄の活性・非活性
                Call setFieldAvailable(row, JINIK_KAITO_OTHER_CLMN_POS, EDIT_TYPE.CELL_OPTION)
                
                ' 「異動実績」欄を使用不可
                Call setDisabledCellRanges(row, JINIK_KAITO_IDO_MONTH_CLMN_POS, JINIK_KAITO_IDO_PLACE_CLMN_POS)

            ElseIf status = "進捗状況確認中" Then
                ' 異動実績欄の活性・非活性
                Call setIdoJissekiAavailable(row)

                ' 「バイヤー認定計画」欄から「備考」までを使用不可
                Call setDisabledCellRanges(row, JINIK_KAITO_BUYER_JIKI_CLMN_POS, JINIK_KAITO_OTHER_CLMN_POS)
            ElseIf status = "計画確認中" Or status = "異動なし" Or status = "異動済" Or status = "対象外" Then
                ' 上記ステータス以外は、すべて使用不可
                Call setDisabledCellRanges(row, STATUS_NM_CLMN_POS, JINIK_KAITO_OTHER_CLMN_POS)
            Else
                ' 何もしない
            End If

            i = i + 1
        Loop

        If row > 0 Then
            Call drawJinikSheetLines(row)
        End If

        .protect AllowFormattingColumns:=True, Password:=SHEET_PROTECT_PASSWORD
    End With

    Application.ScreenUpdating = True

    Application.Cursor = xlDefault

    Exit Sub

initialJinikSheetActivation_Err:
    Application.ScreenUpdating = True

    Application.Cursor = xlDefault

    err.Raise err.Number, "initialJinikSheetActivation", err.Description

End Sub

' 機能：バイヤー認定欄の使用可否を設定する
'       ※シートステータスも見るときは、この関数の呼び出し前で判定しておくこと
' 引数：
'   row     : 行
' 戻り値：なし
Public Sub setBuyerFieldsAvailable(row As Long)
    Dim infoBuyer As String
    Dim kaitoJiki As String
    Dim kaitoNinteikyu As String

    On Error GoTo setBuyerFieldsAvailable_Err

    ' 社員属性のバイヤー認定情報を取得する
    With Worksheets(MAIN_SHEET_NAME)
        infoBuyer = .cells(row, JINIK_INFO_BUYER_CLMN_POS).value

        If infoBuyer = "1級" Then
            Call setCellProperty(row, JINIK_KAITO_BUYER_JIKI_CLMN_POS, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS, EDIT_TYPE.CELL_DISABLED)
        Else
            kaitoJiki = .cells(row, JINIK_KAITO_BUYER_JIKI_CLMN_POS).value
            kaitoNinteikyu = .cells(row, JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS).value
            If .cells(row, JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS).Interior.Color = COLOR_CELL_DISABLED Then
                kaitoNinteikyu = ""
            End If

            If kaitoJiki = "" And kaitoNinteikyu = "" Then
                ' （シート回答）バイヤー認定がともに未入力なら任意入力状態に
                Call setCellProperty(row, JINIK_KAITO_BUYER_JIKI_CLMN_POS, EDIT_TYPE.CELL_OPTION)
                Call setCellProperty(row, JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS, EDIT_TYPE.CELL_DISABLED)
            ElseIf kaitoJiki <> "" And kaitoNinteikyu = "" Then
                ' （シート回答）バイヤー認定年度が入力済み、認定級が未入力のとき、認定級を必須入力状態に
                Call setCellProperty(row, JINIK_KAITO_BUYER_JIKI_CLMN_POS, EDIT_TYPE.CELL_CLEAR)
                Call setCellProperty(row, JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS, EDIT_TYPE.CELL_REQUIRED)
            ElseIf kaitoJiki = "" Then
                Call setCellProperty(row, JINIK_KAITO_BUYER_JIKI_CLMN_POS, EDIT_TYPE.CELL_OPTION)
                Call setCellProperty(row, JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS, EDIT_TYPE.CELL_DISABLED)
            Else
                Call setCellProperty(row, JINIK_KAITO_BUYER_JIKI_CLMN_POS, EDIT_TYPE.CELL_CLEAR)
                Call setCellProperty(row, JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS, EDIT_TYPE.CELL_CLEAR)
            End If
        End If
    End With

    Exit Sub

setBuyerFieldsAvailable_Err:
    err.Raise err.Number, "setBuyerFieldsAvailable", err.Description

End Sub

' 機能：登用計画欄の使用可否を設定する
'       ※シートステータスも見るときは、この関数の呼び出し前で判定しておくこと
' 引数：
'   row     : 行
' 戻り値：なし
Public Sub setTouyoKeikakuAvailable(row As Long)
    Dim infoTouyoKeikaku As String
    Dim touyoJiki As String
    Dim toukyuGun As String

    On Error GoTo setTouyoKeikakuAvailable_Err

    With Worksheets(MAIN_SHEET_NAME)
        infoTouyoKeikaku = .cells(row, JINIK_INFO_TOUYO_KEIKAKU_CLMN_POS).value

        If infoTouyoKeikaku = "経営職" Then
            Call setCellProperty(row, JINIK_KAITO_TOUYO_JIKI_CLMN_POS, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, JINIK_KAITO_TOUYO_KEIKAKU_CLMN_POS, EDIT_TYPE.CELL_DISABLED)
        Else
            touyoJiki = .cells(row, JINIK_KAITO_TOUYO_JIKI_CLMN_POS).value
            toukyuGun = .cells(row, JINIK_KAITO_TOUYO_KEIKAKU_CLMN_POS).value
            If .cells(row, JINIK_KAITO_TOUYO_KEIKAKU_CLMN_POS).Interior.Color = COLOR_CELL_DISABLED Then
                toukyuGun = ""
            End If

            If touyoJiki = "" And toukyuGun = "" Then
                Call setCellProperty(row, JINIK_KAITO_TOUYO_JIKI_CLMN_POS, EDIT_TYPE.CELL_OPTION)
                Call setCellProperty(row, JINIK_KAITO_TOUYO_KEIKAKU_CLMN_POS, EDIT_TYPE.CELL_DISABLED)
            ElseIf touyoJiki <> "" And toukyuGun = "" Then
                Call setCellProperty(row, JINIK_KAITO_TOUYO_JIKI_CLMN_POS, EDIT_TYPE.CELL_CLEAR)
                Call setCellProperty(row, JINIK_KAITO_TOUYO_KEIKAKU_CLMN_POS, EDIT_TYPE.CELL_REQUIRED)
            ElseIf touyoJiki = "" Then
                Call setCellProperty(row, JINIK_KAITO_TOUYO_JIKI_CLMN_POS, EDIT_TYPE.CELL_OPTION)
                Call setCellProperty(row, JINIK_KAITO_TOUYO_KEIKAKU_CLMN_POS, EDIT_TYPE.CELL_DISABLED)
            Else
                Call setCellProperty(row, JINIK_KAITO_TOUYO_JIKI_CLMN_POS, EDIT_TYPE.CELL_CLEAR)
                Call setCellProperty(row, JINIK_KAITO_TOUYO_KEIKAKU_CLMN_POS, EDIT_TYPE.CELL_CLEAR)
            End If
        End If
    End With

    Exit Sub

setTouyoKeikakuAvailable_Err:
    err.Raise err.Number, "setTouyoKeikakuAvailable", err.Description

End Sub

' 機能：異動実績欄の使用可否を設定する
'       ※シートステータスも見るときは、この関数の呼び出し前で判定しておくこと
' 引数：
'   row     : 行
' 戻り値：なし
Public Sub setIdoJissekiAavailable(row As Long)
    Dim idoMonth As String
    Dim idosaki As String

    On Error GoTo setIdoJissekiAavailable_Err

    With Worksheets(MAIN_SHEET_NAME)
        idoMonth = .cells(row, JINIK_KAITO_IDO_MONTH_CLMN_POS).value
        idosaki = .cells(row, JINIK_KAITO_IDO_PLACE_CLMN_POS).value

        If idoMonth = "" And idosaki = "" Then
            Call setCellProperty(row, JINIK_KAITO_IDO_MONTH_CLMN_POS, EDIT_TYPE.CELL_OPTION)
            Call setCellProperty(row, JINIK_KAITO_IDO_PLACE_CLMN_POS, EDIT_TYPE.CELL_DISABLED)
        ElseIf idoMonth <> "" And idosaki = "" Then
            Call setCellProperty(row, JINIK_KAITO_IDO_MONTH_CLMN_POS, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, JINIK_KAITO_IDO_PLACE_CLMN_POS, EDIT_TYPE.CELL_REQUIRED)
        ElseIf idoMonth = "" Then
            Call setCellProperty(row, JINIK_KAITO_IDO_MONTH_CLMN_POS, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, JINIK_KAITO_IDO_PLACE_CLMN_POS, EDIT_TYPE.CELL_DISABLED)
        Else
            Call setCellProperty(row, JINIK_KAITO_IDO_MONTH_CLMN_POS, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, JINIK_KAITO_IDO_PLACE_CLMN_POS, EDIT_TYPE.CELL_CLEAR)
        End If
    End With

    Exit Sub

setIdoJissekiAavailable_Err:
    err.Raise err.Number, "setIdoJissekiAavailable", err.Description

End Sub

' 機能：引数に指定された位置の項目の入力状態を設定する
'       ※当該項目に入力されているかいないかでのみ判定、他項目は参照しない
' 引数：
'   row      : 行
'   column   : 列
'   editType : EDIT_TYPE（編集種別）
' 戻り値：なし
Public Sub setFieldAvailable(row As Long, column As Long, editType As Long)
    Dim value As String

    With Worksheets(MAIN_SHEET_NAME)
        value = .cells(row, column).value

        If value = "" Then
            Call setCellProperty(row, column, editType)
        Else
            Call setCellProperty(row, column, EDIT_TYPE.CELL_CLEAR)
        End If
    End With
End Sub

' 機能：アップロード可否の文字列をセットする
' 引数：
'   title    : タイトル（"アップロード可" or "アップロード不可"）
'   subtitle : サブタイトル
' 戻り値：なし
Public Sub setUploadStatusString(title As String, subtitle As String, result As CHECK_RESULT)

    Dim bgClrIndex As Variant

    With Worksheets(MAIN_SHEET_NAME)
        .Unprotect Password:=SHEET_PROTECT_PASSWORD

        Application.EnableEvents = False

        .Range(ADDR_UPLOAD_STATUS_TITLE).value = title
        .Range(ADDR_UPLOAD_STATUS_SUB_TITLE).value = subtitle

        If result = CHECK_RESULT.CHK_ERROR Then
            bgClrIndex = CELL_BKCOLOR_ERROR
        Else
            bgClrIndex = CELL_BKCOLOR_NO_ERROR
        End If

        .Range(ADDR_UPLOAD_STATUS_TITLE).Interior.ColorIndex = bgClrIndex
        .Range(ADDR_UPLOAD_STATUS_SUB_TITLE).Interior.ColorIndex = bgClrIndex

        Application.EnableEvents = True

        .protect AllowFormattingColumns:=True, Password:=SHEET_PROTECT_PASSWORD
    End With
End Sub

' 機能：人材育成計画シート回答欄の使用不可となっているセルの値をクリア（破棄）する
'       ※本処理内では、シートの保護の解除とChangeイベントなどのイベントが発生しないようにしています。
'         呼び出し時には注意してください。
' 引数：なし
' 戻り値：なし
Public Sub clearDataDisabledFields()
    Dim row As Long
    Dim column As Long
    Dim statusName As String

    On Error GoTo clearDataDisabledFields_Err

    With Worksheets(MAIN_SHEET_NAME)
        .Unprotect Password:=SHEET_PROTECT_PASSWORD

        ' 値を破棄するとき、Worksheet_changeイベントが発生しないように
        Application.EnableEvents = False

        row = .Range(ADDR_FIRST_JINIK_DATA).row

        Do Until .cells(row, STATUS_NM_CLMN_POS).value = ""
            statusName = .cells(row, STATUS_NM_CLMN_POS).value

            If statusName = "計画入力中" Then
                ' ステータスが、"計画入力中"のときは、（異動実績）「異動月」からクリアする
                For column = JINIK_KAITO_IDO_MONTH_CLMN_POS To JINIK_KAITO_OTHER_CLMN_POS
                    If .cells(row, column).Interior.Color = COLOR_CELL_DISABLED And .cells(row, column).value <> "" Then
                        ' 値のみクリア（書式等はそのまま）
                        .cells(row, column).ClearContents
                    End If
                Next column
            ElseIf statusName = "進捗状況確認中" Then
                ' ステータスが、"進捗状況確認中"のときは、（異動実績）「異動月」欄のみクリアする
                For column = JINIK_KAITO_IDO_MONTH_CLMN_POS To JINIK_KAITO_IDO_PLACE_CLMN_POS
                    If .cells(row, column).Interior.Color = COLOR_CELL_DISABLED And .cells(row, column).value <> "" Then
                        ' 値のみクリア（書式等はそのまま）
                        .cells(row, column).ClearContents
                    End If
                Next column
            Else
                ' 上記以外はなにもしない（そのまま）
            End If

            row = row + 1
        Loop

        Application.EnableEvents = True

        .protect AllowFormattingColumns:=True, Password:=SHEET_PROTECT_PASSWORD
    End With

    Exit Sub

clearDataDisabledFields_Err:
    err.Raise err.Number, "clearDataDisabledFields", err.Description

End Sub

' 機能：編集エリア内に罫線を引く
' 引数：
'   lastRow : 最終行位置
' 戻り値：なし
Private Sub drawJinikSheetLines(lastRow As Long)
    Dim i As Long
    Dim editStartRow As Long
    Dim borderCells As Variant

    On Error GoTo drawJinikSheetLines_Err

    With Worksheets(MAIN_SHEET_NAME)
        .Range(.Range(JINIK_EDIT_START_CELL), .cells(lastRow, JINIK_EDIT_END_COLUMN_POS)).Borders(xlDiagonalDown).LineStyle = xlNone
        .Range(.Range(JINIK_EDIT_START_CELL), .cells(lastRow, JINIK_EDIT_END_COLUMN_POS)).Borders(xlDiagonalUp).LineStyle = xlNone

        ' 罫線を引く（外罫線）
        With .Range(.Range(JINIK_EDIT_START_CELL), .cells(lastRow, JINIK_EDIT_END_COLUMN_POS)).Borders
            .LineStyle = xlContinuous
            .Color = RGB(0, 0, 0)
            .TintAndShade = 0
            .Weight = xlThin
        End With

        ' 罫線を引く（内側の縦罫線）
        With .Range(.Range(JINIK_EDIT_START_CELL), .cells(lastRow, JINIK_EDIT_END_COLUMN_POS)).Borders(xlInsideVertical)
            .LineStyle = xlContinuous
            .Color = RGB(0, 0, 0)
            .TintAndShade = -0.14996795556505
            .Weight = xlHairline
        End With

        borderCells = Split(DEF_RIGHT_BORDER_CELLS, ",")

        ' 指定したセルの右側に罫線（実線）を引く
        editStartRow = .Range(JINIK_EDIT_START_CELL).row
        For i = 0 To UBound(borderCells, 1)
            With .Range(.cells(editStartRow, CLng(borderCells(i))), .cells(lastRow, CLng(borderCells(i)))).Borders(xlEdgeRight)
                .LineStyle = xlContinuous
                .Color = RGB(0, 0, 0)
                .TintAndShade = 0
                .Weight = xlThin
            End With
        Next i

        ' 指定した範囲内の水平罫線（点線）を引く
        With .Range(.Range(JINIK_EDIT_START_CELL), .cells(lastRow, JINIK_EDIT_END_COLUMN_POS)).Borders(xlInsideHorizontal)
            .LineStyle = xlContinuous
            .Color = RGB(0, 0, 0)
            .TintAndShade = -0.14996795556505
            .Weight = xlHairline
        End With
    End With

    Exit Sub

drawJinikSheetLines_Err:
    err.Raise err.Number, "drawJinikSheetLines", err.Description

End Sub

' 機能：当年度および次年度の「退職」項目が操作されたとき、「退職予定者フラグ」の更新を行う
' 引数：
'   row    : 行位置
'   column : 列位置
' 戻り値：なし
Private Sub setTaishokuYoteiFlag(row As Long, column As Long)
    Dim curNendoTaishoku As String
    Dim nextNendoTaishoku As String

    ' 当年度と次年度の「退職」セルに対する操作のとき
    If column = JINIK_KAITO_TAISHOKU_01_CLMN_POS Or column = JINIK_KAITO_TAISHOKU_02_CLMN_POS Then
        With Worksheets(MAIN_SHEET_NAME)
            curNendoTaishoku = .cells(row, JINIK_KAITO_TAISHOKU_01_CLMN_POS).value
            nextNendoTaishoku = .cells(row, JINIK_KAITO_TAISHOKU_02_CLMN_POS).value

            If curNendoTaishoku = "○" Or nextNendoTaishoku = "○" Then
                .cells(row, JINIK_ICHIRAN_TAISHOKU_YOTEI_FLG_POS) = "1"
            Else
                .cells(row, JINIK_ICHIRAN_TAISHOKU_YOTEI_FLG_POS) = "0"
            End If
        End With
    End If
End Sub

' 機能：とある行の指定範囲を使用不可に設定する
' 引数：
'   row        : 行位置
'   fromColumn : 開始列位置
'   toColumn   : 終了列位置
' 戻り値：なし
Private Sub setDisabledCellRanges(row As Long, fromColumn As Long, toColumn As Long)

    On Error GoTo setDisabledCellRanges_Err

    With Worksheets(MAIN_SHEET_NAME)
        .Range(.cells(row, fromColumn), .cells(row, toColumn)).Locked = True
        .Range(.cells(row, fromColumn), .cells(row, toColumn)).Interior.Color = COLOR_CELL_DISABLED
    End With

    Exit Sub

setDisabledCellRanges_Err:
    err.Raise err.Number, "setDisabledCellRanges", err.Description

End Sub



