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


' �R���X�g���N�^
Private Sub Class_Initialize()
    Set m_thisWorksheet = Worksheets(MAIN_SHEET_NAME)

End Sub

' �f�X�g���N�^
Private Sub Class_Terminate()
    Set m_thisWorksheet = Nothing

End Sub

' �@�\�F�A�b�v���[�h�ۗ��̕�������擾����
' �����F�Ȃ�
' �߂�l�F�A�b�v���[�h�ە�����
Public Function getUploadStatusString() As String
    getUploadStatusString = m_thisWorksheet.Range(ADDR_UPLOAD_STATUS_TITLE).value
End Function

' �@�\�F�A�b�v���[�h�ۂ̕�������Z�b�g����
' �����F
'   title    : �^�C�g���i"�A�b�v���[�h��" or "�A�b�v���[�h�s��"�j
'   subtitle : �T�u�^�C�g��
' �߂�l�F�Ȃ�
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

' �@�\�F�V�[�g�̔N�x���擾����
' �����F�Ȃ�
' �߂�l�F�V�[�g�̔N�x
Public Property Get SheetNendo() As String
    Dim str As String

    str = m_thisWorksheet.Range(ADDR_SHEET_NENDO).value

    SheetNendo = Replace(str, "�N�x", "")
End Property

' �@�\�F�V�[�g�̕ҏW�ς݂̍ŏI�s���擾����
' �����F�Ȃ�
' �߂�l�F�ҏW�ς݂̍ŏI�s
Private Function getEditedLastRow() As Long
    With m_thisWorksheet
        ' �f�[�^�o�͐擪�ʒu�i"B17"�j��1�s�����ɕҏW�ς݂̍ŏI�s���擾����
        getEditedLastRow = .Range(ADDR_FIRST_JINIK_DATA).Offset(-1, 0).End(xlDown).row
    End With
End Function

' �@�\�F�����Ŏw�肳�ꂽ���Ɋ�Â��ăV�[�g�̒l���擾���AJinikSheetInfoDto�^�̃f�B�N�V���i���I�u�W�F�N�g�ɂ��ĕԂ�
' �����F
'   mapping : ���ڂ̃v���p�e�B���
' �߂�l�F�V�[�g�񓚏��
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

            ' �V�[�g�̔N�x��ݒ�
            dto.SheetNendo = Me.SheetNendo

            For Each key In mapping
                Set prop = mapping.item(key)

                value = getCellValue(i, prop.COLUMN_POS)
                If prop.FILL_ID = "STATUS_NM" Or prop.PHY_COL_NAME = "�X�e�[�^�X" Then
                    dto.statusName = value
                ElseIf prop.FILL_ID = "OWN_GUID" Or prop.PHY_COL_NAME = "GID" Then
                    dto.OwnGuid = value
                ElseIf prop.FILL_ID = "OWN_PERSON_NAME" Or prop.PHY_COL_NAME = "���O" Then
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

' �@�\�F�����Ŏw�肳�ꂽ�Z���ʒu�̒l���擾����
' �����F
'   row    : �s
'   column : ��
' �߂�l�F�Z���̒l
'         ���Z�����g�p�s�i�w�i�F���O���[�j�̂Ƃ��́A�󕶎���Ԃ�
Private Function getCellValue(row As Long, column As Long) As String
    Dim value As String: value = ""

    With m_thisWorksheet.cells(row, column)
        ' �X�e�[�^�X��(B��)����ٓ��v��i���߁j�̌�C�v����(AE��)�܂ł́A�g�p�s�����ǒl���擾����
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

' �@�\�F�w�肳�ꂽ�Z���ʒu�ɒl����������
'       ���{�������Ăяo���ہA�V�[�g�̕ی삪�������Ă��Ȃ����A�������݂ɂ����Change�C�x���g���������邱�Ƃ��l�����邱��
' �����F
'   addr  : �������݃Z���ʒu�iA1�`���j
'   value : �������ޒl
' �߂�l�F�Ȃ�
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
    ' �������߂Ȃ��Ă��Ȃɂ����Ȃ�

End Sub

' �@�\�F�V�[�g�̕ی�/������ݒ肷��
' �����F
'   protect : TRUE : �ی삷��AFALSE : ��������
' �߂�l�F�Ȃ�
Public Sub setSheetProtect(protect As Boolean)

    With m_thisWorksheet
        If protect = True Then
            .protect AllowFormattingColumns:=True, Password:=SHEET_PROTECT_PASSWORD
        Else
            .Unprotect Password:=SHEET_PROTECT_PASSWORD
        End If
    End With
End Sub
