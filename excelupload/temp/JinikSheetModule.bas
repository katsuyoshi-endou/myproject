Attribute VB_Name = "JinikSheetModule"
Option Explicit

' �u�l�ވ琬�v��v�V�[�g�̃V�[�g���̑���i���̓C�x���g�Ȃǁj�Ɋւ��鏈���p�̃��W���[��
' �u�G���[�`�F�b�N���{�v�{�^���������̏����́A�����ɂ͋L�ڂ��Ă��܂���B
' �@�iJinikCheckModule����̏������Q�Ƃ��Ă��������B�j

Public Const COLOR_CELL_REQUIRED As Long = 13353215                         ' RGB(255,192,203) >> 255+192*256+203*256*256
Public Const COLOR_CELL_DISABLED As Long = 12632256                         ' RGB(224,224,224) >> 224+224*256+224*256*256
Public Const COLOR_CELL_OPTION As Long = 13434879                           ' RGB(255,255,204) >> 255+255*256+204*256*256

Public Const COLOR_CELL_CLEAR As Long = 0

' �C�x���g�������K�v�ȃZ����`
' ���ꂼ��̍��ڂ̗�ʒu�i�ԍ��j���J���}��؂�Łi�����ɂ��ASplit�֐��Ŕz��ɕϊ����邽�߁j
Public Const FIELD_IDO_COLUMN_POS As String = "39,50,61,72,83,94"           ' �i�S���Ɩ��v��j�ٓ�
Public Const FIELD_YOTEI_IDO_COLUMN_POS As String = "94"                    ' �i�S���Ɩ��v��j�ٓ��i�\��̂݁j
Public Const FIELD_TAISHOKU_COLUMN_POS As String = "40,51,62,73,84"         ' �i�S���Ɩ��v��j�ސE
Public Const FIELD_KYOTEN_COLUMN_POS As String = "45,56,67,78,89,98"        ' �i�ٓ��v��j���_�i�\��܂ށj
Public Const FIELD_YOUHI_COLUMN_POS As String = "48,59,70,81,92,101"        ' �i�ٓ��v��j��C�v�ہi�\��܂ށj
Public Const FIELD_TANTO_GYOMU_COLUMN_POS As String = "41,52,63,74,85,95"   ' �i�S���Ɩ��v��j�S���Ɩ�

Public Const START_COLUMN_KEIKAKU_AREA As Long = 39                         ' �i�S���Ɩ��E�ٓ��j�v����̓G���A�̊J�n��ʒu
Public Const END_COLUMN_KEIKAKU_AREA As Long = 102                          ' �i�S���Ɩ��E�ٓ��j�v����̓G���A�̏I����ʒu

Private Const JINIK_EDIT_START_CELL As String = "B17"                       ' �ҏW�J�n�ʒu

Private Const JINIK_EDIT_END_COLUMN_POS As Long = 103                       ' �ҏW�ŏI��ʒu


' �ҏW�G���A���̌r���p��`�i�w�肵���Z���̉E�Ɏ����̌r�����������߂̒�`�j
Private Const DEF_RIGHT_BORDER_CELLS As String = "2,3,19,20,23,31,33,35,37,38,41,49,52,60,63,71,74,82,85,93,95,102"


' �e���ڂ́u�ٓ��v���ڂ��猩�����Έʒu�i�\��͏����j
Private Enum REL_POS
    JINIK_KAITO_IDO = 0                         ' �i�S���Ɩ��v��j�u�ٓ��v
    JINIK_KAITO_TAISHOKU = 1                    ' �i�S���Ɩ��v��j�u�ސE�v
    JINIK_KAITO_TANTO_GYOMU = 2                 ' �i�S���Ɩ��v��j�u�S���Ɩ��v
    JINIK_KAITO_IDO_MONTH = 3                   ' �i�ٓ��v��j�u�ٓ����v
    JINIK_KAITO_SHOKUMU = 4                     ' �i�ٓ��v��j�u�E���v
    JINIK_KAITO_JIGYOJO = 5                     ' �i�ٓ��v��j�u���Ə�v
    JINIK_KAITO_KYOTEN = 6                      ' �i�ٓ��v��j�u���_�v
    JINIK_KAITO_IDOSAKI_KYOTEN = 7              ' �i�ٓ��v��j�u�ٓ��拒�_�v
    JINIK_KAITO_IDOSAKI = 8                     ' �i�ٓ��v��j�u�ٓ���̑g�D�v
    JINIK_KAITO_KONIN_YOUHI = 9                 ' �i�ٓ��v��j�u��C�v�ہv
    JINIK_KAITO_KONIN_YOUKEN = 10               ' �i�ٓ��v��j�u��C�v���v
End Enum

' �i�\��́j�e���ڂ́u�ٓ��v���ڂ��猩�����Έʒu�i�u�ސE�v�Ɓu�ٓ����v�Ȃ��j
Private Enum REL_YOTEI_POS
    JINIK_KAITO_IDO = 0                         ' �i�S���Ɩ��v��j�u�ٓ��v
    JINIK_KAITO_TANTO_GYOMU = 1                 ' �i�S���Ɩ��v��j�u�S���Ɩ��v
    JINIK_KAITO_SHOKUMU = 2                     ' �i�ٓ��v��j�u�E���v
    JINIK_KAITO_JIGYOJO = 3                     ' �i�ٓ��v��j�u���Ə�v
    JINIK_KAITO_KYOTEN = 4                      ' �i�ٓ��v��j�u���_�v
    JINIK_KAITO_IDOSAKI_KYOTEN = 5              ' �i�ٓ��v��j�u�ٓ��拒�_�v
    JINIK_KAITO_IDOSAKI = 6                     ' �i�ٓ��v��j�u�ٓ���̑g�D�v
    JINIK_KAITO_KONIN_YOUHI = 7                 ' �i�ٓ��v��j�u��C�v�ہv
    JINIK_KAITO_KONIN_YOUKEN = 8                ' �i�ٓ��v��j�u��C�v���v
End Enum

Public Enum EDIT_TYPE
    CELL_CLEAR = 0                              ' �N���A
    CELL_REQUIRED = 1                           ' ���͕K�{
    CELL_DISABLED = 2                           ' �g�p�s��
    CELL_OPTION = 3                             ' �C�ӓ���
    CELL_ERROR = 9                              ' ���̓G���[
End Enum

Private m_bJinikSheetEdited As Boolean          ' �u�l�ވ琬�v��v�V�[�g���X�V����Ă��邩�iTRUE : �X�V�ς݁AFALSE : ���X�V�j
Private m_bErrChecked As Boolean                ' �G���[�`�F�b�N�����{�ς݂��iTRUE : ���{�AFALSE : �����{�j
                                                ' �`�F�b�N���{��ɃV�[�g�̍X�V������΁A�t���O�̓��Z�b�g����
Private m_bChkRsltSheetEdited As Boolean        ' �u�`�F�b�N���ʁv�V�[�g���X�V����Ă��邩�iTRUE : �X�V�ς݁AFALSE : ���X�V�j

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

' �@�\�F�w�肳�ꂽ�Z���̏����i���b�N�E�w�i�F�j��ݒ肷��
'       ���{�������Ăяo���Ƃ��́A�V�[�g�̕ی삪��������Ă��邱��
' �����F
'   row      : �s
'   column   : ��
'   editType : EDIT_TYPE�i�ҏW��ʁj
' �߂�l�F�Ȃ�
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


' �@�\�F�i�S���Ɩ��v��j�u�ٓ��v�i�\��ȊO�j���ύX���ꂽ�Ƃ��̏���
' �����F
'   row    : �s
'   column : ��
' �߂�l�F�Ȃ�
Public Sub execIdoChangeEvent(row As Long, column As Long)
    Dim value As String

    On Error GoTo execIdoChangeEvent_Err

    ' �i�\��j�u�ٓ��v�̂Ƃ��́A�ʓr��������i���ڂ̓��e�ɈႢ������\��������邽�߁j
    If FIELD_YOTEI_IDO_COLUMN_POS = column Then
        Call execIdoYoteiChangeEvent(row, column)

        Exit Sub
    End If

    With Worksheets(MAIN_SHEET_NAME)
        value = .cells(row, column).value

        If value = "��" Then
            ' �e���ڂɑ΂��Ă��낢�낷��
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

            ' �u���_�v�̕ύX�C�x���g�������������̂悤�ɏ�������
            Call execKyotenChangeEvent(row, column + REL_POS.JINIK_KAITO_KYOTEN)

            ' �u��C�v�ہv�̕ύX�C�x���g�������������̂悤�ɏ�������
            Call execKouninYouhiChangeEvent(row, column + REL_POS.JINIK_KAITO_KONIN_YOUHI)
        Else
            ' �e���ڂɑ΂��Ă��낢�낷��
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

' �@�\�F�i�S���Ɩ��v��j�u�ٓ��v�i�\��j���ύX���ꂽ�Ƃ��̏���
' �����F
'   row    : �s
'   column : ��
' �߂�l�F�Ȃ�
Public Sub execIdoYoteiChangeEvent(row As Long, column As Long)
    Dim value As String

    On Error GoTo execIdoChangeEvent_Err

    With Worksheets(MAIN_SHEET_NAME)
        value = .cells(row, column).value

        If value = "��" Then
            ' �e���ڂɑ΂��Ă��낢�낷��
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_IDO, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_TANTO_GYOMU, EDIT_TYPE.CELL_OPTION)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_SHOKUMU, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_JIGYOJO, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_KYOTEN, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_IDOSAKI_KYOTEN, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_IDOSAKI, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_KONIN_YOUHI, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + REL_YOTEI_POS.JINIK_KAITO_KONIN_YOUKEN, EDIT_TYPE.CELL_DISABLED)

            ' �u���_�v�̕ύX�C�x���g�������������̂悤�ɏ�������
            Call execKyotenChangeEvent(row, column + REL_YOTEI_POS.JINIK_KAITO_KYOTEN)

            ' �u��C�v�ہv�̕ύX�C�x���g�������������̂悤�ɏ�������
            Call execKouninYouhiChangeEvent(row, column + REL_YOTEI_POS.JINIK_KAITO_KONIN_YOUHI)
        Else
            ' �e���ڂɑ΂��Ă��낢�낷��
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

' �@�\�F�i�S���Ɩ��v��j�u�ސE�v���ύX���ꂽ�Ƃ��̏���
' �����F
'   row    : �s
'   column : ��
' �߂�l�F�Ȃ�
Public Sub execTaishokuChangeEvent(row As Long, column As Long)
    Dim value As String

    With Worksheets(MAIN_SHEET_NAME)
        value = .cells(row, column).value

        If value = "��" Then
            ' ��ʒu�̑��Ύw��́A�u�ٓ��v����Ƃ��Ă��邽�߁A�u�ސE�v�̑I������-1����
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
            ' �������񏑎����N���A�������ƁA�u�ٓ��v�A�u���_�v�A�u��C�v�ہv�̕ύX�C�x���g�Ăяo��
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

        ' �ސE�\��҃t���O�̍X�V
        Call setTaishokuYoteiFlag(row, column)
    End With
End Sub

' �@�\�F�i�S���Ɩ��v��j�u�ސE�v���ύX���ꂽ�Ƃ��̓��Y�N�x�ȍ~�̏���
' �����F
'   row     : �s
'   column  : ��
'   retired : �u�ސE�v�`�F�b�N��ԁiTRUE : �u�ސE�v���I�����ꂽ�AFALSE : �u�ސE�v�̑I�����O���ꂽ�j
' �߂�l�F�Ȃ�
Private Sub setAllFieldsPropertyByTaishoku(row As Long, column As Long, retired As Boolean)
    Dim i As Long
    Dim idx As Long
    Dim cols() As String
    Dim bMitei As Boolean: bMitei = False

    On Error GoTo setAllFieldsPropertyByTaishoku_Err

    ' �u�ސE�v�̗�ʒu�𕶎��񂩂�z��ɕϊ�
    cols = Split(FIELD_TAISHOKU_COLUMN_POS, ",")

    ' �ǂ̔N�x��肠�Ƃ���͕s�Ƃ��邩
    For i = 0 To UBound(cols, 1)
        If CLng(cols(i)) > column Then
            idx = CLng(cols(i))
            Exit For
        End If
    Next i

    ' ����̂ЂƂO�̔N�x�ɑސE���ݒ肳�ꂽ�ꍇ
    If idx = 0 And column = JINIK_KAITO_TAISHOKU_05_CLMN_POS Then
        ' ����̏ꍇ�A�u�ٓ��v���̉E�ׂ�ސE���Ƃ݂Ȃ��ď�������
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


' �@�\�F�i�ٓ��v��j�u���_�v���ύX���ꂽ�Ƃ��̏���
' �����F
'   row     : �s
'   column  : ��
' �߂�l�F�Ȃ�
Public Sub execKyotenChangeEvent(row As Long, column As Long)
    Dim kyoten As String

    On Error GoTo execKyotenChangeEvent_Err

    With Worksheets(MAIN_SHEET_NAME)
        kyoten = .cells(row, column).value
        If kyoten = "" Then
            ' �u���_�v���󗓂̂Ƃ��A�u���_�v�͕K�{���͎w��A�ЂƂE�ׂ́u�ٓ��拒�_�v�͎g�p�s�ɂ���
            Call setCellProperty(row, column, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_DISABLED)
        ElseIf kyoten = "�ύX�Ȃ�" Then
            ' �u���_�v��"�ύX�Ȃ�"�̂Ƃ��A�u���_�v�͏����N���A�A�ЂƂE�ׂ́u�ٓ��拒�_�v�͎g�p�s�ɂ���
            Call setCellProperty(row, column, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_DISABLED)
        Else
            Call setCellProperty(row, column, EDIT_TYPE.CELL_CLEAR)

            If .cells(row, column + 1).value = "" Then
                ' �u�ٓ��拒�_�v�������͂Ȃ�K�{���͎w��
                Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_REQUIRED)
            Else
                ' �u�ٓ��拒�_�v�����͍ς݂Ȃ珑���N���A
                Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_CLEAR)
            End If
        End If
    End With

    Exit Sub

execKyotenChangeEvent_Err:
    err.Raise err.Number, "execKyotenChangeEvent", err.Description

End Sub

' �@�\�F�i�ٓ��v��j�u��C�v�ہv���ύX���ꂽ�Ƃ��̏���
' �����F
'   row     : �s
'   column  : ��
' �߂�l�F�Ȃ�
Public Sub execKouninYouhiChangeEvent(row As Long, column As Long)
    Dim value As String

    On Error GoTo execKouninYouhiChangeEvent_Err

    With Worksheets(MAIN_SHEET_NAME)
        value = .cells(row, column).value
        If value = "" Then
            ' �u��C�v�ہv���󗓂̂Ƃ��A�u��C�v�ہv�͕K�{���͎w��A�ЂƂE�ׂ́u��C�v���v�͎g�p�s��
            Call setCellProperty(row, column, EDIT_TYPE.CELL_REQUIRED)
            Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_DISABLED)
        ElseIf value = "�v" Then
            ' �u��C�v�ہv��"�v"�̂Ƃ��A�u��C�v�ہv�͏����N���A�A�ЂƂE�ׂ́u��C�v���v�͓��͏󋵂ɉ����Ďg�p��/�s��
            Call setCellProperty(row, column, EDIT_TYPE.CELL_REQUIRED)

            If .cells(row, column + 1).value = "" Then
                Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_REQUIRED)
            Else
                Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_CLEAR)
            End If
        ElseIf value = "�s�v" Then
            ' �u��C�v�ہv��"�s�v"�̂Ƃ��A�u��C�v�ہv�͏����N���A�A�ЂƂE�ׂ́u��C�v���v�͎g�p�s��
            Call setCellProperty(row, column, EDIT_TYPE.CELL_CLEAR)
            Call setCellProperty(row, column + 1, EDIT_TYPE.CELL_DISABLED)
        End If
    End With

    Exit Sub

execKouninYouhiChangeEvent_Err:
    err.Raise err.Number, "execKouninYouhiChangeEvent", err.Description

End Sub

' �@�\�F�i�S���Ɩ��E�ٓ��j�v����̓G���A���ύX���ꂽ�Ƃ��̏���
'       ���u�ٓ��v�A�u�ސE�v�A�u���_�v�A�u��C�v�ہv�̕ύX�C�x���g�͕ʓr���{�ς�
'       �u�S���Ɩ��v���́A�����ΏۊO�i�ύX�ɔ����g�p��/�s�̐�����s��Ȃ����߁j
' �����F
'   row     : �s
'   column  : ��
' �߂�l�F�Ȃ�
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

' �@�\�F�u�l�ވ琬�v��v�V�[�g�̏���������
'       �E�o�C���[�F��v�旓�̊���/�񊈐��i�Ј������̃o�C���[�F�苉��"1��"�̂Ƃ��A�񊈐��j
'       �E�o�p�v�旓�̊���/�񊈐��i�Ј������̓����Q��"�o�c�E"�̂Ƃ��A�񊈐��j
'   �E���̓C�x���g���Ɠ������e�̊���/�񊈐�������
' �����F�Ȃ�
' �߂�l�F�Ȃ�
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

        ' �u�X�e�[�^�X�v���ɋL�ڂ̂���s��Ώۂ�
        i = 0
        Do Until .Range(JINIK_EDIT_START_CELL).Offset(i, 0).value = ""
            row = .Range(JINIK_EDIT_START_CELL).Offset(i, 0).row

            ' �u�X�e�[�^�X�v������u�ٓ��v��i���߁j��C�v���v�܂ł��g�p�s��
            Call setDisabledCellRanges(row, STATUS_NM_CLMN_POS, JINIK_KAITO_KONIN_YOUKEN_CHOKKIN_CLMN_POS)

            status = .Range(JINIK_EDIT_START_CELL).Offset(i, 0).value
            If status = "�v����͒�" Then
                cols = Split(FIELD_IDO_COLUMN_POS, ",")
                For Each col In cols
                    If .cells(row, CLng(col) + 1).value = "��" Then
                        ' �u�ސE�v��"��"�����Ă���ꍇ
                        Call execTaishokuChangeEvent(row, CLng(col) + 1)

                        Exit For
                    Else
                        Call execIdoChangeEvent(row, CLng(col))
                    End If
                Next

                ' ���݂̒S���Ɩ��̊����E�񊈐�
                Call setFieldAvailable(row, JINIK_KAITO_GENZAI_TANTO_GYOMU_CLMN_POS, EDIT_TYPE.CELL_REQUIRED)

                ' �o�C���[�F�藓�̊����E�񊈐�
                Call setBuyerFieldsAvailable(row)

                ' �o�p�v�旓�̊����E�񊈐�
                Call setTouyoKeikakuAvailable(row)

                ' ���l���̊����E�񊈐�
                Call setFieldAvailable(row, JINIK_KAITO_OTHER_CLMN_POS, EDIT_TYPE.CELL_OPTION)
                
                ' �u�ٓ����сv�����g�p�s��
                Call setDisabledCellRanges(row, JINIK_KAITO_IDO_MONTH_CLMN_POS, JINIK_KAITO_IDO_PLACE_CLMN_POS)

            ElseIf status = "�i���󋵊m�F��" Then
                ' �ٓ����ї��̊����E�񊈐�
                Call setIdoJissekiAavailable(row)

                ' �u�o�C���[�F��v��v������u���l�v�܂ł��g�p�s��
                Call setDisabledCellRanges(row, JINIK_KAITO_BUYER_JIKI_CLMN_POS, JINIK_KAITO_OTHER_CLMN_POS)
            ElseIf status = "�v��m�F��" Or status = "�ٓ��Ȃ�" Or status = "�ٓ���" Or status = "�ΏۊO" Then
                ' ��L�X�e�[�^�X�ȊO�́A���ׂĎg�p�s��
                Call setDisabledCellRanges(row, STATUS_NM_CLMN_POS, JINIK_KAITO_OTHER_CLMN_POS)
            Else
                ' �������Ȃ�
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

' �@�\�F�o�C���[�F�藓�̎g�p�ۂ�ݒ肷��
'       ���V�[�g�X�e�[�^�X������Ƃ��́A���̊֐��̌Ăяo���O�Ŕ��肵�Ă�������
' �����F
'   row     : �s
' �߂�l�F�Ȃ�
Public Sub setBuyerFieldsAvailable(row As Long)
    Dim infoBuyer As String
    Dim kaitoJiki As String
    Dim kaitoNinteikyu As String

    On Error GoTo setBuyerFieldsAvailable_Err

    ' �Ј������̃o�C���[�F������擾����
    With Worksheets(MAIN_SHEET_NAME)
        infoBuyer = .cells(row, JINIK_INFO_BUYER_CLMN_POS).value

        If infoBuyer = "1��" Then
            Call setCellProperty(row, JINIK_KAITO_BUYER_JIKI_CLMN_POS, EDIT_TYPE.CELL_DISABLED)
            Call setCellProperty(row, JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS, EDIT_TYPE.CELL_DISABLED)
        Else
            kaitoJiki = .cells(row, JINIK_KAITO_BUYER_JIKI_CLMN_POS).value
            kaitoNinteikyu = .cells(row, JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS).value
            If .cells(row, JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS).Interior.Color = COLOR_CELL_DISABLED Then
                kaitoNinteikyu = ""
            End If

            If kaitoJiki = "" And kaitoNinteikyu = "" Then
                ' �i�V�[�g�񓚁j�o�C���[�F�肪�Ƃ��ɖ����͂Ȃ�C�ӓ��͏�Ԃ�
                Call setCellProperty(row, JINIK_KAITO_BUYER_JIKI_CLMN_POS, EDIT_TYPE.CELL_OPTION)
                Call setCellProperty(row, JINIK_KAITO_BUYER_NINTEIKYU_CLMN_POS, EDIT_TYPE.CELL_DISABLED)
            ElseIf kaitoJiki <> "" And kaitoNinteikyu = "" Then
                ' �i�V�[�g�񓚁j�o�C���[�F��N�x�����͍ς݁A�F�苉�������͂̂Ƃ��A�F�苉��K�{���͏�Ԃ�
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

' �@�\�F�o�p�v�旓�̎g�p�ۂ�ݒ肷��
'       ���V�[�g�X�e�[�^�X������Ƃ��́A���̊֐��̌Ăяo���O�Ŕ��肵�Ă�������
' �����F
'   row     : �s
' �߂�l�F�Ȃ�
Public Sub setTouyoKeikakuAvailable(row As Long)
    Dim infoTouyoKeikaku As String
    Dim touyoJiki As String
    Dim toukyuGun As String

    On Error GoTo setTouyoKeikakuAvailable_Err

    With Worksheets(MAIN_SHEET_NAME)
        infoTouyoKeikaku = .cells(row, JINIK_INFO_TOUYO_KEIKAKU_CLMN_POS).value

        If infoTouyoKeikaku = "�o�c�E" Then
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

' �@�\�F�ٓ����ї��̎g�p�ۂ�ݒ肷��
'       ���V�[�g�X�e�[�^�X������Ƃ��́A���̊֐��̌Ăяo���O�Ŕ��肵�Ă�������
' �����F
'   row     : �s
' �߂�l�F�Ȃ�
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

' �@�\�F�����Ɏw�肳�ꂽ�ʒu�̍��ڂ̓��͏�Ԃ�ݒ肷��
'       �����Y���ڂɓ��͂���Ă��邩���Ȃ����ł̂ݔ���A�����ڂ͎Q�Ƃ��Ȃ�
' �����F
'   row      : �s
'   column   : ��
'   editType : EDIT_TYPE�i�ҏW��ʁj
' �߂�l�F�Ȃ�
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

' �@�\�F�A�b�v���[�h�ۂ̕�������Z�b�g����
' �����F
'   title    : �^�C�g���i"�A�b�v���[�h��" or "�A�b�v���[�h�s��"�j
'   subtitle : �T�u�^�C�g��
' �߂�l�F�Ȃ�
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

' �@�\�F�l�ވ琬�v��V�[�g�񓚗��̎g�p�s�ƂȂ��Ă���Z���̒l���N���A�i�j���j����
'       ���{�������ł́A�V�[�g�̕ی�̉�����Change�C�x���g�Ȃǂ̃C�x���g���������Ȃ��悤�ɂ��Ă��܂��B
'         �Ăяo�����ɂ͒��ӂ��Ă��������B
' �����F�Ȃ�
' �߂�l�F�Ȃ�
Public Sub clearDataDisabledFields()
    Dim row As Long
    Dim column As Long
    Dim statusName As String

    On Error GoTo clearDataDisabledFields_Err

    With Worksheets(MAIN_SHEET_NAME)
        .Unprotect Password:=SHEET_PROTECT_PASSWORD

        ' �l��j������Ƃ��AWorksheet_change�C�x���g���������Ȃ��悤��
        Application.EnableEvents = False

        row = .Range(ADDR_FIRST_JINIK_DATA).row

        Do Until .cells(row, STATUS_NM_CLMN_POS).value = ""
            statusName = .cells(row, STATUS_NM_CLMN_POS).value

            If statusName = "�v����͒�" Then
                ' �X�e�[�^�X���A"�v����͒�"�̂Ƃ��́A�i�ٓ����сj�u�ٓ����v����N���A����
                For column = JINIK_KAITO_IDO_MONTH_CLMN_POS To JINIK_KAITO_OTHER_CLMN_POS
                    If .cells(row, column).Interior.Color = COLOR_CELL_DISABLED And .cells(row, column).value <> "" Then
                        ' �l�̂݃N���A�i�������͂��̂܂܁j
                        .cells(row, column).ClearContents
                    End If
                Next column
            ElseIf statusName = "�i���󋵊m�F��" Then
                ' �X�e�[�^�X���A"�i���󋵊m�F��"�̂Ƃ��́A�i�ٓ����сj�u�ٓ����v���̂݃N���A����
                For column = JINIK_KAITO_IDO_MONTH_CLMN_POS To JINIK_KAITO_IDO_PLACE_CLMN_POS
                    If .cells(row, column).Interior.Color = COLOR_CELL_DISABLED And .cells(row, column).value <> "" Then
                        ' �l�̂݃N���A�i�������͂��̂܂܁j
                        .cells(row, column).ClearContents
                    End If
                Next column
            Else
                ' ��L�ȊO�͂Ȃɂ����Ȃ��i���̂܂܁j
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

' �@�\�F�ҏW�G���A���Ɍr��������
' �����F
'   lastRow : �ŏI�s�ʒu
' �߂�l�F�Ȃ�
Private Sub drawJinikSheetLines(lastRow As Long)
    Dim i As Long
    Dim editStartRow As Long
    Dim borderCells As Variant

    On Error GoTo drawJinikSheetLines_Err

    With Worksheets(MAIN_SHEET_NAME)
        .Range(.Range(JINIK_EDIT_START_CELL), .cells(lastRow, JINIK_EDIT_END_COLUMN_POS)).Borders(xlDiagonalDown).LineStyle = xlNone
        .Range(.Range(JINIK_EDIT_START_CELL), .cells(lastRow, JINIK_EDIT_END_COLUMN_POS)).Borders(xlDiagonalUp).LineStyle = xlNone

        ' �r���������i�O�r���j
        With .Range(.Range(JINIK_EDIT_START_CELL), .cells(lastRow, JINIK_EDIT_END_COLUMN_POS)).Borders
            .LineStyle = xlContinuous
            .Color = RGB(0, 0, 0)
            .TintAndShade = 0
            .Weight = xlThin
        End With

        ' �r���������i�����̏c�r���j
        With .Range(.Range(JINIK_EDIT_START_CELL), .cells(lastRow, JINIK_EDIT_END_COLUMN_POS)).Borders(xlInsideVertical)
            .LineStyle = xlContinuous
            .Color = RGB(0, 0, 0)
            .TintAndShade = -0.14996795556505
            .Weight = xlHairline
        End With

        borderCells = Split(DEF_RIGHT_BORDER_CELLS, ",")

        ' �w�肵���Z���̉E���Ɍr���i�����j������
        editStartRow = .Range(JINIK_EDIT_START_CELL).row
        For i = 0 To UBound(borderCells, 1)
            With .Range(.cells(editStartRow, CLng(borderCells(i))), .cells(lastRow, CLng(borderCells(i)))).Borders(xlEdgeRight)
                .LineStyle = xlContinuous
                .Color = RGB(0, 0, 0)
                .TintAndShade = 0
                .Weight = xlThin
            End With
        Next i

        ' �w�肵���͈͓��̐����r���i�_���j������
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

' �@�\�F���N�x����ю��N�x�́u�ސE�v���ڂ����삳�ꂽ�Ƃ��A�u�ސE�\��҃t���O�v�̍X�V���s��
' �����F
'   row    : �s�ʒu
'   column : ��ʒu
' �߂�l�F�Ȃ�
Private Sub setTaishokuYoteiFlag(row As Long, column As Long)
    Dim curNendoTaishoku As String
    Dim nextNendoTaishoku As String

    ' ���N�x�Ǝ��N�x�́u�ސE�v�Z���ɑ΂��鑀��̂Ƃ�
    If column = JINIK_KAITO_TAISHOKU_01_CLMN_POS Or column = JINIK_KAITO_TAISHOKU_02_CLMN_POS Then
        With Worksheets(MAIN_SHEET_NAME)
            curNendoTaishoku = .cells(row, JINIK_KAITO_TAISHOKU_01_CLMN_POS).value
            nextNendoTaishoku = .cells(row, JINIK_KAITO_TAISHOKU_02_CLMN_POS).value

            If curNendoTaishoku = "��" Or nextNendoTaishoku = "��" Then
                .cells(row, JINIK_ICHIRAN_TAISHOKU_YOTEI_FLG_POS) = "1"
            Else
                .cells(row, JINIK_ICHIRAN_TAISHOKU_YOTEI_FLG_POS) = "0"
            End If
        End With
    End If
End Sub

' �@�\�F�Ƃ���s�̎w��͈͂��g�p�s�ɐݒ肷��
' �����F
'   row        : �s�ʒu
'   fromColumn : �J�n��ʒu
'   toColumn   : �I����ʒu
' �߂�l�F�Ȃ�
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



