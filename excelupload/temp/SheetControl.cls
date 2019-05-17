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

' �R���g�[���[���N���X�̂悤�Ȃ���
' �u�l�ވ琬�v��v�V�[�g�̃r���[��`���i�[���Ă����A�����̐�����s��

Private m_WarnSheetView As WarnSheetView
Private m_JinikSheetView As JinikSheetView
Private m_CheckResultView As CheckResultView
Private m_MasterSheetView As MasterSheetView


' �R���X�g���N�^
Private Sub Class_Initialize()
End Sub

' �f�X�g���N�^
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

' �@�\�F�l�ވ琬�v��V�[�g�̃`�F�b�N���s��
'       ���{�����́A�u�G���[�`�F�b�N���{�v�{�^�����������JinikCheckModule�o�R�ŌĂяo����܂�
' �����F�Ȃ�
' �߂�l�F�G���[�`�F�b�N����
'           0 : �G���[�Ȃ��I��
'           1 : �x������I���i�G���[�͂Ȃ��j
'          -1 : �G���[����I��
Public Function executeSheetCheck() As Long
    Dim ret  As Long: ret = 0

    Dim properties As Dictionary
    Dim jinikData As Dictionary
    Dim checkResults As CheckResultInfo
    
    On Error GoTo executeSheetCheck_Err

    ' �l�ވ琬�v��V�[�g�̍��ڒ�`���擾
    Set properties = getSheetFieldProperties()
    
    ' ���ڒ�`�ɏ]���Ċe���ڂ̏����擾
    Set jinikData = m_JinikSheetView.getSheetContentsFromMapping(properties)

    ' �f�[�^�̃`�F�b�N�����{
    Set checkResults = checkSheetContents(jinikData, properties)
    If checkResults.getCheckErrorCount() = 0 And checkResults.getCheckWarningCount() = 0 Then
        ret = 0
    ElseIf checkResults.getCheckErrorCount() = 0 And checkResults.getCheckWarningCount() > 0 Then
        ret = 1
    ElseIf checkResults.getCheckErrorCount() > 0 Then
        ret = -1
    End If

    ' �`�F�b�N���ʂ��u�`�F�b�N���ʁv�V�[�g�ɏo��
    Call m_CheckResultView.outputCheckResult(checkResults)

    ' �s�v���\�[�X�̉��
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

' �@�\�F�l�ވ琬�v��V�[�g�񓚏������ڂ̃v���p�e�B���ɏ]���ă`�F�b�N���s���i���ۂɏ������s���Ă���̂͂�����j
' �����F
'   jinikSheetData : �l�ވ琬�v��V�[�g�񓚏��
'   properties     : ���ڂ̃v���p�e�B���
' �߂�l�F�`�F�b�N����
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

    ' Dictionary�^�̎��o���́A�i�[��������
    For Each key In jinikSheetData
        Set dto = jinikSheetData.item(key)

        For Each id In dto.getFillData
            data = dto.getFillData.item(id)

            Set propDto = properties.item(id)

            If propDto.isCheck = True Then
                If propDto.CHECK_STATUS = dto.statusName Then
                    ' �K�{�`�F�b�N
                    If propDto.REQUIRED_CHECK = True Then
                        If data(2) = "" Then
                            Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.MISSING_CHECK)
                        End If
                    End If

                    ' �͈̓`�F�b�N
                    If propDto.RANGE_CHECK = True Then
                        If checkRangeValue(CStr(id), CStr(data(2))) = False Then
                            Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.RANGE_CHECK)
                        End If
                    End If

                    ' ���s�`�F�b�N
                    If propDto.CRLF_CHECK = True Then
                        If isExistCrLf(CStr(data(2))) = True Then
                            data(2) = convertCrLfToString(CStr(data(2)), " ")
                            Call m_JinikSheetView.setCellValue(CStr(data(0)), CStr(data(2)))
                            Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.CRLF_CHECK)
                        End If
                    End If

                    ' �����񒷃`�F�b�N
                    If propDto.MAX_LENGTH > 0 Then
                        If Len(data(2)) > propDto.MAX_LENGTH Then
                            Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.LENGTH_CHECK)
                        End If
                    End If

                    ' �����t�����̓`�F�b�N
                    If propDto.COND_REQ_CHECK <> "" Then
                        If checkMissingValueByCondition(dto, CStr(id), propDto.COND_REQ_CHECK) = False Then
                            Call chkResults.addCheckResult(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(id), CStr(data(1)), ERROR_CHECK_TYPE.MISSING_CHECK)
                        End If
                    End If

                    ' �J�X�^���`�F�b�N
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
                                    Call chkResults.addCheckResultWithErrMsg(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(data(1)), CHECK_RESULT_TYPE.TYPE_ERROR, "���Ɋ�E�̂��߁A����ʂ̓����Q��I�����Ă��������B")
                                ElseIf checkTouyoKeikakuSyumushoku(dto) = False Then
                                    Call chkResults.addCheckResultWithErrMsg(CStr(data(0)), dto.OwnGuid, dto.PersonName, CStr(data(1)), CHECK_RESULT_TYPE.TYPE_ERROR, "���Ɏ喱�E�̂��߁A����ʂ̓����Q��I�����Ă��������B")
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

' �@�\�F�����t�������̓`�F�b�N���s��
'       ��3�����Ŏw�肵���`�F�b�N���̉񓚍��ڂ����͍ς݂ł���Ƃ��A��2�����̃`�F�b�N��̉񓚍��ڂɒl�����͂���Ă��邱�Ƃ��`�F�b�N����
' �����F
'   rowData : 1�V�[�g���̉񓚏��iExcel�ł�1�s�j
'   fillId  : �`�F�b�N��̉�ID
'   condId  : �`�F�b�N���̉�ID
' �߂�l�F�`�F�b�N���ʁiTRUE : OK�AFALSE : NG�j
Private Function checkMissingValueByCondition(rowData As JinikSheetInfoDto, fillId As String, condId As String)
    Dim ret As Boolean: ret = True
    Dim condValue As String

    condValue = rowData.getValueByFillId(condId)

    If condId Like "jinik_kaito_ido_0?" And condValue <> "��" Then
        condValue = ""
    End If

    If condValue <> "" Then
        If rowData.getValueByFillId(fillId) = "" Then
            ret = False
        End If
    End If

    checkMissingValueByCondition = ret
End Function

' �@�\�F�����Ŏw�肵���񓚍��ڂ̓��e�iXX�N�x�j�ƑސE�\��N�x�Ƃ��r���A���̌��ʂ�Ԃ�
' �����F
'   rowData : 1�V�[�g���̉񓚏��iExcel�ł�1�s�j
'   fillId  : ��r��̉�ID
' �߂�l�F��r����
'   > 0 : �ސE�\��N�x�̂ق����傫��
'   = 0 : �ސE�\��N�x�Ɠ���
'   < 0 : �ސE�\��N�x�̂ق���������
Private Function compareWithTaishokuYoteiNendo(rowData As JinikSheetInfoDto, fillId As String) As Long
    Dim i As Long
    Dim key As String
    Dim ret As Long: ret = -1
    Dim nendo As String
    Dim taishokuNendo As Long: taishokuNendo = 9999

    ' jinik_kaito_taishoku_01 �` jinik_kaito_taishoku_05�����Ɍ���
    For i = 1 To 5
        key = "jinik_kaito_taishoku_0" & CStr(i)

        If rowData.getValueByFillId(key) = "��" Then
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

' �@�\�F�i�o�C���[�F��v��j�F�苉�̃`�F�b�N���s���i�`�F�b�N���e�͈ȉ��j
'       �u�F�苉�v��������ԁi�F��N�x���󗓈ȊO�j�̂Ƃ��A�Ј������́u�F�苉�v��2���ł���Ƃ��A�u�F�苉�v��2���ł��邱��
' �����F
'   rowData : 1�V�[�g���̉񓚏��iExcel�ł�1�s�j
' �߂�l�F�`�F�b�N���ʁiTRUE : OK�AFALSE : NG�j
Private Function checkBuyerNinteikyu(rowData As JinikSheetInfoDto) As Boolean
    Dim rtn As Boolean: rtn = True
    Dim infoBuyer As String
    Dim kaitoBuyer As String

    infoBuyer = rowData.getValueByFillId("jinik_info_buyer")
    kaitoBuyer = rowData.getValueByFillId("jinik_kaito_buyer_ninteikyu")
    
    If infoBuyer = "2��" And kaitoBuyer = "�o�C���[2��" Then
        rtn = False
    End If

    checkBuyerNinteikyu = rtn
End Function

' �@�\�F�i�o�p�v��j�����Q�̃`�F�b�N���s���i�`�F�b�N���e�͈ȉ��j
'       �u�����Q�v��������ԁi�o�p�N�x���󗓈ȊO�j�̂Ƃ��A�Ј������́u�����Q�v����E�ł���Ƃ��A�u�����Q�v���o�c�E�ł��邱��
' �����F
'   rowData : 1�V�[�g���̉񓚏��iExcel�ł�1�s�j
' �߂�l�F�`�F�b�N���ʁiTRUE : OK�AFALSE : NG�j
Private Function checkTouyoKeikakuKikanshoku(rowData As JinikSheetInfoDto) As Boolean
    Dim ret As Boolean: ret = True
    Dim toukyuGun As String
    Dim touyoKeikakuAttr As String

    ' �Ј������́u�����Q�v�̎擾
    touyoKeikakuAttr = rowData.getValueByFillId("jinik_info_touyo_keikaku")

    ' �i�o�p�v��j�u�����Q�v�̎擾
    toukyuGun = rowData.getValueByFillId("jinik_kaito_touyo_keikaku")

    ' �`�F�b�N
    If touyoKeikakuAttr = "��E" And (toukyuGun = "��E" Or toukyuGun = "�喱�E") Then
        ret = False
    End If

    checkTouyoKeikakuKikanshoku = ret
End Function


' �@�\�F�i�o�p�v��j�����Q�̃`�F�b�N���s���i�`�F�b�N���e�͈ȉ��j
'       �u�����Q�v��������ԁi�o�p�N�x���󗓈ȊO�j�̂Ƃ��A�Ј������́u�����Q�v���喱�E�ł���Ƃ��A�u�����Q�v����E�܂��͌o�c�E�ł��邱��
' �����F
'   rowData : 1�V�[�g���̉񓚏��iExcel�ł�1�s�j
' �߂�l�F�`�F�b�N���ʁiTRUE : OK�AFALSE : NG�j
Private Function checkTouyoKeikakuSyumushoku(rowData As JinikSheetInfoDto) As Boolean
    Dim ret As Boolean: ret = True
    Dim toukyuGun As String
    Dim touyoKeikakuAttr As String

    ' �Ј������́u�����Q�v�̎擾
    touyoKeikakuAttr = rowData.getValueByFillId("jinik_info_touyo_keikaku")

    ' �i�o�p�v��j�u�����Q�v�̎擾
    toukyuGun = rowData.getValueByFillId("jinik_kaito_touyo_keikaku")

    ' �`�F�b�N
    If touyoKeikakuAttr = "�喱�E" And toukyuGun = "�喱�E" Then
        ret = False
    End If

    checkTouyoKeikakuSyumushoku = ret
End Function

' �@�\�F�ٓ��拒�_�̖����̓`�F�b�N���s��
'       �`�F�b�N���e�F���Y�N�x�́u�ٓ��v�Ɂ���A���u���_�v���󗓁A�܂���"�ύX�Ȃ�"�̂Ƃ��A�u�ٓ��拒�_�v�������͂łȂ�����
' �����F
'   rowData : 1�V�[�g���̉񓚏��iExcel�ł�1�s�j
'   fillId  : ��ID�i�u�ٓ��拒�_�v�j
' �߂�l�F�`�F�b�N���ʁiTRUE : OK�AFALSE : NG�j
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

    If idoValue = "��" And (kyotenValue <> "" And kyotenValue <> "�ύX�Ȃ�") Then
        If rowData.getValueByFillId(fillId) = "" Then
            ret = False
        End If
    End If

    checkIdosakiKyoten = ret
End Function

' �@�\�F��C�v���̃`�F�b�N���s��
'       �`�F�b�N���e�F���Y�N�x�́u�ٓ��v�Ɂ���A���u��C�v�ہv��"�v"�̂Ƃ��A�u��C�v���v�������͂łȂ�����
' �����F
'   rowData : 1�V�[�g���̉񓚏��iExcel�ł�1�s�j
'   fillId  : ��ID�i�u��C�v���v�j
' �߂�l�F�`�F�b�N���ʁiTRUE : OK�AFALSE : NG�j
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

    If idoValue = "��" And youhiValue = "�v" Then
        If rowData.getValueByFillId(fillId) = "" Then
            ret = False
        End If
    End If

    checkKouninYouken = ret
End Function

' �@�\�F���s�����̑��݃`�F�b�N���s��
' �����F
'   str : �`�F�b�N���镶��
' �߂�l�F�`�F�b�N���ʁiTRUE : ���s����AFALSE : ���s�Ȃ��j
Private Function isExistCrLf(str As String) As Boolean
    Dim ret As Boolean: ret = False

    ' CR���܂܂�邩�`�F�b�N
    If InStr(str, vbCr) > 0 Then
        ret = True
    End If
    
    ' LF���܂܂�邩�`�F�b�N
    If InStr(str, vbLf) > 0 Then
        ret = True
    End If
    
    ' CRLF���܂܂�邩�`�F�b�N
    If InStr(str, vbCrLf) > 0 Then
        ret = True
    End If
    
    ' CR��LF���܂܂�邩�`�F�b�N
    If InStr(str, vbCr) > 0 And InStr(str, vbLf) > 0 Then
        ret = True
    End If

    isExistCrLf = ret
End Function

' �@�\�F�����񒆂̉��s�������w�肵�������ɒu��������
' �����F
'   target : �u�������Ώۂ̕�����
'   str    : �u�������镶��
' �߂�l�F�u��������������
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