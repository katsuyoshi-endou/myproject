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

' �u�l�ވ琬�v��v�V�[�g�r���[�N���X

Private m_thisWorksheet As Worksheet


' �N���X���萔��`
Private Const ADDR_UPLOAD_STATUS_TITLE As String = "B4"             ' �A�b�v���[�h��/�s�̃Z���ʒu
Private Const ADDR_UPLOAD_STATUS_SUB_TITLE As String = "B7"         ' �A�b�v���[�h��/�s�̃T�u�^�C�g���̃Z���ʒu
Private Const ADDR_FIRST_JINIK_DATA As String = "B17"               ' �l�ވ琬�v��f�[�^�擪�ʒu
Private Const ADDR_LAST_JINIK_DATA As String = "CY17"               ' �l�ވ琬�v��f�[�^�I���ʒu
Private Const ADDR_SHEET_NENDO As String = "AM13"                   ' �V�[�g�̔N�x�������Ă���ʒu

' ���̑���`
Private m_fieldMapping(93, 2) As String


' �R���X�g���N�^
Private Sub Class_Initialize()
    Set m_thisWorksheet = Worksheets(MAIN_SHEET_NAME)

    ' ���ڂ̃}�b�s���O���쐬
    Call intialFieldMapping
End Sub

' �f�X�g���N�^
Private Sub Class_Terminate()
    Set m_thisWorksheet = Nothing

End Sub

Public Function getUploadStatusString() As String
    getUploadStatusString = m_thisWorksheet.Range(ADDR_UPLOAD_STATUS_TITLE).value
End Function

Public Sub setUploadStatusString(title As String, subtitle As String)
    m_thisWorksheet.Range(ADDR_UPLOAD_STATUS_TITLE).value = title
    m_thisWorksheet.Range(ADDR_UPLOAD_STATUS_SUB_TITLE).value = subtitle
End Sub

Public Property Get getSheetNendo() As String
    Dim str As String

    str = m_thisWorksheet.Range(ADDR_SHEET_NENDO).value

    getSheetNendo = Replace(str, "�N�x", "")
End Property

' *************************************
'  �V�[�g�̕ҏW�ς݂̍ŏI�s���擾����
' *************************************
Private Function getEditedLastRow() As Long
    With m_thisWorksheet
        ' �f�[�^�o�͐擪�ʒu�i"B17"�j��1�s�����ɕҏW�ς݂̍ŏI�s���擾����
'        getEditedLastRow = .Range(.Range(ADDR_FIRST_JINIK_DATA).Offset(-1, 0).Cells).End(xlDown).row
        getEditedLastRow = .Range(ADDR_FIRST_JINIK_DATA).Offset(-1, 0).End(xlDown).row
    End With
End Function


' ************************************************
'  �V�[�g�S�̂�2�����z��Ƃ��ă�������Ɋm�ۂ���
' ************************************************
Public Function getSheetContentsToArray() As Variant
    Dim maxRow As Long
    Dim maxCol As Long

    With m_thisWorksheet
        maxRow = getEditedLastRow()

        maxCol = .Range(ADDR_LAST_JINIK_DATA).Offset(maxRow, 0).Cells.COLUMN

        ' �V�[�g�̉E�ォ��ҏW�ς݃G���A�̉E���܂ł�Ǎ���
        getSheetContentsToArray = .Range(.Cells(1, 1), .Cells(maxRow, maxCol))
    End With
End Function

' *********************************************************************
'  �V�[�g�̓��e��JinikSheetInfoDto ��Dictionary�I�u�W�F�N�g�Ƃ��ĕԂ�
' *********************************************************************
Public Function getSheetContentsToDataObject() As Dictionary
    Dim i, j As Long
    Dim value As String
    Dim fieldNm As String
    Dim address As String
    Dim sheetNendo As String

    Dim dto As JinikSheetInfoDto
    Dim retObj As Dictionary
    Dim arrayData As Variant

    On Error GoTo getSheetContentsToDataObject_Err

    arrayData = getSheetContentsToArray()

    Set retObj = New Dictionary

    sheetNendo = Me.getSheetNendo()

    For i = m_thisWorksheet.Range(ADDR_FIRST_JINIK_DATA).row To UBound(arrayData, 1)
        Set dto = New JinikSheetInfoDto

        dto.setSheetNendo = sheetNendo

        For j = 0 To UBound(m_fieldMapping, 1)
            value = arrayData(i, CInt(m_fieldMapping(j, 0)))
            fieldNm = m_fieldMapping(j, 1)

            Select Case fieldNm
                Case "STATUS_NM"
                    dto.setStatusNm = value
                Case "OWN_GUID"
                    dto.setGuid = value
                Case "OWN_PERSON_NAME"
                    dto.setPersonName = value
                Case "FULL_DEPT_NAME"
'                    dto.setFullDeptNm = value
                Case Else
                    address = Replace(CStr(m_thisWorksheet.Range("A1").Offset(i - 1, j).address), "$", "")

                    Call dto.addSheetFillData(fieldNm, address, m_fieldMapping(j, 2), value)
            End Select
        Next

        Call retObj.Add(i, dto)

        Set dto = Nothing
    Next

    Set getSheetContentsToDataObject = retObj

    Exit Function

getSheetContentsToDataObject_Err:
    err.Raise err.Number, "getSheetContentsToDataObject", err.Description

End Function

Public Function getEditedContentsRows() As Range
    Dim row As Long
    Dim rowRange As String

    On Error GoTo getEditedContentsRows_Err
    
    row = getEditedLastRow
    
    If m_thisWorksheet.Range(ADDR_FIRST_JINIK_DATA).row > row Then
        Set getEditedContentsRows = Nothing
        Exit Function
    End If
    
    rowRange = m_thisWorksheet.Range(ADDR_FIRST_JINIK_DATA).row & ":" & row
        
    Set getEditedContentsRows = m_thisWorksheet.Range(rowRange)

    Exit Function

getEditedContentsRows_Err:
    err.Raise err.Number, "getEditedContentsRows", err.Description

End Function

Public Function getSheetContentsFromMapping(mapping As Dictionary) As Dictionary
    Dim i As Long
    Dim value As String
    Dim address As String
    Dim key As Variant
    Dim arrayData As Variant
    Dim prop As FieldProperty
    Dim dto As JinikSheetInfoDto
    Dim retObj As Dictionary

    On Error GoTo getSheetContentsFromMapping_Err

    arrayData = getSheetContentsToArray

    Set retObj = New Dictionary

    With m_thisWorksheet
        For i = .Range(ADDR_FIRST_JINIK_DATA).row To UBound(arrayData, 1)
            Set dto = New JinikSheetInfoDto

            ' �V�[�g�̔N�x��ݒ�
            dto.setSheetNendo = Replace(.Range(ADDR_SHEET_NENDO).value, "�N�x", "")

            For Each key In mapping
                Set prop = mapping.item(key)

                value = arrayData(i, prop.COLUMN_POS)
                If prop.FILL_ID = "STATUS_NM" Or prop.PHY_COL_NAME = "�X�e�[�^�X" Then
                    dto.setStatusNm = value
                ElseIf prop.FILL_ID = "OWN_GUID" Or prop.PHY_COL_NAME = "GID" Then
                    dto.setGuid = value
                ElseIf prop.FILL_ID = "OWN_PERSON_NAME" Or prop.PHY_COL_NAME = "���O" Then
                    dto.setPersonName = value
                Else
                    address = Replace(CStr(.Range("A1").Offset(i - 1, prop.COLUMN_POS - 1).address), "$", "")

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
    err.Raise err.Number, "getSheetContentsFromMapping", err.Description

End Function

' *********************************************************************************
'  �V�[�g�̏���ǂݎ�邽�߂̍��ڂ̃}�b�s���O�i��ʒu�ƍ��ږ�orFILL-Id�j
'  �z�񂪒萔�Œ�`�ł��Ȃ��̂ŃN���X�̃R���X�g���N�^���珉���������Ƃ��ČĂяo��
' *********************************************************************************
Private Sub intialFieldMapping()
    m_fieldMapping(0, 0) = "2"
    m_fieldMapping(0, 1) = "STATUS_NM"
    m_fieldMapping(0, 2) = "�X�e�[�^�X"
    m_fieldMapping(1, 0) = "3"
    m_fieldMapping(1, 1) = "jinik_chohyo_taishoku_nendo"
    m_fieldMapping(1, 2) = "�ސE�\��N�x"
    m_fieldMapping(2, 0) = "4"
    m_fieldMapping(2, 1) = "OWN_GUID"
    m_fieldMapping(2, 2) = "GID"
    m_fieldMapping(3, 0) = "5"
    m_fieldMapping(3, 1) = "OWN_PERSON_NAME"
    m_fieldMapping(3, 2) = "���O"
    m_fieldMapping(4, 0) = "6"
    m_fieldMapping(4, 1) = "FULL_DEPT_NM"
    m_fieldMapping(4, 2) = "�����g�D"
    m_fieldMapping(5, 0) = "7"
    m_fieldMapping(5, 1) = "jinik_info_birth"
    m_fieldMapping(5, 2) = "���N����"
    m_fieldMapping(6, 0) = "8"
    m_fieldMapping(6, 1) = "jinik_info_age"
    m_fieldMapping(6, 2) = "4���N��"
    m_fieldMapping(7, 0) = "9"
    m_fieldMapping(7, 1) = "jinik_info_sex"
    m_fieldMapping(7, 2) = "����"
    m_fieldMapping(8, 0) = "10"
    m_fieldMapping(8, 1) = "jinik_info_gkrk"
    m_fieldMapping(8, 2) = "�w��"
    m_fieldMapping(9, 0) = "11"
    m_fieldMapping(9, 1) = "jinik_info_sotsunen"
    m_fieldMapping(9, 2) = "���N"
    m_fieldMapping(10, 0) = "12"
    m_fieldMapping(10, 1) = "jinik_info_nyusha"
    m_fieldMapping(10, 2) = "���ДN"
    m_fieldMapping(11, 0) = "13"
    m_fieldMapping(11, 1) = "jinik_info_touyo_keikaku"
    m_fieldMapping(11, 2) = "�����Q"
    m_fieldMapping(12, 0) = "14"
    m_fieldMapping(12, 1) = "jinik_info_tokyu"
    m_fieldMapping(12, 2) = "����"
    m_fieldMapping(13, 0) = "15"
    m_fieldMapping(13, 1) = "jinik_ichiran_yksk"
    m_fieldMapping(13, 2) = "��E"
    m_fieldMapping(14, 0) = "16"
    m_fieldMapping(14, 1) = "jinik_kaito_yksk_bnri"
    m_fieldMapping(14, 2) = "��E����"
    m_fieldMapping(15, 0) = "17"
    m_fieldMapping(15, 1) = "jinik_ichiran_shain_kbn"
    m_fieldMapping(15, 2) = "�Ј��敪"
    m_fieldMapping(16, 0) = "18"
    m_fieldMapping(16, 1) = "jinik_ichiran_chotatsu_wariai"
    m_fieldMapping(16, 2) = "���B�Ɩ�����(%)"
    m_fieldMapping(17, 0) = "19"
    m_fieldMapping(17, 1) = "jinik_info_buyer"
    m_fieldMapping(17, 2) = "�o�C���[�F��"
    m_fieldMapping(18, 0) = "20"
    m_fieldMapping(18, 1) = "jinik_kaito_rotation"
    m_fieldMapping(18, 2) = "���ДN��"
    m_fieldMapping(19, 0) = "21"
    m_fieldMapping(19, 1) = "jinik_ichiran_gyomu_kaisi"
    m_fieldMapping(19, 2) = "�Ɩ��J�n�N��"
    m_fieldMapping(20, 0) = "22"
    m_fieldMapping(20, 1) = "jinik_kaito_keika_nen"
    m_fieldMapping(20, 2) = "�o�ߔN(4/1���_)"
    m_fieldMapping(21, 0) = "23"
    m_fieldMapping(21, 1) = "jinik_chohyo_doitsu_gyomu_kbn"
    m_fieldMapping(21, 2) = "�敪"
    m_fieldMapping(22, 0) = "32"
    m_fieldMapping(22, 1) = "jinik_kaito_ido_month"
    m_fieldMapping(22, 2) = "�ٓ���"
    m_fieldMapping(23, 0) = "33"
    m_fieldMapping(23, 1) = "jinik_kaito_ido_place"
    m_fieldMapping(23, 2) = "�ٓ���̑g�D"
    m_fieldMapping(24, 0) = "34"
    m_fieldMapping(24, 1) = "jinik_kaito_buyer_jiki"
    m_fieldMapping(24, 2) = "�o�C���[�F��v��@�F��N�x"
    m_fieldMapping(25, 0) = "35"
    m_fieldMapping(25, 1) = "jinik_kaito_buyer_ninteikyu"
    m_fieldMapping(25, 2) = "�o�C���[�F��v��@�F�苉"
    m_fieldMapping(26, 0) = "36"
    m_fieldMapping(26, 1) = "jinik_kaito_touyo_jiki"
    m_fieldMapping(26, 2) = "�o�p�v��@�o�p�N�x"
    m_fieldMapping(27, 0) = "37"
    m_fieldMapping(27, 1) = "jinik_kaito_touyo_keikaku"
    m_fieldMapping(27, 2) = "�o�p�v��@�����Q"
    m_fieldMapping(28, 0) = "38"
    m_fieldMapping(28, 1) = "jinik_kaito_genzai_tanto_gyomu"
    m_fieldMapping(28, 2) = "���݂̒S���Ɩ�"
    m_fieldMapping(29, 0) = "39"
    m_fieldMapping(29, 1) = "jinik_kaito_ido_01"
    m_fieldMapping(29, 2) = "{0}�N�x�S���Ɩ��v��@�ٓ�"
    m_fieldMapping(30, 0) = "40"
    m_fieldMapping(30, 1) = "jinik_kaito_taishoku_01"
    m_fieldMapping(30, 2) = "{0}�N�x�S���Ɩ��v��@�ސE"
    m_fieldMapping(31, 0) = "41"
    m_fieldMapping(31, 1) = "jinik_kaito_tanto_gyomu_01"
    m_fieldMapping(31, 2) = "{0}�N�x�S���Ɩ��v��@�S���Ɩ�"
    m_fieldMapping(32, 0) = "42"
    m_fieldMapping(32, 1) = "jinik_kaito_ido_month_01"
    m_fieldMapping(32, 2) = "{0}�N�x�ٓ��v��@�ٓ���"
    m_fieldMapping(33, 0) = "43"
    m_fieldMapping(33, 1) = "jinik_kaito_shokumu_01"
    m_fieldMapping(33, 2) = "{0}�N�x�ٓ��v��@�E��"
    m_fieldMapping(34, 0) = "44"
    m_fieldMapping(34, 1) = "jinik_kaito_jigyojo_01"
    m_fieldMapping(34, 2) = "{0}�N�x�ٓ��v��@���Ə�"
    m_fieldMapping(35, 0) = "45"
    m_fieldMapping(35, 1) = "jinik_kaito_kyoten_01"
    m_fieldMapping(35, 2) = "{0}�N�x�ٓ��v��@���_"
    m_fieldMapping(36, 0) = "46"
    m_fieldMapping(36, 1) = "jinik_kaito_idosaki_kyoten_01"
    m_fieldMapping(36, 2) = "{0}�N�x�ٓ��v��@�ٓ��拒�_"
    m_fieldMapping(37, 0) = "47"
    m_fieldMapping(37, 1) = "jinik_kaito_idosaki_01"
    m_fieldMapping(37, 2) = "{0}�N�x�ٓ��v��@�ٓ���̑g�D"
    m_fieldMapping(38, 0) = "48"
    m_fieldMapping(38, 1) = "jinik_kaito_konin_youhi_01"
    m_fieldMapping(38, 2) = "{0}�N�x�ٓ��v��@��C�v��"
    m_fieldMapping(39, 0) = "49"
    m_fieldMapping(39, 1) = "jinik_kaito_konin_youken_01"
    m_fieldMapping(39, 2) = "{0}�N�x�ٓ��v��@��C�v��"
    m_fieldMapping(40, 0) = "50"
    m_fieldMapping(40, 1) = "jinik_kaito_ido_02"
    m_fieldMapping(40, 2) = "{0}�N�x�S���Ɩ��v��@�ٓ�"
    m_fieldMapping(41, 0) = "51"
    m_fieldMapping(41, 1) = "jinik_kaito_taishoku_02"
    m_fieldMapping(41, 2) = "{0}�N�x�S���Ɩ��v��@�ސE"
    m_fieldMapping(42, 0) = "52"
    m_fieldMapping(42, 1) = "jinik_kaito_tanto_gyomu_02"
    m_fieldMapping(42, 2) = "{0}�N�x�S���Ɩ��v��@�S���Ɩ�"
    m_fieldMapping(43, 0) = "53"
    m_fieldMapping(43, 1) = "jinik_kaito_ido_month_02"
    m_fieldMapping(43, 2) = "{0}�N�x�ٓ��v��@�ٓ���"
    m_fieldMapping(44, 0) = "54"
    m_fieldMapping(44, 1) = "jinik_kaito_shokumu_02"
    m_fieldMapping(44, 2) = "{0}�N�x�ٓ��v��@�E��"
    m_fieldMapping(45, 0) = "55"
    m_fieldMapping(45, 1) = "jinik_kaito_jigyojo_02"
    m_fieldMapping(45, 2) = "{0}�N�x�ٓ��v��@���Ə�"
    m_fieldMapping(46, 0) = "56"
    m_fieldMapping(46, 1) = "jinik_kaito_kyoten_02"
    m_fieldMapping(46, 2) = "{0}�N�x�ٓ��v��@���_"
    m_fieldMapping(47, 0) = "57"
    m_fieldMapping(47, 1) = "jinik_kaito_idosaki_kyoten_02"
    m_fieldMapping(47, 2) = "{0}�N�x�ٓ��v��@�ٓ��拒�_"
    m_fieldMapping(48, 0) = "58"
    m_fieldMapping(48, 1) = "jinik_kaito_idosaki_02"
    m_fieldMapping(48, 2) = "{0}�N�x�ٓ��v��@�ٓ���̑g�D"
    m_fieldMapping(49, 0) = "59"
    m_fieldMapping(49, 1) = "jinik_kaito_konin_youhi_02"
    m_fieldMapping(49, 2) = "{0}�N�x�ٓ��v��@��C�v��"
    m_fieldMapping(50, 0) = "60"
    m_fieldMapping(50, 1) = "jinik_kaito_konin_youken_02"
    m_fieldMapping(50, 2) = "{0}�N�x�ٓ��v��@��C�v��"
    m_fieldMapping(51, 0) = "61"
    m_fieldMapping(51, 1) = "jinik_kaito_ido_03"
    m_fieldMapping(51, 2) = "{0}�N�x�S���Ɩ��v��@�ٓ�"
    m_fieldMapping(52, 0) = "62"
    m_fieldMapping(52, 1) = "jinik_kaito_taishoku_03"
    m_fieldMapping(52, 2) = "{0}�N�x�S���Ɩ��v��@�ސE"
    m_fieldMapping(53, 0) = "63"
    m_fieldMapping(53, 1) = "jinik_kaito_tanto_gyomu_03"
    m_fieldMapping(53, 2) = "{0}�N�x�S���Ɩ��v��@�S���Ɩ�"
    m_fieldMapping(54, 0) = "64"
    m_fieldMapping(54, 1) = "jinik_kaito_ido_month_03"
    m_fieldMapping(54, 2) = "{0}�N�x�ٓ��v��@�ٓ���"
    m_fieldMapping(55, 0) = "65"
    m_fieldMapping(55, 1) = "jinik_kaito_shokumu_03"
    m_fieldMapping(55, 2) = "{0}�N�x�ٓ��v��@�E��"
    m_fieldMapping(56, 0) = "66"
    m_fieldMapping(56, 1) = "jinik_kaito_jigyojo_03"
    m_fieldMapping(56, 2) = "{0}�N�x�ٓ��v��@���Ə�"
    m_fieldMapping(57, 0) = "67"
    m_fieldMapping(57, 1) = "jinik_kaito_kyoten_03"
    m_fieldMapping(57, 2) = "{0}�N�x�ٓ��v��@���_"
    m_fieldMapping(58, 0) = "68"
    m_fieldMapping(58, 1) = "jinik_kaito_idosaki_kyoten_03"
    m_fieldMapping(58, 2) = "{0}�N�x�ٓ��v��@�ٓ��拒�_"
    m_fieldMapping(59, 0) = "69"
    m_fieldMapping(59, 1) = "jinik_kaito_idosaki_03"
    m_fieldMapping(59, 2) = "{0}�N�x�ٓ��v��@�ٓ���̑g�D"
    m_fieldMapping(60, 0) = "70"
    m_fieldMapping(60, 1) = "jinik_kaito_konin_youhi_03"
    m_fieldMapping(60, 2) = "{0}�N�x�ٓ��v��@��C�v��"
    m_fieldMapping(61, 0) = "71"
    m_fieldMapping(61, 1) = "jinik_kaito_konin_youken_03"
    m_fieldMapping(61, 2) = "{0}�N�x�ٓ��v��@��C�v��"
    m_fieldMapping(62, 0) = "72"
    m_fieldMapping(62, 1) = "jinik_kaito_ido_04"
    m_fieldMapping(62, 2) = "{0}�N�x�S���Ɩ��v��@�ٓ�"
    m_fieldMapping(63, 0) = "73"
    m_fieldMapping(63, 1) = "jinik_kaito_taishoku_04"
    m_fieldMapping(63, 2) = "{0}�N�x�S���Ɩ��v��@�ސE"
    m_fieldMapping(64, 0) = "74"
    m_fieldMapping(64, 1) = "jinik_kaito_tanto_gyomu_04"
    m_fieldMapping(64, 2) = "{0}�N�x�S���Ɩ��v��@�S���Ɩ�"
    m_fieldMapping(65, 0) = "75"
    m_fieldMapping(65, 1) = "jinik_kaito_ido_month_04"
    m_fieldMapping(65, 2) = "{0}�N�x�ٓ��v��@�ٓ���"
    m_fieldMapping(66, 0) = "76"
    m_fieldMapping(66, 1) = "jinik_kaito_shokumu_04"
    m_fieldMapping(66, 2) = "{0}�N�x�ٓ��v��@�E��"
    m_fieldMapping(67, 0) = "77"
    m_fieldMapping(67, 1) = "jinik_kaito_jigyojo_04"
    m_fieldMapping(67, 2) = "{0}�N�x�ٓ��v��@���Ə�"
    m_fieldMapping(68, 0) = "78"
    m_fieldMapping(68, 1) = "jinik_kaito_kyoten_04"
    m_fieldMapping(68, 2) = "{0}�N�x�ٓ��v��@���_"
    m_fieldMapping(69, 0) = "79"
    m_fieldMapping(69, 1) = "jinik_kaito_idosaki_kyoten_04"
    m_fieldMapping(69, 2) = "{0}�N�x�ٓ��v��@�ٓ��拒�_"
    m_fieldMapping(70, 0) = "80"
    m_fieldMapping(70, 1) = "jinik_kaito_idosaki_04"
    m_fieldMapping(70, 2) = "{0}�N�x�ٓ��v��@�ٓ���̑g�D"
    m_fieldMapping(71, 0) = "81"
    m_fieldMapping(71, 1) = "jinik_kaito_konin_youhi_04"
    m_fieldMapping(71, 2) = "{0}�N�x�ٓ��v��@��C�v��"
    m_fieldMapping(72, 0) = "82"
    m_fieldMapping(72, 1) = "jinik_kaito_konin_youken_04"
    m_fieldMapping(72, 2) = "{0}�N�x�ٓ��v��@��C�v��"
    m_fieldMapping(73, 0) = "83"
    m_fieldMapping(73, 1) = "jinik_kaito_ido_05"
    m_fieldMapping(73, 2) = "{0}�N�x�S���Ɩ��v��@�ٓ�"
    m_fieldMapping(74, 0) = "84"
    m_fieldMapping(74, 1) = "jinik_kaito_taishoku_05"
    m_fieldMapping(74, 2) = "{0}�N�x�S���Ɩ��v��@�ސE"
    m_fieldMapping(75, 0) = "85"
    m_fieldMapping(75, 1) = "jinik_kaito_tanto_gyomu_05"
    m_fieldMapping(75, 2) = "{0}�N�x�S���Ɩ��v��@�S���Ɩ�"
    m_fieldMapping(76, 0) = "86"
    m_fieldMapping(76, 1) = "jinik_kaito_ido_month_05"
    m_fieldMapping(76, 2) = "{0}�N�x�ٓ��v��@�ٓ���"
    m_fieldMapping(77, 0) = "87"
    m_fieldMapping(77, 1) = "jinik_kaito_shokumu_05"
    m_fieldMapping(77, 2) = "{0}�N�x�ٓ��v��@�E��"
    m_fieldMapping(78, 0) = "88"
    m_fieldMapping(78, 1) = "jinik_kaito_jigyojo_05"
    m_fieldMapping(78, 2) = "{0}�N�x�ٓ��v��@���Ə�"
    m_fieldMapping(79, 0) = "89"
    m_fieldMapping(79, 1) = "jinik_kaito_kyoten_05"
    m_fieldMapping(79, 2) = "{0}�N�x�ٓ��v��@���_"
    m_fieldMapping(80, 0) = "90"
    m_fieldMapping(80, 1) = "jinik_kaito_idosaki_kyoten_05"
    m_fieldMapping(80, 2) = "{0}�N�x�ٓ��v��@�ٓ��拒�_"
    m_fieldMapping(81, 0) = "91"
    m_fieldMapping(81, 1) = "jinik_kaito_idosaki_05"
    m_fieldMapping(81, 2) = "{0}�N�x�ٓ��v��@�ٓ���̑g�D"
    m_fieldMapping(82, 0) = "92"
    m_fieldMapping(82, 1) = "jinik_kaito_konin_youhi_05"
    m_fieldMapping(82, 2) = "{0}�N�x�ٓ��v��@��C�v��"
    m_fieldMapping(83, 0) = "93"
    m_fieldMapping(83, 1) = "jinik_kaito_konin_youken_05"
    m_fieldMapping(83, 2) = "{0}�N�x�ٓ��v��@��C�v��"
    m_fieldMapping(84, 0) = "94"
    m_fieldMapping(84, 1) = "jinik_kaito_ido_06"
    m_fieldMapping(84, 2) = "�i����j�S���Ɩ��v��@�ٓ�"
    m_fieldMapping(85, 0) = "95"
    m_fieldMapping(85, 1) = "jinik_kaito_tanto_gyomu_06"
    m_fieldMapping(85, 2) = "�i����j�S���Ɩ��v��@�S���Ɩ�"
    m_fieldMapping(86, 0) = "96"
    m_fieldMapping(86, 1) = "jinik_kaito_shokumu_06"
    m_fieldMapping(86, 2) = "�i����j�N�x�ٓ��v��@�E��"
    m_fieldMapping(87, 0) = "97"
    m_fieldMapping(87, 1) = "jinik_kaito_jigyojo_06"
    m_fieldMapping(87, 2) = "�i����j�N�x�ٓ��v��@���Ə�"
    m_fieldMapping(88, 0) = "98"
    m_fieldMapping(88, 1) = "jinik_kaito_kyoten_06"
    m_fieldMapping(88, 2) = "�i����j�N�x�ٓ��v��@���_"
    m_fieldMapping(89, 0) = "99"
    m_fieldMapping(89, 1) = "jinik_kaito_idosaki_kyoten_06"
    m_fieldMapping(89, 2) = "�i����j�ٓ��v��@�ٓ��拒�_"
    m_fieldMapping(90, 0) = "100"
    m_fieldMapping(90, 1) = "jinik_kaito_idosaki_06"
    m_fieldMapping(90, 2) = "�i����j�ٓ��v��@�ٓ���̑g�D"
    m_fieldMapping(91, 0) = "101"
    m_fieldMapping(91, 1) = "jinik_kaito_konin_youhi_06"
    m_fieldMapping(91, 2) = "�i����j�ٓ��v��@��C�v��"
    m_fieldMapping(92, 0) = "102"
    m_fieldMapping(92, 1) = "jinik_kaito_konin_youken_06"
    m_fieldMapping(92, 2) = "�i����j�ٓ��v��@��C�v��"
    m_fieldMapping(93, 0) = "103"
    m_fieldMapping(93, 1) = "jinik_kaito_other"
    m_fieldMapping(93, 2) = "���l"
End Sub