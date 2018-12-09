Attribute VB_Name = "CommonModule"
Option Explicit

Public Function getSheetFieldProperties() As Dictionary
    Dim dto As FieldProperty
    Dim dic As Dictionary

    Set dic = New Dictionary

    ' ステータス
    Set dto = New FieldProperty
    Call dto.setNoCheck("STATUS_NM", "ステータス", "2")
    Call dic.Add("STATUS_NM", dto)
    Set dto = Nothing

    ' 退職予定年度
    Set dto = New FieldProperty
    Call dto.setNoCheck("jinik_chohyo_taishoku_nendo", "退職予定年度", "3")
    Call dic.Add("jinik_chohyo_taishoku_nendo", dto)
    Set dto = Nothing
    
    ' GID
    Set dto = New FieldProperty
    Call dto.setNoCheck("OWN_GUID", "GID", "4")
    Call dic.Add("OWN_GUID", dto)
    Set dto = Nothing

    ' 名前
    Set dto = New FieldProperty
    Call dto.setNoCheck("OWN_PERSON_NAME", "名前", "5")
    Call dic.Add("OWN_PERSON_NAME", dto)
    Set dto = Nothing
    
    ' 等級群
    Set dto = New FieldProperty
    Call dto.setNoCheck("jinik_info_touyo_keikaku", "等級群", "13")
    Call dic.Add("jinik_info_touyo_keikaku", dto)
    Set dto = Nothing
    
    ' バイヤー認定
    Set dto = New FieldProperty
    Call dto.setNoCheck("jinik_info_buyer", "バイヤー認定", "19")
    Call dic.Add("jinik_info_buyer", dto)
    Set dto = Nothing
    
    ' 業務開始年月
    Set dto = New FieldProperty
    Call dto.setNoCheck("jinik_ichiran_gyomu_kaisi", "業務開始年月", "21")
    Call dic.Add("jinik_ichiran_gyomu_kaisi", dto)
    Set dto = Nothing
    
    ' 異動月
    Set dto = New FieldProperty
    Call dto.setNoCheck("jinik_kaito_ido_month", "異動月", "32")
    Call dic.Add("jinik_kaito_ido_month", dto)
    Set dto = Nothing
    
    ' 異動先の組織
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_ido_place", "異動先の組織", "33", False, True, 100, "jinik_kaito_ido_month", False)
    Call dic.Add("jinik_kaito_ido_place", dto)
    Set dto = Nothing
    
    ' バイヤー認定計画　認定年度
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_buyer_jiki", "バイヤー認定計画　認定年度", "34", False, False, -1, "", True)
    Call dic.Add("jinik_kaito_buyer_jiki", dto)
    Set dto = Nothing
    
    ' バイヤー認定計画　認定級
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_buyer_ninteikyu", "バイヤー認定計画　認定級", "35", False, False, -1, "jinik_kaito_buyer_jiki", True)
    Call dic.Add("jinik_kaito_buyer_ninteikyu", dto)
    Set dto = Nothing
    
    ' 登用計画　登用年度
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_touyo_jiki", "登用計画　登用年度", "36", False, False, -1, "", True)
    Call dic.Add("jinik_kaito_touyo_jiki", dto)
    Set dto = Nothing
    
    ' 登用計画　等級群
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_touyo_keikaku", "登用計画　等級群", "37", False, False, -1, "jinik_kaito_touyo_jiki", True)
    Call dic.Add("jinik_kaito_touyo_keikaku", dto)
    Set dto = Nothing
    
    ' 現在の担当業務
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_genzai_tanto_gyomu", "現在の担当業務", "38", True, True, 100, "", False)
    Call dic.Add("jinik_kaito_genzai_tanto_gyomu", dto)
    Set dto = Nothing
    
    ' 1年後から5年後まで
    Dim i As Long
    Dim pos As Long: pos = 39
    Dim fillId As String
    
    For i = 0 To 4
        ' {x}年度担当業務計画　異動
        Set dto = New FieldProperty
        fillId = "jinik_kaito_ido_0" & CStr(i + 1)
        Call dto.setNoCheck(fillId, "{" & CStr(i) & "}年度担当業務計画　異動", CStr(pos + (i * 11) + 0))
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度担当業務計画　退職
        Set dto = New FieldProperty
        fillId = "jinik_kaito_taishoku_0" & CStr(i + 1)
        Call dto.setNoCheck(fillId, "{" & CStr(i) & "}年度担当業務計画　退職", CStr(pos + (i * 11) + 1))
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度担当業務計画　担当業務
        Set dto = New FieldProperty
        fillId = "jinik_kaito_tanto_gyomu_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}年度担当業務計画　担当業務", CStr(pos + (i * 11) + 2), False, True, 100, "", False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度異動計画　異動月
        Set dto = New FieldProperty
        fillId = "jinik_kaito_ido_month_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}年度異動計画　異動月", CStr(pos + (i * 11) + 3), False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度異動計画　職務
        Set dto = New FieldProperty
        fillId = "jinik_kaito_shokumu_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}年度異動計画　職務", CStr(pos + (i * 11) + 4), False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度異動計画　事業場
        Set dto = New FieldProperty
        fillId = "jinik_kaito_jigyojo_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}年度異動計画　事業場", CStr(pos + (i * 11) + 5), False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度異動計画　拠点
        Set dto = New FieldProperty
        fillId = "jinik_kaito_kyoten_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}年度異動計画　拠点", CStr(pos + (i * 11) + 6), False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度異動計画　異動先拠点
        Set dto = New FieldProperty
        fillId = "jinik_kaito_idosaki_kyoten_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}年度異動計画　異動先拠点", CStr(pos + (i * 11) + 7), False, True, 100, "", True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度異動計画　異動先の組織
        Set dto = New FieldProperty
        fillId = "jinik_kaito_idosaki_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}年度異動計画　異動先の組織", CStr(pos + (i * 11) + 8), False, True, 100, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}年度異動計画　後任要否
        Set dto = New FieldProperty
        fillId = "jinik_kaito_konin_youhi_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}年度異動計画　後任要否", CStr(pos + (i * 11) + 9), False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
        
        ' {x}年度異動計画　後任要件
        Set dto = New FieldProperty
        fillId = "jinik_kaito_konin_youken_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}年度異動計画　後任要件", CStr(pos + (i * 11) + 10), False, True, 100, "", True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    Next i
    
    ' （未定）担当業務計画　異動
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_ido_06", "（未定）担当業務計画　異動", "94", False, False, -1, "", False)
    Call dic.Add("jinik_kaito_ido_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　担当業務
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_tanto_gyomu_06", "（未定）担当業務計画　担当業務", "95", False, True, 100, "", False)
    Call dic.Add("jinik_kaito_tanto_gyomu_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　職務
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_shokumu_06", "（未定）担当業務計画　職務", "96", False, False, -1, "", False)
    Call dic.Add("jinik_kaito_shokumu_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　事業場
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_jigyojo_06", "（未定）担当業務計画　事業場", "97", False, False, -1, "", False)
    Call dic.Add("jinik_kaito_jigyojo_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　拠点
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_kyoten_06", "（未定）担当業務計画　拠点", "98", False, False, -1, "", False)
    Call dic.Add("jinik_kaito_kyoten_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　異動先拠点
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_idosaki_kyoten_06", "（未定）担当業務計画　異動先拠点", "99", False, True, 100, "", True)
    Call dic.Add("jinik_kaito_idosaki_kyoten_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　異動先の組織
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_idosaki_06", "（未定）担当業務計画　異動先の組織", "100", False, True, 100, "", False)
    Call dic.Add("jinik_kaito_idosaki_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　後任要否
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_konin_youhi_06", "（未定）担当業務計画　後任要否", "101", False, False, -1, "", False)
    Call dic.Add("jinik_kaito_konin_youhi_06", dto)
    Set dto = Nothing
    
    ' （未定）担当業務計画　後任要件
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_konin_youken_06", "（未定）担当業務計画　後任要件", "102", False, True, 100, "", True)
    Call dic.Add("jinik_kaito_konin_youken_06", dto)
    Set dto = Nothing
    
    ' 備考
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_other", "備考", "103", False, False, 1000, "", False)
    Call dic.Add("jinik_kaito_other", dto)
    Set dto = Nothing
    
    Set getSheetFieldProperties = dic
    
    Exit Function

getSheetFieldProperties_Err:
    err.Raise err.Number, "getSheetFieldProperties", err.Description

End Function
