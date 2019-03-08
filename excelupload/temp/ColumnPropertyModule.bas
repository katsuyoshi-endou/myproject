Attribute VB_Name = "ColumnPropertyModule"
Option Explicit

' 「人材育成計画」シートの入力項目位置を定義したモジュール

' 項目の位置が変わったときはここを書き換えること

' ステータス・属性情報など
Public Const STATUS_NM_CLMN_POS As Long = 2
Public Const JINIK_CHOHYO_TAISHOKU_NENDO_CLMN_POS As Long = 3
Public Const OWN_GUID_CLMN_POS As Long = 4
Public Const OWN_PERSON_NAME_CLMN_POS As Long = 5
Public Const JINIK_INFO_TOUYO_KEIKAKU_CLMN_POS As Long = 13
Public Const JINIK_INFO_BUYER_CLMN_POS As Long = 19
Public Const JINIK_ICHIRAN_GYOMU_KAISI_CLMN_POS As Long = 21

' 異動計画（直近）
Public Const JINIK_KAITO_KONIN_YOUKEN_CHOKKIN_CLMN_POS As Long = 31

' 異動実績・バイヤー・登用計画・現在担当業務
Public Const JINIK_KAITO_IDO_MONTH_CLMN_POS As Long = 32
Public Const JINIK_KAITO_IDO_PLACE_CLMN_POS As Long = 33
Public Const JINIK_KAITO_BUYER_JIKI_CLMN_POS As Long = 34
Public Const JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS As Long = 35
Public Const JINIK_KAITO_TOUYO_JIKI_CLMN_POS As Long = 36
Public Const JINIK_KAITO_TOUYO_KEIKAKU_CLMN_POS As Long = 37
Public Const JINIK_KAITO_GENZAI_TANTO_GYOMU_CLMN_POS As Long = 38

' 1年後担当業務・異動計画
Public Const JINIK_KAITO_IDO_01_CLMN_POS As Long = 39
Public Const JINIK_KAITO_TAISHOKU_01_CLMN_POS As Long = 40
Public Const JINIK_KAITO_TANTO_GYOMU_01_CLMN_POS As Long = 41
Public Const JINIK_KAITO_IDO_MONTH_01_CLMN_POS As Long = 42
Public Const JINIK_KAITO_SHOKUMU_01_CLMN_POS As Long = 43
Public Const JINIK_KAITO_JIGYOJO_01_CLMN_POS As Long = 44
Public Const JINIK_KAITO_KYOTEN_01_CLMN_POS As Long = 45
Public Const JINIK_KAITO_IDOSAKI_KYOTEN_01_CLMN_POS As Long = 46
Public Const JINIK_KAITO_IDOSAKI_01_CLMN_POS As Long = 47
Public Const JINIK_KAITO_KONIN_YOUHI_01_CLMN_POS As Long = 48
Public Const JINIK_KAITO_KONIN_YOUKEN_01_CLMN_POS As Long = 49

' 2年後担当業務・異動計画
Public Const JINIK_KAITO_IDO_02_CLMN_POS As Long = 50
Public Const JINIK_KAITO_TAISHOKU_02_CLMN_POS As Long = 51
Public Const JINIK_KAITO_TANTO_GYOMU_02_CLMN_POS As Long = 52
Public Const JINIK_KAITO_IDO_MONTH_02_CLMN_POS As Long = 53
Public Const JINIK_KAITO_SHOKUMU_02_CLMN_POS As Long = 54
Public Const JINIK_KAITO_JIGYOJO_02_CLMN_POS As Long = 55
Public Const JINIK_KAITO_KYOTEN_02_CLMN_POS As Long = 56
Public Const JINIK_KAITO_IDOSAKI_KYOTEN_02_CLMN_POS As Long = 57
Public Const JINIK_KAITO_IDOSAKI_02_CLMN_POS As Long = 58
Public Const JINIK_KAITO_KONIN_YOUHI_02_CLMN_POS As Long = 59
Public Const JINIK_KAITO_KONIN_YOUKEN_02_CLMN_POS As Long = 60

' 3年後担当業務・異動計画
Public Const JINIK_KAITO_IDO_03_CLMN_POS As Long = 61
Public Const JINIK_KAITO_TAISHOKU_03_CLMN_POS As Long = 62
Public Const JINIK_KAITO_TANTO_GYOMU_03_CLMN_POS As Long = 63
Public Const JINIK_KAITO_IDO_MONTH_03_CLMN_POS As Long = 64
Public Const JINIK_KAITO_SHOKUMU_03_CLMN_POS As Long = 65
Public Const JINIK_KAITO_JIGYOJO_03_CLMN_POS As Long = 66
Public Const JINIK_KAITO_KYOTEN_03_CLMN_POS As Long = 67
Public Const JINIK_KAITO_IDOSAKI_KYOTEN_03_CLMN_POS As Long = 68
Public Const JINIK_KAITO_IDOSAKI_03_CLMN_POS As Long = 69
Public Const JINIK_KAITO_KONIN_YOUHI_03_CLMN_POS As Long = 70
Public Const JINIK_KAITO_KONIN_YOUKEN_03_CLMN_POS As Long = 71

' 4年後担当業務・異動計画
Public Const JINIK_KAITO_IDO_04_CLMN_POS As Long = 72
Public Const JINIK_KAITO_TAISHOKU_04_CLMN_POS As Long = 73
Public Const JINIK_KAITO_TANTO_GYOMU_04_CLMN_POS As Long = 74
Public Const JINIK_KAITO_IDO_MONTH_04_CLMN_POS As Long = 75
Public Const JINIK_KAITO_SHOKUMU_04_CLMN_POS As Long = 76
Public Const JINIK_KAITO_JIGYOJO_04_CLMN_POS As Long = 77
Public Const JINIK_KAITO_KYOTEN_04_CLMN_POS As Long = 78
Public Const JINIK_KAITO_IDOSAKI_KYOTEN_04_CLMN_POS As Long = 79
Public Const JINIK_KAITO_IDOSAKI_04_CLMN_POS As Long = 80
Public Const JINIK_KAITO_KONIN_YOUHI_04_CLMN_POS As Long = 81
Public Const JINIK_KAITO_KONIN_YOUKEN_04_CLMN_POS As Long = 82

' 5年後担当業務・異動計画
Public Const JINIK_KAITO_IDO_05_CLMN_POS As Long = 83
Public Const JINIK_KAITO_TAISHOKU_05_CLMN_POS As Long = 84
Public Const JINIK_KAITO_TANTO_GYOMU_05_CLMN_POS As Long = 85
Public Const JINIK_KAITO_IDO_MONTH_05_CLMN_POS As Long = 86
Public Const JINIK_KAITO_SHOKUMU_05_CLMN_POS As Long = 87
Public Const JINIK_KAITO_JIGYOJO_05_CLMN_POS As Long = 88
Public Const JINIK_KAITO_KYOTEN_05_CLMN_POS As Long = 89
Public Const JINIK_KAITO_IDOSAKI_KYOTEN_05_CLMN_POS As Long = 90
Public Const JINIK_KAITO_IDOSAKI_05_CLMN_POS As Long = 91
Public Const JINIK_KAITO_KONIN_YOUHI_05_CLMN_POS As Long = 92
Public Const JINIK_KAITO_KONIN_YOUKEN_05_CLMN_POS As Long = 93

' 未定担当業務・異動計画
Public Const JINIK_KAITO_IDO_06_CLMN_POS As Long = 94
Public Const JINIK_KAITO_TANTO_GYOMU_06_CLMN_POS As Long = 95
Public Const JINIK_KAITO_SHOKUMU_06_CLMN_POS As Long = 96
Public Const JINIK_KAITO_JIGYOJO_06_CLMN_POS As Long = 97
Public Const JINIK_KAITO_KYOTEN_06_CLMN_POS As Long = 98
Public Const JINIK_KAITO_IDOSAKI_KYOTEN_06_CLMN_POS As Long = 99
Public Const JINIK_KAITO_IDOSAKI_06_CLMN_POS As Long = 100
Public Const JINIK_KAITO_KONIN_YOUHI_06_CLMN_POS As Long = 101
Public Const JINIK_KAITO_KONIN_YOUKEN_06_CLMN_POS As Long = 102

' 備考
Public Const JINIK_KAITO_OTHER_CLMN_POS As Long = 103

' 退職予定者フラグ（非表示）
Public Const JINIK_ICHIRAN_TAISHOKU_YOTEI_FLG_POS As Long = 104


' 機能：各項目のプロパティをFieldProperty型のディクショナリオブジェクト格納して返す
' 引数：なし
' 戻り値：
Public Function getSheetFieldProperties() As Dictionary
    Dim dto As FieldProperty
    Dim dic As Dictionary

    Set dic = New Dictionary

    ' ステータス
    Set dto = New FieldProperty
    Call dto.setItem("STATUS_NM", "ステータス", CStr(STATUS_NM_CLMN_POS))
    Call dic.Add("STATUS_NM", dto)
    Set dto = Nothing

    ' 退職予定年度
    Set dto = New FieldProperty
    Call dto.setItem("jinik_chohyo_taishoku_nendo", "退職予定年度", CStr(JINIK_CHOHYO_TAISHOKU_NENDO_CLMN_POS))
    Call dic.Add("jinik_chohyo_taishoku_nendo", dto)
    Set dto = Nothing
    
    ' GID
    Set dto = New FieldProperty
    Call dto.setItem("OWN_GUID", "GID", CStr(OWN_GUID_CLMN_POS))
    Call dic.Add("OWN_GUID", dto)
    Set dto = Nothing

    ' 名前
    Set dto = New FieldProperty
    Call dto.setItem("OWN_PERSON_NAME", "名前", CStr(OWN_PERSON_NAME_CLMN_POS))
    Call dic.Add("OWN_PERSON_NAME", dto)
    Set dto = Nothing
    
    ' 等級群
    Set dto = New FieldProperty
    Call dto.setItem("jinik_info_touyo_keikaku", "等級群", CStr(JINIK_INFO_TOUYO_KEIKAKU_CLMN_POS))
    Call dic.Add("jinik_info_touyo_keikaku", dto)
    Set dto = Nothing
    
    ' バイヤー認定
    Set dto = New FieldProperty
    Call dto.setItem("jinik_info_buyer", "バイヤー認定", CStr(JINIK_INFO_BUYER_CLMN_POS))
    Call dic.Add("jinik_info_buyer", dto)
    Set dto = Nothing
    
    ' 業務開始年月
    Set dto = New FieldProperty
    Call dto.setItem("jinik_ichiran_gyomu_kaisi", "業務開始年月", CStr(JINIK_ICHIRAN_GYOMU_KAISI_CLMN_POS))
    Call dic.Add("jinik_ichiran_gyomu_kaisi", dto)
    Set dto = Nothing
    
    ' 異動月
    Set dto = New FieldProperty
    Call dto.setItem("jinik_kaito_ido_month", "異動月", CStr(JINIK_KAITO_IDO_MONTH_CLMN_POS))
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_ido_month", dto)
    Set dto = Nothing
    
    ' 異動先の組織
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_ido_place", "異動先の組織", CStr(JINIK_KAITO_IDO_PLACE_CLMN_POS), "進捗状況確認中", False, True, 100, "jinik_kaito_ido_month", False)
    Call dic.Add("jinik_kaito_ido_place", dto)
    Set dto = Nothing
    
    ' バイヤー認定計画　認定年度
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_buyer_jiki", "バイヤー認定計画　認定年度", CStr(JINIK_KAITO_BUYER_JIKI_CLMN_POS), "計画入力中", False, False, -1, "", True)
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_buyer_jiki", dto)
    Set dto = Nothing
    
    ' バイヤー認定計画　認定級
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_buyer_ninteikyu", "バイヤー認定計画　認定級", CStr(JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS), "計画入力中", False, False, -1, "jinik_kaito_buyer_jiki", True)
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_buyer_ninteikyu", dto)
    Set dto = Nothing
    
    ' 登用計画　登用年度
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_touyo_jiki", "登用計画　登用年度", CStr(JINIK_KAITO_TOUYO_JIKI_CLMN_POS), "計画入力中", False, False, -1, "", True)
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_touyo_jiki", dto)
    Set dto = Nothing
    
    ' 登用計画　等級群
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_touyo_keikaku", "登用計画　等級群", CStr(JINIK_KAITO_TOUYO_KEIKAKU_CLMN_POS), "計画入力中", False, False, -1, "jinik_kaito_touyo_jiki", True)
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_touyo_keikaku", dto)
    Set dto = Nothing
    
    ' 現在の担当業務
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_genzai_tanto_gyomu", "現在の担当業務", CStr(JINIK_KAITO_GENZAI_TANTO_GYOMU_CLMN_POS), "計画入力中", True, True, 100, "", False)
    Call dic.Add("jinik_kaito_genzai_tanto_gyomu", dto)
    Set dto = Nothing
    
    ' 1年後から5年後まで
    Dim i As Long
    Dim pos As Long: pos = JINIK_KAITO_IDO_01_CLMN_POS
    Dim fillId As String
    
    For i = 0 To 4
        ' {x}年度担当業務計画　異動
        Set dto = New FieldProperty
        fillId = "jinik_kaito_ido_0" & CStr(i + 1)
'        Call dto.setItem(fillId, "{" & CStr(i) & "}年度担当業務計画　異動", CStr(pos + (i * 11) + 0))
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}年度担当業務計画　異動", CStr(pos + (i * 11) + 0), "計画入力中", False, False, -1, "", False)
        Call dto.setRangeCheck(True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度担当業務計画　退職
        Set dto = New FieldProperty
        fillId = "jinik_kaito_taishoku_0" & CStr(i + 1)
'        Call dto.setItem(fillId, "{" & CStr(i) & "}年度担当業務計画　退職", CStr(pos + (i * 11) + 1))
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}年度担当業務計画　退職", CStr(pos + (i * 11) + 1), "計画入力中", False, False, -1, "", False)
        Call dto.setRangeCheck(True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度担当業務計画　担当業務
        Set dto = New FieldProperty
        fillId = "jinik_kaito_tanto_gyomu_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}年度担当業務計画　担当業務", CStr(pos + (i * 11) + 2), "計画入力中", False, True, 100, "", False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度異動計画　異動月
        Set dto = New FieldProperty
        fillId = "jinik_kaito_ido_month_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}年度異動計画　異動月", CStr(pos + (i * 11) + 3), "計画入力中", False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dto.setRangeCheck(True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度異動計画　職務
        Set dto = New FieldProperty
        fillId = "jinik_kaito_shokumu_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}年度異動計画　職務", CStr(pos + (i * 11) + 4), "計画入力中", False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dto.setRangeCheck(True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度異動計画　事業場
        Set dto = New FieldProperty
        fillId = "jinik_kaito_jigyojo_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}年度異動計画　事業場", CStr(pos + (i * 11) + 5), "計画入力中", False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dto.setRangeCheck(True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度異動計画　拠点
        Set dto = New FieldProperty
        fillId = "jinik_kaito_kyoten_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}年度異動計画　拠点", CStr(pos + (i * 11) + 6), "計画入力中", False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dto.setRangeCheck(True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度異動計画　異動先拠点
        Set dto = New FieldProperty
        fillId = "jinik_kaito_idosaki_kyoten_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}年度異動計画　異動先拠点", CStr(pos + (i * 11) + 7), "計画入力中", False, True, 100, "", True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度異動計画　異動先の組織
        Set dto = New FieldProperty
        fillId = "jinik_kaito_idosaki_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}年度異動計画　異動先の組織", CStr(pos + (i * 11) + 8), "計画入力中", False, True, 100, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度異動計画　後任要否
        Set dto = New FieldProperty
        fillId = "jinik_kaito_konin_youhi_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}年度異動計画　後任要否", CStr(pos + (i * 11) + 9), "計画入力中", False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dto.setRangeCheck(True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
        
        ' {x}年度異動計画　後任要件
        Set dto = New FieldProperty
        fillId = "jinik_kaito_konin_youken_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}年度異動計画　後任要件", CStr(pos + (i * 11) + 10), "計画入力中", False, True, 100, "", True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    Next i
    
    ' （未定）担当業務計画　異動
    Set dto = New FieldProperty
    Call dto.setItem("jinik_kaito_ido_06", "（未定）担当業務計画　異動", CStr(JINIK_KAITO_IDO_06_CLMN_POS))
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_ido_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　担当業務
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_tanto_gyomu_06", "（未定）担当業務計画　担当業務", CStr(JINIK_KAITO_TANTO_GYOMU_06_CLMN_POS), "計画入力中", False, True, 100, "", False)
    Call dic.Add("jinik_kaito_tanto_gyomu_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　職務
    Set dto = New FieldProperty
    Call dto.setItem("jinik_kaito_shokumu_06", "（未定）異動計画　職務", CStr(JINIK_KAITO_SHOKUMU_06_CLMN_POS))
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_shokumu_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　事業場
    Set dto = New FieldProperty
    Call dto.setItem("jinik_kaito_jigyojo_06", "（未定）異動計画　事業場", CStr(JINIK_KAITO_JIGYOJO_06_CLMN_POS))
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_jigyojo_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　拠点
    Set dto = New FieldProperty
    Call dto.setItem("jinik_kaito_kyoten_06", "（未定）異動計画　拠点", CStr(JINIK_KAITO_KYOTEN_06_CLMN_POS))
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_kyoten_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　異動先拠点
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_idosaki_kyoten_06", "（未定）異動計画　異動先拠点", CStr(JINIK_KAITO_IDOSAKI_KYOTEN_06_CLMN_POS), "計画入力中", False, True, 100, "", True)
    Call dic.Add("jinik_kaito_idosaki_kyoten_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　異動先の組織
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_idosaki_06", "（未定）異動計画　異動先の組織", CStr(JINIK_KAITO_IDOSAKI_06_CLMN_POS), "計画入力中", False, True, 100, "", False)
    Call dic.Add("jinik_kaito_idosaki_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　後任要否
    Set dto = New FieldProperty
    Call dto.setItem("jinik_kaito_konin_youhi_06", "（未定）異動計画　後任要否", CStr(JINIK_KAITO_KONIN_YOUHI_06_CLMN_POS))
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_konin_youhi_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　後任要件
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_konin_youken_06", "（未定）異動計画　後任要件", CStr(JINIK_KAITO_KONIN_YOUKEN_06_CLMN_POS), "計画入力中", False, True, 100, "", True)
    Call dic.Add("jinik_kaito_konin_youken_06", dto)
    Set dto = Nothing
    
    ' 備考
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_other", "備考", CStr(JINIK_KAITO_OTHER_CLMN_POS), "計画入力中", False, False, 1000, "", False)
    Call dic.Add("jinik_kaito_other", dto)
    Set dto = Nothing
    
    Set getSheetFieldProperties = dic
    
    Exit Function

getSheetFieldProperties_Err:
    If dto Is Nothing Then
        Set dto = Nothing
    End If

    If dic Is Nothing Then
        Set dic = Nothing
    End If

    err.Raise err.Number, "getSheetFieldProperties", err.Description

End Function

