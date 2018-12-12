VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ErrorListView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' �u�G���[�ꗗ�v�V�[�g�N���X
' View�N���X�̂悤�Ȃ���

Private thisWorksheet As Worksheet

' �R���X�g���N�^
Private Sub Class_Initialize()
    Set thisWorksheet = Worksheets(ERR_LIST_SHEET_NAME)
End Sub

' �f�X�g���N�^
Private Sub Class_Terminate()
    Set thisWorksheet = Nothing
End Sub

' �ҏW����Ă���ŏI�s���擾�Ԃ�
Public Property Get getEditLastRow()
    Dim rowStart As Long
    Dim rowCount As Long

    With thisWorksheet
        rowStart = .UsedRange.row
        rowCount = .UsedRange.Rows.Count
        getEditLastRow = rowCount + rowStart - 1
    End With
End Property

' �G���[�ꗗ�ɏo�͂���Ă�����e��Ԃ�
Public Function getErrListContents() As Collection
    Dim contents As Collection
    Dim errCell As Range

    Set contents = New Collection
    
    Set errCell = thisWorksheet.Range(ERR_LIST_WRITE_START_CELL)
    
    Do While errCell.value <> ""
        
    
        Set errCell = errCell.Offset(1, 0)
    Loop
End Function

' �`�F�b�N���ʂ���������
'  @sheetName �]���V�[�g��
'  @errors �`�F�b�N����
Public Sub writeCheckResult(sheetName As String, errors As CheckResults)
    Dim pos As Long
    Dim key As Variant
    Dim error As ErrorItemDto
    
    On Error GoTo writeCheckResult_Err
    
    ' �ŏI�s + 1�s�ڂ���o��
    pos = thisWorksheet.Range("B1").End(xlDown).row + 1

    If errors.Count = 0 Then
        With thisWorksheet
            ' �x���E�G���[���Ȃ���΁A"���"�E"�G���[�͂���܂���B"����������
            .Cells(pos, ERR_LIST_SHEET_NAME_COL).value = sheetName
            .Cells(pos, ERR_LIST_ERROR_ROW_COL).value = "-"
            .Cells(pos, ERR_LIST_ERR_TYPE_COL).value = CHK_INFO_MSG
            .Cells(pos, ERR_LIST_ERR_CONTENT_COL).value = CHECK_NO_ERROR
        End With
    Else
        For Each key In errors.getKeys
            Set error = errors.getError(CStr(key))
            
            With thisWorksheet
                .Cells(pos, ERR_LIST_SHEET_NAME_COL).value = error.getSheetName()
                .Cells(pos, ERR_LIST_ERROR_ROW_COL).value = error.getRow()
                .Cells(pos, ERR_LIST_ERR_TYPE_COL).value = error.getTypeStr()
                .Cells(pos, ERR_LIST_ERR_CONTENT_COL).value = error.getContent()
            End With
            
            pos = pos + 1
            
            Set error = Nothing
        Next
    End If
    
    Exit Sub
    
writeCheckResult_Err:
    Set error = Nothing

    Err.Raise Err.Number, "writeCheckResult", Err.Description

End Sub

' �w�肳�ꂽ�V�[�g�Ɋւ���G���[�`�F�b�N�󋵂�Ԃ�
'  @sheetName �]���V�[�g��
Public Function getStatusCheckedSheet(sheetName As String) As Long
    Dim ret As Long: ret = CHK_SHEET_STATUS.NOT_CHECKED
    Dim chkRsltStr As String
    Dim cell As Range
    
    Set cell = thisWorksheet.Range(ERR_LIST_WRITE_START_CELL)
        
    Do While cell.value <> ""
        ' �V�[�g������v����Ƃ��A�G���[�`�F�b�N�̏󋵂��m�F
        If StrComp(cell.value, sheetName) = 0 Then
            chkRsltStr = cell.Offset(0, 2).value
            If StrComp(chkRsltStr, CHK_INFO_MSG) = 0 Then
                ' ��ʂ�"���"�̂Ƃ��A���܂̂Ƃ����"�G���[�Ȃ�"�����̂��߃��[�v�𔲂���
                ret = CHK_SHEET_STATUS.CHECK_OK
                Exit Do
            ElseIf StrComp(chkRsltStr, CHK_ERROR_MSG) = 0 Then
                ' ��ʂ�"�G���["�̂Ƃ��́A���Y�V�[�g�̓G���[����Ƃ��ă��[�v�𔲂���
                ret = CHK_SHEET_STATUS.CHECK_ERROR
                Exit Do
            ElseIf StrComp(chkRsltStr, CHK_WARNING_MSG) = 0 Then
                ' ��ʂ�"�x��"�̂Ƃ��́A�G���[�����肤��̂ŏ������p��
                ret = CHK_SHEET_STATUS.CHECK_WARNING
            End If
        End If
    
        Set cell = cell.Offset(1, 0)
    Loop

    Set cell = Nothing

    getStatusCheckedSheet = ret

End Function

' �G���[�ꗗ���N���A�i�s�v�ȍs�̍폜�j����
Public Sub clearErrorList()
    Dim maxRow As Long

    maxRow = getEditLastRow()

    ' 3�s�ڈȍ~������
    If maxRow >= 3 Then
        thisWorksheet.Range("3:" & maxRow).Delete
    End If
End Sub

' �G���[�ꗗ�Ɋe��r��������
Public Sub drawListLines()
    Dim maxRow As Long

    maxRow = getEditLastRow()

    With thisWorksheet
        .Range(.Cells(2, ERR_LIST_SHEET_NAME_COL), .Cells(maxRow, ERR_LIST_ERR_CONTENT_COL)).Borders.LineStyle = xlContinuous
        .Range(.Cells(3, ERR_LIST_SHEET_NAME_COL), .Cells(maxRow, ERR_LIST_ERR_CONTENT_COL)).Borders(xlInsideHorizontal).LineStyle = xlDot
    End With
End Sub
