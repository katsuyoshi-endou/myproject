VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CheckResultView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' �u�`�F�b�N���ʁv�V�[�g�r���[�N���X

Private m_thisWorksheet As Worksheet


' �N���X���萔��`

' �V�[�g���̍s�ʒu��`
Private Enum LINE_POS
    SHEET_TITLE = 1
    SHEET_DISCRPT = 2
    LIST_TITLE = 3
    OUTPUT_START = 4
End Enum

' �V�[�g���̗�ʒu��`
Private Enum COLUMN_POS
    ERR_RAISE_CELL = 2
    GID = 3
    PERSON_NAME = 4
    FIELD_NAME = 5
    ERROR_TYPE = 6
    ERR_CONTENT = 7
End Enum


' �R���X�g���N�^
Private Sub Class_Initialize()
    Set m_thisWorksheet = Worksheets(RESULT_SHEET_NAME)
End Sub

' �f�X�g���N�^
Private Sub Class_Terminate()
    Set m_thisWorksheet = Nothing
End Sub

' �@�\�F�ҏW�ς݂̍ŏI�s���擾����
' �����F�Ȃ�
' �߂�l�F�ҏW�ς݂̍ŏI�s
Private Function getEditedLastRow() As Long
    Dim rowStart As Long: rowStart = 0
    Dim rowCount As Long: rowCount = 0

    With m_thisWorksheet
        rowStart = .UsedRange.row
        rowCount = .UsedRange.Rows.count
    End With

    getEditedLastRow = rowCount + rowStart - 1
End Function

' �@�\�F�`�F�b�N���ʂ��V�[�g�ɏo�͂���
' �����F
'   checkResults : �`�F�b�N����
' �߂�l�F�Ȃ�
Public Sub outputCheckResult(checkResults As CheckResultInfo)
    Dim pos As Long
    Dim key As Variant
    Dim result As CheckResultInfoDto

    On Error GoTo outputCheckResult_Err

    ' �ȑO�̃`�F�b�N���ʂ��N���A
    Call clearCheckResultList

    ' �`�F�b�N���ʂ��o��
    With m_thisWorksheet
        ' �������݊J�n�s���Z�b�g
        pos = OUTPUT_START

        For Each key In checkResults.getCheckResults
            Set result = checkResults.getCheckResults.item(key)

            .cells(pos, COLUMN_POS.ERR_RAISE_CELL).value = result.ErrCellAddr
            .cells(pos, COLUMN_POS.GID).value = result.OwnGuid
            .cells(pos, COLUMN_POS.PERSON_NAME).value = result.PersonName
            .cells(pos, COLUMN_POS.FIELD_NAME).value = result.ColumnName
            .cells(pos, COLUMN_POS.ERROR_TYPE).value = result.getErrTypeString()
            .cells(pos, COLUMN_POS.ERR_CONTENT).value = result.ErrMsgContent

            pos = pos + 1

            Set result = Nothing
        Next
    End With

    ' �r��������
    Call drawCheckResultListLines

    Exit Sub

outputCheckResult_Err:
    If result Is Nothing Then
        Set result = Nothing
    End If

    err.Raise err.Number, "outputCheckResult", err.Description
End Sub

' �@�\�F�`�F�b�N���ʈꗗ���N���A�i�s�v�ȍs�̍폜�j����
' �����F�Ȃ�
' �߂�l�F�Ȃ�
Public Sub clearCheckResultList()
    Dim maxRow As Long: maxRow = LINE_POS.OUTPUT_START
    Dim delArea As String

    maxRow = getEditedLastRow()

    If maxRow >= LINE_POS.OUTPUT_START Then
        ' "4:10"�̌`���ɂ��ď���
        delArea = CStr(LINE_POS.OUTPUT_START) & ":" & CStr(maxRow)

        m_thisWorksheet.Range(delArea).Delete
    End If
End Sub

' �@�\�F�`�F�b�N���ʈꗗ�Ɍr���������i�O�g�F�����A���g�F�_���j
' �����F�Ȃ�
' �߂�l�F�Ȃ�
Public Sub drawCheckResultListLines()
    Dim maxRow As Long: maxRow = LINE_POS.OUTPUT_START

    maxRow = getEditedLastRow()

    With m_thisWorksheet
        ' B3����Gxx�ixx�́A�ҏW�ςݍŏI�s�j�̗̈�Ɍr���������i�O�g�F�����A���g�F�_���j
        .Range(.cells(LINE_POS.LIST_TITLE, COLUMN_POS.ERR_RAISE_CELL), .cells(maxRow, COLUMN_POS.ERR_CONTENT)).Borders.LineStyle = xlContinuous
        .Range(.cells(LINE_POS.OUTPUT_START, COLUMN_POS.ERR_RAISE_CELL), .cells(maxRow, COLUMN_POS.ERR_CONTENT)).Borders(xlInsideHorizontal).LineStyle = xlDot
    End With
End Sub
