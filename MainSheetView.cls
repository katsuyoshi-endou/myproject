VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "MainSheetView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' �u���C���v�V�[�g�N���X
' View�N���X�̂悤�Ȃ���

' �i���g�́j�V�[�g��
Private thisWorksheet As Worksheet

' �R���X�g���N�^
Private Sub Class_Initialize()
    Set thisWorksheet = Worksheets(MAIN_SHEET_NAME)
End Sub

' �f�X�g���N�^
Private Sub Class_Terminate()
    Set thisWorksheet = Nothing
End Sub

' �ڑ���������擾
Public Property Get ConnectStr() As String
    ConnectStr = thisWorksheet.Range(DB_CONNECT_STR_CELL).value
End Property

' �ڑ����[�U�����擾
Public Property Get DBUser() As String
    DBUser = thisWorksheet.Range(DB_USER_NAME_CELL).value
End Property

' �ڑ��p�X���[�h���擾
Public Property Get DBPassword() As String
    DBPassword = thisWorksheet.Range(DB_PASSWORD_CELL).value
End Property

' �p�X���[�h�ۑ����擾
Public Property Get KeepPassword() As Boolean
    If StrComp(UCase(thisWorksheet.Range(DB_KEEP_PASSWORD_CELL).value), "TRUE") = 0 Then
        KeepPassword = True
    Else
        KeepPassword = False
    End If
End Property

' ODBC�h���C�o�����擾
Public Property Get ODBCDriver() As String
    ODBCDriver = thisWorksheet.Range(DB_ODBC_DRIVER_NAME_CELL).value
End Property

' �������ʂ��V�[�g�ɏ�������
'  @sheetName �]���V�[�g��
'  @rsCnt ��������
Public Function outputRegResult(sheetName As String, rsCnt As Long) As Long
    Dim cell As Range
    
    On Error GoTo outputRegResult_Err
    
    Set cell = thisWorksheet.Range(M_START_CELL)

    Do While cell.Offset(0, REL_POS_EVAL_SHEET).value <> ""
        ' �u�]���V�[�g���v�������Ƃ���֏�������
        If StrComp(UCase(cell.Offset(0, REL_POS_EVAL_SHEET).value), UCase(sheetName)) = 0 Then
            ' �o�^�����Ɠo�^����
            cell.Offset(0, REL_POS_REG_DATE).value = format(Now, "YYYY/MM/DD hh:mm:ss")
            cell.Offset(0, REL_POS_REG_COUNT).value = CStr(rsCnt) & " ��"
            
            Exit Do
        End If
        
        Set cell = cell.Offset(1, 0)
    Loop
    
    Set cell = Nothing
    
    outputRegResult = 0
    
    Exit Function
    
outputRegResult_Err:
    Err.Raise Err.Number, "outputRegResult", Err.Description

End Function

' �o�^�w���̕\���灛�̃`�F�b�N���t����ꂽ�V�[�g�̏����擾
Public Function getMaruCheckedSheets() As Dictionary
    Dim sheets As Dictionary
    Dim sheetNendo As Dictionary

    Dim cell As Range

    Set sheets = New Dictionary
    
    On Error GoTo getMaruCheckedSheets_Err
    
    Set cell = thisWorksheet.Range(M_START_CELL)
        
    Do While cell.Offset(0, REL_POS_EVAL_SHEET).value <> ""
        If cell.Offset(0, REL_POS_REG_CHECK).value = "��" Then
            Set sheetNendo = New Dictionary

            ' �]���V�[�g���A�N�x
            sheetNendo.Add cell.Offset(0, REL_POS_EVAL_SHEET).value, cell.Offset(0, REL_POS_REG_NENDO).value

            sheets.Add CStr(cell.value), sheetNendo
        End If
        
        Set cell = cell.Offset(1, 0)
    Loop
    
    Set getMaruCheckedSheets = sheets

    Exit Function
    
getMaruCheckedSheets_Err:
    Set sheets = Nothing
    Err.Raise Err.Number, "getMaruCheckedSheets", Err.Description
    
End Function

' DB�ڑ���������擾
Public Function getConnectString() As String
    Dim ret As String
    Dim ODBCDriver As String
    
    With thisWorksheet
        ODBCDriver = .Range(DB_ODBC_DRIVER_NAME_CELL).value  ' ODBC�h���C�o�̎w��
    
        ' ODBC�h���C�o�̎w�肪���邩�𔻕�
        If Len(ODBCDriver) > 0 Then
            ret = "Driver={" & ODBCDriver & "}"                                 ' ODBC�h���C�o�̎w��
            ret = ret & ";DBQ=" & .Range(DB_CONNECT_STR_CELL).value             ' �ڑ�������̎w��
            ret = ret & ";UID=" & .Range(DB_USER_NAME_CELL).value               ' ���[�U���̎w��
            ret = ret & ";PWD=" & .Range(DB_PASSWORD_CELL).value                ' �p�X���[�h�̎w��
        Else
            ret = "Provider=OraOLEDB.Oracle"                                    ' Oracle-ODBC�̎w��
            ret = ret & ";Data Source=" & .Range(DB_CONNECT_STR_CELL).value     ' �ڑ�������̎w��
            ret = ret & ";User ID=" & .Range(DB_USER_NAME_CELL).value           ' ���[�U���̎w��
            ret = ret & ";Password=" & .Range(DB_PASSWORD_CELL).value           ' �p�X���[�h�̎w��
        End If
    End With
    
    ' �ڑ�����Ԃ�
    getConnectString = ret
End Function

' �]���V�[�g���Ɉ�v����N�x���擾����
' �����ł́A�N�x�����̂܂ܕԂ��i"20XX"�ɂ͕ϊ����Ȃ��j
'  @sheetName �]���V�[�g��
Public Function getSheetNendo(sheetName As String) As String
    Dim cell As Range
    Dim row As Long: row = 0
    Dim lgcSheetName As String
    Dim nendo As String: nendo = ""

    Set cell = thisWorksheet.Range(M_START_CELL)

    Do While cell.Offset(row, REL_POS_EVAL_SHEET).value <> ""
        lgcSheetName = cell.Offset(row, REL_POS_EVAL_SHEET).value
        If StrComp(sheetName, lgcSheetName, vbTextCompare) = 0 Then
            nendo = cell.Offset(row, REL_POS_REG_NENDO).value

            Exit Do
        End If

        row = row + 1
    Loop
    Set cell = Nothing

    getSheetNendo = nendo
End Function

' �V�[�g���`�F�b�N����
' ���̓��e���`�F�b�N����
' �@�E�����̑Ώۂ��I������Ă��邩
' �@�E�u�N�x�v���w�肳��Ă��邩
'
' �߂�l�F0�i�G���[�Ȃ��j�A-1�i�N�x�����̓G���[�j
Public Function checkSheet() As Long
    Dim ret As Long: ret = MAIN_SHEET_CHK_RSLT.NO_CHECK_ERROR
    Dim checkedSheets As Dictionary
    Dim key As Variant
    Dim shtName As Variant

    Set checkedSheets = getMaruCheckedSheets()

    If checkedSheets.Count = 0 Then
        ret = MAIN_SHEET_CHK_RSLT.NOT_SELECTED_ERROR
    Else
        ' �u�N�x�v�̓��̓`�F�b�N
        For Each key In checkedSheets
            For Each shtName In checkedSheets.Item(key)
                If Len(checkedSheets.Item(key).Item(shtName)) = 0 Then
                    ret = MAIN_SHEET_CHK_RSLT.NENDO_NO_INPUT_ERROR
                End If
            Next shtName
        Next key

        Set shtName = Nothing
        Set key = Nothing
    End If

    Set checkedSheets = Nothing

    checkSheet = ret

End Function
