VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SheetControl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' コントーロールクラスのようなもの
' 「人材育成計画」シートのビュー定義を格納しておき、処理の制御を行う

Private m_WarnSheetView As WarnSheetView
Private m_JinikSheetView As JinikSheetView
Private m_CheckResultView As CheckResultView
Private m_MasterSheetView As MasterSheetView


' コンストラクタ
Private Sub Class_Initialize()
End Sub

' デストラクタ
Private Sub Class_Terminate()
End Sub

Public Property Let WarnSheetView(view As WarnSheetView)
    Set m_WarnSheetView = view
End Property

Public Property Let JinikSheetView(view As JinikSheetView)
    Set m_JinikSheetView = view
End Property

Public Property Let CheckResultView(view As CheckResultView)
    Set m_CheckResultView = view
End Property

Public Property Let MasterSheetView(view As MasterSheetView)
    Set m_MasterSheetView = view
End Property

' 機能：人材育成計画シートのチェックを行う
'       ※本処理は、「エラーチェック実施」ボタン押下からのJinikCheckModule経由で呼び出されます
' 引数：なし
' 戻り値：エラーチェック結果
'           0 : エラーなし終了
'           1 : 警告あり終了（エラーはなし）
'          -1 : エラーあり終了
Public Function executeSheetCheck() As Long
    Dim ret  As Long: ret = 0

    Dim properties As Dictionary
    Dim jinikData As Dictionary
    Dim checkResults As CheckResultInfo
    
    On Error GoTo executeSheetCheck_Err

    ' 人材育成計画シートの項目定義を取得
    Set properties = getSheetFieldProperties()
    
    ' 項目定義に従って各項目の情報を取得
    Set jinikData = m_JinikSheetView.getSheetContentsFromMapping(properties)

    ' データのチェックを実施
    Set checkResults = checkSheetContents(jinikData, properties)
    If checkResults.getCheckErrorCount() = 0 And checkResults.getCheckWarningCount() = 0 Then
        ret = 0
    ElseIf checkResults.getCheckErrorCount() = 0 And checkResults.getCheckWarningCount() > 0 Then
        ret = 1
    ElseIf checkResults.getCheckErrorCount() > 0 Then
        ret = -1
    End If

    ' チェック結果を「チェック結果」シートに出力
    Call m_CheckResultView.outputCheckResult(checkResults)

    ' 不要リソースの解放
    properties.RemoveAll
    
    Set properties = Nothing

    Set checkResults = Nothing

    jinikData.RemoveAll

    Set jinikData = Nothing

    executeSheetCheck = ret

    Exit Function

executeSheetCheck_Err:
    If properties Is Nothing Then
        properties.RemoveAll
        Set properties = Nothing
    End If

    If checkResults Is Nothing Then
        Set checkResults = Nothing
    End If

    If jinikData Is Nothing Then
        jinikData.RemoveAll
        Set jinikData = Nothing
    End If

    err.Raise err.Number, "executeSheetCheck", err.Description

End Function

' 機能：人材育成計画シート回答情報を項目のプロパティ情報に従ってチェックを行う（実際に処理を行っているのはこちら）
' 引数：
'   jinikSheetData : 人材育成計画シート回答情報
'   properties     : 項目のプロパティ情報
' 戻り値：チェック結果
Private Function checkSheetContents(jinikSheetData As Dictionary, properties As Dictionary) As CheckResultInfo
    Dim key As Variant
    Dim fillId As String
    Dim id As Variant
    Dim data As Variant
    Dim dto As JinikSheetInfoDto
    Dim propDto As FieldProperty
    Dim chkResults As CheckResultInfo

    On Error GoTo checkSheetContents_Err

    Set chkResults = New CheckResultInfo

    ' Dictionary型の取り出しは、格納した順序
    For Each key In jinikSheetData
        Set dto = jinikSheetData.item(key)

        For Each id In dto.getFillData
            data = dto.getFillData.item(id)

            Set propDto = properties.item(id)

            If propDto.isCheck = True Then
                If propDto.CHECK_STATUS = dto.statusName Then
                    ' 必須チェック
                    If propDto.REQUIRED_CHECK = True Then
                        If data(2) = "" Then
                            Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.MISSING_CHECK)
                        End If
                    End If

                    ' 範囲チェック
                    If propDto.RANGE_CHECK = True Then
                        If checkRangeValue(CStr(id), CStr(data(2))) = False Then
                            Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.RANGE_CHECK)
                        End If
                    End If

                    ' 改行チェック
                    If propDto.CRLF_CHECK = True Then
                        If isExistCrLf(CStr(data(2))) = True Then
                            data(2) = convertCrLfToString(CStr(data(2)), " ")
                            Call m_JinikSheetView.setCellValue(CStr(data(0)), CStr(data(2)))
                            Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.CRLF_CHECK)
                        End If
                    End If

                    ' 文字列長チェック
                    If propDto.MAX_LENGTH > 0 Then
                        If Len(data(2)) > propDto.MAX_LENGTH Then
                            Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.LENGTH_CHECK)
                        End If
                    End If

                    ' 条件付き入力チェック
                    If propDto.COND_REQ_CHECK <> "" Then
                        If checkMissingValueByCondition(dto, CStr(id), propDto.COND_REQ_CHECK) = False Then
                            Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.MISSING_CHECK)
                        End If
                    End If

                    ' カスタムチェック
                    If propDto.CUSTOM_CHECK = True Then
                        Select Case CStr(id)
                            Case "jinik_kaito_buyer_jiki"
                                If compareWithTaishokuYoteiNendo(dto, "jinik_kaito_buyer_jiki") < 0 Then
                                   Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.CONSISTENT_CHECK)
                                End If
                            Case "jinik_kaito_buyer_ninteikyu"
                                If checkBuyerNinteikyu(dto) = False Then
                                   Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.CONSISTENT_CHECK)
                                End If
                            Case "jinik_kaito_touyo_jiki"
                                If compareWithTaishokuYoteiNendo(dto, "jinik_kaito_touyo_jiki") < 0 Then
                                   Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.CONSISTENT_CHECK)
                                End If
                            Case "jinik_kaito_touyo_keikaku"
                                If checkTouyoKeikakuKikanshoku(dto) = False Then
                                    Call chkResults.addCheckResultWithErrMsg(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(data(1)), CHECK_RESULT_TYPE.TYPE_ERROR, "既に基幹職のため、より上位の等級群を選択してください。")
                                ElseIf checkTouyoKeikakuSyumushoku(dto) = False Then
                                    Call chkResults.addCheckResultWithErrMsg(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(data(1)), CHECK_RESULT_TYPE.TYPE_ERROR, "既に主務職のため、より上位の等級群を選択してください。")
                                End If
                            Case "jinik_kaito_idosaki_kyoten_01", "jinik_kaito_idosaki_kyoten_02", "jinik_kaito_idosaki_kyoten_03", "jinik_kaito_idosaki_kyoten_04", "jinik_kaito_idosaki_kyoten_05", "jinik_kaito_idosaki_kyoten_06"
                                If checkIdosakiKyoten(dto, CStr(id)) = False Then
                                   Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.COND_MISSING_CHECK)
                                End If
                            Case "jinik_kaito_konin_youken_01", "jinik_kaito_konin_youken_02", "jinik_kaito_konin_youken_03", "jinik_kaito_konin_youken_04", "jinik_kaito_konin_youken_05", "jinik_kaito_konin_youken_06"
                                If checkKouninYouken(dto, CStr(id)) = False Then
                                   Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.COND_MISSING_CHECK)
                                End If
                        End Select
                    End If
                End If
            End If

            Set propDto = Nothing
        Next

        Set dto = Nothing
    Next

    Set checkSheetContents = chkResults

    Exit Function

checkSheetContents_Err:
    If chkResults Is Nothing Then
        Set chkResults = Nothing
    End If

    err.Raise err.Number, "checkSheetContents", err.Description

End Function

' 機能：条件付き未入力チェックを行う
'       第3引数で指定したチェック元の回答項目が入力済みであるとき、第2引数のチェック先の回答項目に値が入力されていることをチェックする
' 引数：
'   rowData : 1シート分の回答情報（Excelでの1行）
'   fillId  : チェック先の回答ID
'   condId  : チェック元の回答ID
' 戻り値：チェック結果（TRUE : OK、FALSE : NG）
Private Function checkMissingValueByCondition(rowData As JinikSheetInfoDto, fillId As String, condId As String)
    Dim ret As Boolean: ret = True
    Dim condValue As String

    condValue = rowData.getValueByFillId(condId)

    If condId Like "jinik_kaito_ido_0?" And condValue <> "○" Then
        condValue = ""
    End If

    If condValue <> "" Then
        If rowData.getValueByFillId(fillId) = "" Then
            ret = False
        End If
    End If

    checkMissingValueByCondition = ret
End Function

' 機能：引数で指定した回答項目の内容（XX年度）と退職予定年度とを比較し、その結果を返す
' 引数：
'   rowData : 1シート分の回答情報（Excelでの1行）
'   fillId  : 比較先の回答ID
' 戻り値：比較結果
'   > 0 : 退職予定年度のほうが大きい
'   = 0 : 退職予定年度と同じ
'   < 0 : 退職予定年度のほうが小さい
Private Function compareWithTaishokuYoteiNendo(rowData As JinikSheetInfoDto, fillId As String) As Long
    Dim i As Long
    Dim key As String
    Dim ret As Long: ret = -1
    Dim nendo As String
    Dim taishokuNendo As Long: taishokuNendo = 9999

    ' jinik_kaito_taishoku_01 ～ jinik_kaito_taishoku_05を順に検索
    For i = 1 To 5
        key = "jinik_kaito_taishoku_0" & CStr(i)

        If rowData.getValueByFillId(key) = "○" Then
            taishokuNendo = CLng(rowData.SheetNendo) + (i - 1)
            Exit For
        End If
    Next i

    nendo = rowData.getValueByFillId(fillId)
    If nendo <> "" And IsNumeric(nendo) = True Then
        ret = taishokuNendo - CLng(nendo)
    Else
        ret = taishokuNendo
    End If

    compareWithTaishokuYoteiNendo = ret
End Function

' 機能：（バイヤー認定計画）認定級のチェックを行う（チェック内容は以下）
'       「認定級」が活性状態（認定年度が空欄以外）のとき、社員属性の「認定級」が2級であるとき、「認定級」が2級であること
' 引数：
'   rowData : 1シート分の回答情報（Excelでの1行）
' 戻り値：チェック結果（TRUE : OK、FALSE : NG）
Private Function checkBuyerNinteikyu(rowData As JinikSheetInfoDto) As Boolean
    Dim rtn As Boolean: rtn = True
    Dim infoBuyer As String
    Dim kaitoBuyer As String

    infoBuyer = rowData.getValueByFillId("jinik_info_buyer")
    kaitoBuyer = rowData.getValueByFillId("jinik_kaito_buyer_ninteikyu")
    
    If infoBuyer = "2級" And kaitoBuyer = "バイヤー2級" Then
        rtn = False
    End If

    checkBuyerNinteikyu = rtn
End Function

' 機能：（登用計画）等級群のチェックを行う（チェック内容は以下）
'       「等級群」が活性状態（登用年度が空欄以外）のとき、社員属性の「等級群」が基幹職であるとき、「等級群」が経営職であること
' 引数：
'   rowData : 1シート分の回答情報（Excelでの1行）
' 戻り値：チェック結果（TRUE : OK、FALSE : NG）
Private Function checkTouyoKeikakuKikanshoku(rowData As JinikSheetInfoDto) As Boolean
    Dim ret As Boolean: ret = True
    Dim toukyuGun As String
    Dim touyoKeikakuAttr As String

    ' 社員属性の「等級群」の取得
    touyoKeikakuAttr = rowData.getValueByFillId("jinik_info_touyo_keikaku")

    ' （登用計画）「等級群」の取得
    toukyuGun = rowData.getValueByFillId("jinik_kaito_touyo_keikaku")

    ' チェック
    If touyoKeikakuAttr = "基幹職" And (toukyuGun = "基幹職" Or toukyuGun = "主務職") Then
        ret = False
    End If

    checkTouyoKeikakuKikanshoku = ret
End Function


' 機能：（登用計画）等級群のチェックを行う（チェック内容は以下）
'       「等級群」が活性状態（登用年度が空欄以外）のとき、社員属性の「等級群」が主務職であるとき、「等級群」が基幹職または経営職であること
' 引数：
'   rowData : 1シート分の回答情報（Excelでの1行）
' 戻り値：チェック結果（TRUE : OK、FALSE : NG）
Private Function checkTouyoKeikakuSyumushoku(rowData As JinikSheetInfoDto) As Boolean
    Dim ret As Boolean: ret = True
    Dim toukyuGun As String
    Dim touyoKeikakuAttr As String

    ' 社員属性の「等級群」の取得
    touyoKeikakuAttr = rowData.getValueByFillId("jinik_info_touyo_keikaku")

    ' （登用計画）「等級群」の取得
    toukyuGun = rowData.getValueByFillId("jinik_kaito_touyo_keikaku")

    ' チェック
    If touyoKeikakuAttr = "主務職" And toukyuGun = "主務職" Then
        ret = False
    End If

    checkTouyoKeikakuSyumushoku = ret
End Function

' 機能：異動先拠点の未入力チェックを行う
'       チェック内容：当該年度の「異動」に○印、かつ「拠点」が空欄、または"変更なし"のとき、「異動先拠点」が未入力でないこと
' 引数：
'   rowData : 1シート分の回答情報（Excelでの1行）
'   fillId  : 回答ID（「異動先拠点」）
' 戻り値：チェック結果（TRUE : OK、FALSE : NG）
Private Function checkIdosakiKyoten(rowData As JinikSheetInfoDto, fillId As String) As Boolean
    Dim ret As Boolean: ret = True
    Dim idx As String
    Dim idoId As String, idoValue As String
    Dim kyotenId As String, kyotenValue  As String

    idx = Right(fillId, 1)

    idoId = "jinik_kaito_ido_0" & idx
    kyotenId = "jinik_kaito_kyoten_0" & idx

    idoValue = rowData.getValueByFillId(idoId)
    kyotenValue = rowData.getValueByFillId(kyotenId)

    If idoValue = "○" And (kyotenValue <> "" And kyotenValue <> "変更なし") Then
        If rowData.getValueByFillId(fillId) = "" Then
            ret = False
        End If
    End If

    checkIdosakiKyoten = ret
End Function

' 機能：後任要件のチェックを行う
'       チェック内容：当該年度の「異動」に○印、かつ「後任要否」が"要"のとき、「後任要件」が未入力でないこと
' 引数：
'   rowData : 1シート分の回答情報（Excelでの1行）
'   fillId  : 回答ID（「後任要件」）
' 戻り値：チェック結果（TRUE : OK、FALSE : NG）
Private Function checkKouninYouken(rowData As JinikSheetInfoDto, fillId As String) As Boolean
    Dim ret As Boolean: ret = True
    Dim idx As String
    Dim idoId As String, idoValue As String
    Dim youhiId As String, youhiValue  As String

    idx = Right(fillId, 1)

    idoId = "jinik_kaito_ido_0" & idx
    youhiId = "jinik_kaito_konin_youhi_0" & idx

    idoValue = rowData.getValueByFillId(idoId)
    youhiValue = rowData.getValueByFillId(youhiId)

    If idoValue = "○" And youhiValue = "要" Then
        If rowData.getValueByFillId(fillId) = "" Then
            ret = False
        End If
    End If

    checkKouninYouken = ret
End Function

' 機能：改行文字の存在チェックを行う
' 引数：
'   str : チェックする文字
' 戻り値：チェック結果（TRUE : 改行あり、FALSE : 改行なし）
Private Function isExistCrLf(str As String) As Boolean
    Dim ret As Boolean: ret = False

    ' CRが含まれるかチェック
    If InStr(str, vbCr) > 0 Then
        ret = True
    End If
    
    ' LFが含まれるかチェック
    If InStr(str, vbLf) > 0 Then
        ret = True
    End If
    
    ' CRLFが含まれるかチェック
    If InStr(str, vbCrLf) > 0 Then
        ret = True
    End If
    
    ' CRとLFが含まれるかチェック
    If InStr(str, vbCr) > 0 And InStr(str, vbLf) > 0 Then
        ret = True
    End If

    isExistCrLf = ret
End Function

' 機能：文字列中の改行文字を指定した文字に置き換える
' 引数：
'   target : 置き換え対象の文字列
'   str    : 置き換える文字
' 戻り値：置き換えた文字列
Private Function convertCrLfToString(Target As String, str As String)

    convertCrLfToString = Replace(Replace(Replace(Target, vbCrLf, vbLf), vbCr, vbLf), vbLf, str)

End Function

Private Function checkRangeValue(id As String, value As String) As Boolean
    Dim compArray() As String

    Select Case id
        Case "jinik_kaito_ido_month"
            compArray = m_MasterSheetView.MONTH_RANGE
        Case "jinik_kaito_buyer_jiki"
            compArray = m_MasterSheetView.BUYER_NENDO_RANGE
        Case "jinik_kaito_buyer_ninteikyu"
            compArray = m_MasterSheetView.BUYER_NINTEIKYU_RANGE
        Case "jinik_kaito_touyo_jiki"
            compArray = m_MasterSheetView.TOUYO_NENDO_RANGE
        Case "jinik_kaito_touyo_keikaku"
            compArray = m_MasterSheetView.TOUKYU_GUN_RANGE
        Case "jinik_kaito_ido_01", "jinik_kaito_ido_02", "jinik_kaito_ido_03", "jinik_kaito_ido_04", "jinik_kaito_ido_05", "jinik_kaito_ido_06"
            compArray = m_MasterSheetView.IDO_TAISHOKU_RANGE
        Case "jinik_kaito_taishoku_01", "jinik_kaito_taishoku_02", "jinik_kaito_taishoku_03", "jinik_kaito_taishoku_04", "jinik_kaito_taishoku_05"
            compArray = m_MasterSheetView.IDO_TAISHOKU_RANGE
        Case "jinik_kaito_ido_month_01", "jinik_kaito_ido_month_02", "jinik_kaito_ido_month_03", "jinik_kaito_ido_month_04", "jinik_kaito_ido_month_05"
            compArray = m_MasterSheetView.MONTH_RANGE
        Case "jinik_kaito_shokumu_01", "jinik_kaito_shokumu_02", "jinik_kaito_shokumu_03", "jinik_kaito_shokumu_04", "jinik_kaito_shokumu_05", "jinik_kaito_shokumu_06"
            compArray = m_MasterSheetView.IDO_SHOKUMU_RANGE
        Case "jinik_kaito_jigyojo_01", "jinik_kaito_jigyojo_02", "jinik_kaito_jigyojo_03", "jinik_kaito_jigyojo_04", "jinik_kaito_jigyojo_05", "jinik_kaito_jigyojo_06"
            compArray = m_MasterSheetView.IDO_JIGYOJO_RANGE
        Case "jinik_kaito_kyoten_01", "jinik_kaito_kyoten_02", "jinik_kaito_kyoten_03", "jinik_kaito_kyoten_04", "jinik_kaito_kyoten_05", "jinik_kaito_kyoten_06"
            compArray = m_MasterSheetView.IDO_KYOTEN_RANGE
        Case "jinik_kaito_konin_youhi_01", "jinik_kaito_konin_youhi_02", "jinik_kaito_konin_youhi_03", "jinik_kaito_konin_youhi_04", "jinik_kaito_konin_youhi_05", "jinik_kaito_konin_youhi_06"
            compArray = m_MasterSheetView.IDO_KOUNIN_RANGE
    End Select

    checkRangeValue = isIncludeInArrays(compArray, value)

End Function

Private Function isIncludeInArrays(arrays() As String, value As String) As Boolean
    Dim ret As Boolean: ret = False
    Dim arr As Variant

    If value <> "" Then
        For Each arr In arrays
            If CStr(arr) = value Then
                ret = True
                Exit For
            End If
        Next
    ElseIf value = "" Or Len(value) = 0 Then
        ret = True
    End If

    isIncludeInArrays = ret
End Function
