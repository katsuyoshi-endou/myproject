Attribute VB_Name = "ColumnPropertyModule"
Option Explicit

' �u�l�ވ琬�v��v�V�[�g�̓��͍��ڈʒu���`�������W���[��

' ���ڂ̈ʒu���ς�����Ƃ��͂��������������邱��

' �X�e�[�^�X�E�������Ȃ�
Public Const STATUS_NM_CLMN_POS As Long = 2
Public Const JINIK_CHOHYO_TAISHOKU_NENDO_CLMN_POS As Long = 3
Public Const OWN_GUID_CLMN_POS As Long = 4
Public Const OWN_PERSON_NAME_CLMN_POS As Long = 5
Public Const JINIK_INFO_TOUYO_KEIKAKU_CLMN_POS As Long = 13
Public Const JINIK_INFO_BUYER_CLMN_POS As Long = 19
Public Const JINIK_ICHIRAN_GYOMU_KAISI_CLMN_POS As Long = 21

' �ٓ��v��i���߁j
Public Const JINIK_KAITO_KONIN_YOUKEN_CHOKKIN_CLMN_POS As Long = 31

' �ٓ����сE�o�C���[�E�o�p�v��E���ݒS���Ɩ�
Public Const JINIK_KAITO_IDO_MONTH_CLMN_POS As Long = 32
Public Const JINIK_KAITO_IDO_PLACE_CLMN_POS As Long = 33
Public Const JINIK_KAITO_BUYER_JIKI_CLMN_POS As Long = 34
Public Const JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS As Long = 35
Public Const JINIK_KAITO_TOUYO_JIKI_CLMN_POS As Long = 36
Public Const JINIK_KAITO_TOUYO_KEIKAKU_CLMN_POS As Long = 37
Public Const JINIK_KAITO_GENZAI_TANTO_GYOMU_CLMN_POS As Long = 38

' 1�N��S���Ɩ��E�ٓ��v��
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

' 2�N��S���Ɩ��E�ٓ��v��
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

' 3�N��S���Ɩ��E�ٓ��v��
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

' 4�N��S���Ɩ��E�ٓ��v��
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

' 5�N��S���Ɩ��E�ٓ��v��
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

' ����S���Ɩ��E�ٓ��v��
Public Const JINIK_KAITO_IDO_06_CLMN_POS As Long = 94
Public Const JINIK_KAITO_TANTO_GYOMU_06_CLMN_POS As Long = 95
Public Const JINIK_KAITO_SHOKUMU_06_CLMN_POS As Long = 96
Public Const JINIK_KAITO_JIGYOJO_06_CLMN_POS As Long = 97
Public Const JINIK_KAITO_KYOTEN_06_CLMN_POS As Long = 98
Public Const JINIK_KAITO_IDOSAKI_KYOTEN_06_CLMN_POS As Long = 99
Public Const JINIK_KAITO_IDOSAKI_06_CLMN_POS As Long = 100
Public Const JINIK_KAITO_KONIN_YOUHI_06_CLMN_POS As Long = 101
Public Const JINIK_KAITO_KONIN_YOUKEN_06_CLMN_POS As Long = 102

' ���l
Public Const JINIK_KAITO_OTHER_CLMN_POS As Long = 103

' �ސE�\��҃t���O�i��\���j
Public Const JINIK_ICHIRAN_TAISHOKU_YOTEI_FLG_POS As Long = 104


' �@�\�F�e���ڂ̃v���p�e�B��FieldProperty�^�̃f�B�N�V���i���I�u�W�F�N�g�i�[���ĕԂ�
' �����F�Ȃ�
' �߂�l�F
Public Function getSheetFieldProperties() As Dictionary
    Dim dto As FieldProperty
    Dim dic As Dictionary

    Set dic = New Dictionary

    ' �X�e�[�^�X
    Set dto = New FieldProperty
    Call dto.setItem("STATUS_NM", "�X�e�[�^�X", CStr(STATUS_NM_CLMN_POS))
    Call dic.Add("STATUS_NM", dto)
    Set dto = Nothing

    ' �ސE�\��N�x
    Set dto = New FieldProperty
    Call dto.setItem("jinik_chohyo_taishoku_nendo", "�ސE�\��N�x", CStr(JINIK_CHOHYO_TAISHOKU_NENDO_CLMN_POS))
    Call dic.Add("jinik_chohyo_taishoku_nendo", dto)
    Set dto = Nothing
    
    ' GID
    Set dto = New FieldProperty
    Call dto.setItem("OWN_GUID", "GID", CStr(OWN_GUID_CLMN_POS))
    Call dic.Add("OWN_GUID", dto)
    Set dto = Nothing

    ' ���O
    Set dto = New FieldProperty
    Call dto.setItem("OWN_PERSON_NAME", "���O", CStr(OWN_PERSON_NAME_CLMN_POS))
    Call dic.Add("OWN_PERSON_NAME", dto)
    Set dto = Nothing
    
    ' �����Q
    Set dto = New FieldProperty
    Call dto.setItem("jinik_info_touyo_keikaku", "�����Q", CStr(JINIK_INFO_TOUYO_KEIKAKU_CLMN_POS))
    Call dic.Add("jinik_info_touyo_keikaku", dto)
    Set dto = Nothing
    
    ' �o�C���[�F��
    Set dto = New FieldProperty
    Call dto.setItem("jinik_info_buyer", "�o�C���[�F��", CStr(JINIK_INFO_BUYER_CLMN_POS))
    Call dic.Add("jinik_info_buyer", dto)
    Set dto = Nothing
    
    ' �Ɩ��J�n�N��
    Set dto = New FieldProperty
    Call dto.setItem("jinik_ichiran_gyomu_kaisi", "�Ɩ��J�n�N��", CStr(JINIK_ICHIRAN_GYOMU_KAISI_CLMN_POS))
    Call dic.Add("jinik_ichiran_gyomu_kaisi", dto)
    Set dto = Nothing
    
    ' �ٓ���
    Set dto = New FieldProperty
    Call dto.setItem("jinik_kaito_ido_month", "�ٓ���", CStr(JINIK_KAITO_IDO_MONTH_CLMN_POS))
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_ido_month", dto)
    Set dto = Nothing
    
    ' �ٓ���̑g�D
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_ido_place", "�ٓ���̑g�D", CStr(JINIK_KAITO_IDO_PLACE_CLMN_POS), "�i���󋵊m�F��", False, True, 100, "jinik_kaito_ido_month", False)
    Call dic.Add("jinik_kaito_ido_place", dto)
    Set dto = Nothing
    
    ' �o�C���[�F��v��@�F��N�x
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_buyer_jiki", "�o�C���[�F��v��@�F��N�x", CStr(JINIK_KAITO_BUYER_JIKI_CLMN_POS), "�v����͒�", False, False, -1, "", True)
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_buyer_jiki", dto)
    Set dto = Nothing
    
    ' �o�C���[�F��v��@�F�苉
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_buyer_ninteikyu", "�o�C���[�F��v��@�F�苉", CStr(JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS), "�v����͒�", False, False, -1, "jinik_kaito_buyer_jiki", True)
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_buyer_ninteikyu", dto)
    Set dto = Nothing
    
    ' �o�p�v��@�o�p�N�x
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_touyo_jiki", "�o�p�v��@�o�p�N�x", CStr(JINIK_KAITO_TOUYO_JIKI_CLMN_POS), "�v����͒�", False, False, -1, "", True)
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_touyo_jiki", dto)
    Set dto = Nothing
    
    ' �o�p�v��@�����Q
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_touyo_keikaku", "�o�p�v��@�����Q", CStr(JINIK_KAITO_TOUYO_KEIKAKU_CLMN_POS), "�v����͒�", False, False, -1, "jinik_kaito_touyo_jiki", True)
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_touyo_keikaku", dto)
    Set dto = Nothing
    
    ' ���݂̒S���Ɩ�
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_genzai_tanto_gyomu", "���݂̒S���Ɩ�", CStr(JINIK_KAITO_GENZAI_TANTO_GYOMU_CLMN_POS), "�v����͒�", True, True, 100, "", False)
    Call dic.Add("jinik_kaito_genzai_tanto_gyomu", dto)
    Set dto = Nothing
    
    ' 1�N�ォ��5�N��܂�
    Dim i As Long
    Dim pos As Long: pos = JINIK_KAITO_IDO_01_CLMN_POS
    Dim fillId As String
    
    For i = 0 To 4
        ' {x}�N�x�S���Ɩ��v��@�ٓ�
        Set dto = New FieldProperty
        fillId = "jinik_kaito_ido_0" & CStr(i + 1)
'        Call dto.setItem(fillId, "{" & CStr(i) & "}�N�x�S���Ɩ��v��@�ٓ�", CStr(pos + (i * 11) + 0))
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}�N�x�S���Ɩ��v��@�ٓ�", CStr(pos + (i * 11) + 0), "�v����͒�", False, False, -1, "", False)
        Call dto.setRangeCheck(True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�S���Ɩ��v��@�ސE
        Set dto = New FieldProperty
        fillId = "jinik_kaito_taishoku_0" & CStr(i + 1)
'        Call dto.setItem(fillId, "{" & CStr(i) & "}�N�x�S���Ɩ��v��@�ސE", CStr(pos + (i * 11) + 1))
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}�N�x�S���Ɩ��v��@�ސE", CStr(pos + (i * 11) + 1), "�v����͒�", False, False, -1, "", False)
        Call dto.setRangeCheck(True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�S���Ɩ��v��@�S���Ɩ�
        Set dto = New FieldProperty
        fillId = "jinik_kaito_tanto_gyomu_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}�N�x�S���Ɩ��v��@�S���Ɩ�", CStr(pos + (i * 11) + 2), "�v����͒�", False, True, 100, "", False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�ٓ��v��@�ٓ���
        Set dto = New FieldProperty
        fillId = "jinik_kaito_ido_month_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@�ٓ���", CStr(pos + (i * 11) + 3), "�v����͒�", False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dto.setRangeCheck(True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�ٓ��v��@�E��
        Set dto = New FieldProperty
        fillId = "jinik_kaito_shokumu_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@�E��", CStr(pos + (i * 11) + 4), "�v����͒�", False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dto.setRangeCheck(True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�ٓ��v��@���Ə�
        Set dto = New FieldProperty
        fillId = "jinik_kaito_jigyojo_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@���Ə�", CStr(pos + (i * 11) + 5), "�v����͒�", False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dto.setRangeCheck(True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�ٓ��v��@���_
        Set dto = New FieldProperty
        fillId = "jinik_kaito_kyoten_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@���_", CStr(pos + (i * 11) + 6), "�v����͒�", False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dto.setRangeCheck(True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�ٓ��v��@�ٓ��拒�_
        Set dto = New FieldProperty
        fillId = "jinik_kaito_idosaki_kyoten_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@�ٓ��拒�_", CStr(pos + (i * 11) + 7), "�v����͒�", False, True, 100, "", True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�ٓ��v��@�ٓ���̑g�D
        Set dto = New FieldProperty
        fillId = "jinik_kaito_idosaki_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@�ٓ���̑g�D", CStr(pos + (i * 11) + 8), "�v����͒�", False, True, 100, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    
        ' {x}�N�x�ٓ��v��@��C�v��
        Set dto = New FieldProperty
        fillId = "jinik_kaito_konin_youhi_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@��C�v��", CStr(pos + (i * 11) + 9), "�v����͒�", False, False, -1, "jinik_kaito_ido_0" & CStr(i + 1), False)
        Call dto.setRangeCheck(True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
        
        ' {x}�N�x�ٓ��v��@��C�v��
        Set dto = New FieldProperty
        fillId = "jinik_kaito_konin_youken_0" & CStr(i + 1)
        Call dto.setAllProperty(fillId, "{" & CStr(i) & "}�N�x�ٓ��v��@��C�v��", CStr(pos + (i * 11) + 10), "�v����͒�", False, True, 100, "", True)
        Call dic.Add(fillId, dto)
        Set dto = Nothing
    Next i
    
    ' �i����j�S���Ɩ��v��@�ٓ�
    Set dto = New FieldProperty
    Call dto.setItem("jinik_kaito_ido_06", "�i����j�S���Ɩ��v��@�ٓ�", CStr(JINIK_KAITO_IDO_06_CLMN_POS))
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_ido_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@�S���Ɩ�
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_tanto_gyomu_06", "�i����j�S���Ɩ��v��@�S���Ɩ�", CStr(JINIK_KAITO_TANTO_GYOMU_06_CLMN_POS), "�v����͒�", False, True, 100, "", False)
    Call dic.Add("jinik_kaito_tanto_gyomu_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@�E��
    Set dto = New FieldProperty
    Call dto.setItem("jinik_kaito_shokumu_06", "�i����j�ٓ��v��@�E��", CStr(JINIK_KAITO_SHOKUMU_06_CLMN_POS))
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_shokumu_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@���Ə�
    Set dto = New FieldProperty
    Call dto.setItem("jinik_kaito_jigyojo_06", "�i����j�ٓ��v��@���Ə�", CStr(JINIK_KAITO_JIGYOJO_06_CLMN_POS))
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_jigyojo_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@���_
    Set dto = New FieldProperty
    Call dto.setItem("jinik_kaito_kyoten_06", "�i����j�ٓ��v��@���_", CStr(JINIK_KAITO_KYOTEN_06_CLMN_POS))
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_kyoten_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@�ٓ��拒�_
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_idosaki_kyoten_06", "�i����j�ٓ��v��@�ٓ��拒�_", CStr(JINIK_KAITO_IDOSAKI_KYOTEN_06_CLMN_POS), "�v����͒�", False, True, 100, "", True)
    Call dic.Add("jinik_kaito_idosaki_kyoten_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@�ٓ���̑g�D
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_idosaki_06", "�i����j�ٓ��v��@�ٓ���̑g�D", CStr(JINIK_KAITO_IDOSAKI_06_CLMN_POS), "�v����͒�", False, True, 100, "", False)
    Call dic.Add("jinik_kaito_idosaki_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@��C�v��
    Set dto = New FieldProperty
    Call dto.setItem("jinik_kaito_konin_youhi_06", "�i����j�ٓ��v��@��C�v��", CStr(JINIK_KAITO_KONIN_YOUHI_06_CLMN_POS))
    Call dto.setRangeCheck(True)
    Call dic.Add("jinik_kaito_konin_youhi_06", dto)
    Set dto = Nothing
    
    ' �i����j�S���Ɩ��v��@��C�v��
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_konin_youken_06", "�i����j�ٓ��v��@��C�v��", CStr(JINIK_KAITO_KONIN_YOUKEN_06_CLMN_POS), "�v����͒�", False, True, 100, "", True)
    Call dic.Add("jinik_kaito_konin_youken_06", dto)
    Set dto = Nothing
    
    ' ���l
    Set dto = New FieldProperty
    Call dto.setAllProperty("jinik_kaito_other", "���l", CStr(JINIK_KAITO_OTHER_CLMN_POS), "�v����͒�", False, False, 1000, "", False)
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

