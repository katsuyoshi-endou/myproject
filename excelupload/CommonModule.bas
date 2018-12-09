Attribute VB_Name = "CommonModule"
Option Explicit

Public Function getSheetFieldProperties() As Dictionary
    Dim dto As FieldProperty
    Dim dic As Dictionary

    Set dic = New Dictionary

    ' �X�e�[�^�X
    Set dto = New FieldProperty
    Call dto.setNoCheck("STATUS_NM", "�X�e�[�^�X", "2")
    Call dic.Add("STATUS_NM", dto)
    Set dto = Nothing

    ' �ސE�\��N�x
    Set dto = New FieldProperty
    Call dto.setNoCheck("jinik_chohyo_taishoku_nendo", "�ސE�\��N�x", "3")
    Call dic.Add("jinik_chohyo_taishoku_nendo", dto)
    Set dto = Nothing
    
    ' GID
    Set dto = New FieldProperty
    Call dto.setNoCheck("OWN_GUID", "GID", "4")
    Call dic.Add("OWN_GUID", dto)
    Set dto = Nothing

    ' ���O
    Set dto = New FieldProperty
    Call dto.setNoCheck("OWN_PERSON_NAME", "���O", "5")
    Call dic.Add("OWN_PERSON_NAME", dto)
    Set dto = Nothing
    
    ' �����Q
    Set dto = New FieldProperty
    Call dto.setNoCheck("jinik_info_touyo_keikaku", "�����Q", "13")
    Call dic.Add("jinik_info_touyo_keikaku", dto)
    Set dto = Nothing
    
    ' �o�C���[�F��
    Set dto = New FieldProperty
    Call dto.setNoCheck("jinik_info_buyer", "�o�C���[�F��", "19")
    Call dic.Add("jinik_info_buyer", dto)
    Set dto = Nothing
    
    ' �Ɩ��J�n�N��
    Set dto = New FieldProperty
    Call dto.setNoCheck("jinik_ichiran_gyomu_kaisi", "�Ɩ��J�n�N��", "21")
    Call dic.Add("jinik_ichiran_gyomu_kaisi", dto)
    Set dto = Nothing
    
    ' �ٓ���
    Set dto = New FieldProperty
    Call dto.setNoCheck("jinik_kaito_ido_month", "�ٓ���", "32")
    Call dic.Add("jinik_kaito_ido_month", dto)
    Set dto = Nothing
    
    ' �ٓ���̑g�D
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_ido_place", "�ٓ���̑g�D", "33", False, True, 100, "jinik_kaito_ido_month", False)
    Call dic.Add("jinik_kaito_ido_place", dto)
    Set dto = Nothing
    
    ' �o�C���[�F��v��@�F��N�x
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_buyer_jiki", "�o�C���[�F��v��@�F��N�x", "34", False, False, -1, "", True)
    Call dic.Add("jinik_kaito_buyer_jiki", dto)
    Set dto = Nothing
    
    ' �o�C���[�F��v��@�F�苉
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_buyer_ninteikyu", "�o�C���[�F��v��@�F�苉", "35", False, False, -1, "jinik_kaito_buyer_jiki", True)
    Call dic.Add("jinik_kaito_buyer_ninteikyu", dto)
    Set dto = Nothing
    
    ' �o�p�v��@�o�p�N�x
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_touyo_jiki", "�o�p�v��@�o�p�N�x", "36", False, False, -1, "", True)
    Call dic.Add("jinik_kaito_touyo_jiki", dto)
    Set dto = Nothing
    
    ' �o�p�v��@�����Q
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_touyo_keikaku", "�o�p�v��@�����Q", "37", False, False, -1, "jinik_kaito_touyo_jiki", True)
    Call dic.Add("jinik_kaito_touyo_keikaku", dto)
    Set dto = Nothing
    
    ' ���݂̒S���Ɩ�
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_genzai_tanto_gyomu", "���݂̒S���Ɩ�", "38", True, True, 100, "", False)
    Call dic.Add("jinik_kaito_genzai_tanto_gyomu", dto)
    Set dto = Nothing
    
    ' 1�N�ォ��5�N��܂�
    Dim i As Long
    Dim pos As Long: pos = 39
    Dim fillId As String
    
    For i = 0 To 4
        ' {x}�N�x�S���Ɩ��v��@�ٓ�
        Set dto = New FieldProperty
        fillId = "jinik_kaito_ido_0" & CStr(i + 1)
        Call dto.setNoCheck(fillId, "{" & CStr(i) & "}�N�x�S���Ɩ��v��@�ٓ�", CStr(pos + (i * 11) + 0))
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�S���Ɩ��v��@�ސE
        Set dto = New FieldProperty
        fillId = "jinik_kaito_taishoku_0" & CStr(i + 1)
        Call dto.setNoCheck(fillId, "{" & CStr(i) & "}�N�x�S���Ɩ��v��@�ސE", CStr(pos + (i * 11) + 1))
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�S���Ɩ��v��@�S���Ɩ�
        Set dto = New FieldProperty
        fillId = "jinik_kaito_tanto_gyomu_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}�N�x�S���Ɩ��v��@�S���Ɩ�", CStr(pos + (i * 11) + 2), False, True, 100, "", False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�ٓ��v��@�ٓ���
        Set dto = New FieldProperty
        fillId = "jinik_kaito_ido_month_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@�ٓ���", CStr(pos + (i * 11) + 3), False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�ٓ��v��@�E��
        Set dto = New FieldProperty
        fillId = "jinik_kaito_shokumu_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@�E��", CStr(pos + (i * 11) + 4), False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�ٓ��v��@���Ə�
        Set dto = New FieldProperty
        fillId = "jinik_kaito_jigyojo_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@���Ə�", CStr(pos + (i * 11) + 5), False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�ٓ��v��@���_
        Set dto = New FieldProperty
        fillId = "jinik_kaito_kyoten_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@���_", CStr(pos + (i * 11) + 6), False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�ٓ��v��@�ٓ��拒�_
        Set dto = New FieldProperty
        fillId = "jinik_kaito_idosaki_kyoten_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@�ٓ��拒�_", CStr(pos + (i * 11) + 7), False, True, 100, "", True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�ٓ��v��@�ٓ���̑g�D
        Set dto = New FieldProperty
        fillId = "jinik_kaito_idosaki_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@�ٓ���̑g�D", CStr(pos + (i * 11) + 8), False, True, 100, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�ٓ��v��@��C�v��
        Set dto = New FieldProperty
        fillId = "jinik_kaito_konin_youhi_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@��C�v��", CStr(pos + (i * 11) + 9), False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
        
        ' {x}�N�x�ٓ��v��@��C�v��
        Set dto = New FieldProperty
        fillId = "jinik_kaito_konin_youken_0" & CStr(i + 1)
        Call dto.setAll(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@��C�v��", CStr(pos + (i * 11) + 10), False, True, 100, "", True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    Next i
    
    ' �i����j�S���Ɩ��v��@�ٓ�
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_ido_06", "�i����j�S���Ɩ��v��@�ٓ�", "94", False, False, -1, "", False)
    Call dic.Add("jinik_kaito_ido_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@�S���Ɩ�
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_tanto_gyomu_06", "�i����j�S���Ɩ��v��@�S���Ɩ�", "95", False, True, 100, "", False)
    Call dic.Add("jinik_kaito_tanto_gyomu_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@�E��
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_shokumu_06", "�i����j�S���Ɩ��v��@�E��", "96", False, False, -1, "", False)
    Call dic.Add("jinik_kaito_shokumu_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@���Ə�
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_jigyojo_06", "�i����j�S���Ɩ��v��@���Ə�", "97", False, False, -1, "", False)
    Call dic.Add("jinik_kaito_jigyojo_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@���_
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_kyoten_06", "�i����j�S���Ɩ��v��@���_", "98", False, False, -1, "", False)
    Call dic.Add("jinik_kaito_kyoten_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@�ٓ��拒�_
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_idosaki_kyoten_06", "�i����j�S���Ɩ��v��@�ٓ��拒�_", "99", False, True, 100, "", True)
    Call dic.Add("jinik_kaito_idosaki_kyoten_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@�ٓ���̑g�D
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_idosaki_06", "�i����j�S���Ɩ��v��@�ٓ���̑g�D", "100", False, True, 100, "", False)
    Call dic.Add("jinik_kaito_idosaki_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@��C�v��
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_konin_youhi_06", "�i����j�S���Ɩ��v��@��C�v��", "101", False, False, -1, "", False)
    Call dic.Add("jinik_kaito_konin_youhi_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@��C�v��
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_konin_youken_06", "�i����j�S���Ɩ��v��@��C�v��", "102", False, True, 100, "", True)
    Call dic.Add("jinik_kaito_konin_youken_06", dto)
    Set dto = Nothing
    
    ' ���l
    Set dto = New FieldProperty
    Call dto.setAll("jinik_kaito_other", "���l", "103", False, False, 1000, "", False)
    Call dic.Add("jinik_kaito_other", dto)
    Set dto = Nothing
    
    Set getSheetFieldProperties = dic
    
    Exit Function

getSheetFieldProperties_Err:
    err.Raise err.Number, "getSheetFieldProperties", err.Description

End Function
