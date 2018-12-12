VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ErrorItemDto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' �`�F�b�N�G���[�N���X�idto�N���X�̂悤�Ȃ��́j

Private errSheetName As String          ' �G���[�V�[�g��
Private errRow As String                ' �G���[�����s
Private errType As Long                 ' �G���[���
Private errContent As String            ' �G���[���e

' �R���X�g���N�^
Private Sub Class_Initialize()
    errType = -1
End Sub

' �f�X�g���N�^
Private Sub Class_Terminate()

End Sub

' �v���p�e�B�ɑ΂���A�N�Z�X

' �u�V�[�g���v
Public Function getSheetName() As String
    getSheetName = errSheetName
End Function

Public Sub setSheetName(name As String)
    errSheetName = name
End Sub

' �G���[�����s
Public Function getRow() As String
    getRow = errRow
End Function

Public Sub setRow(row As String)
    errRow = row
End Sub

' �G���[���
Public Function getType() As String
    getType = errType
End Function

Public Function getTypeStr() As String
    Dim str As String
    
    Select Case errType
        ' ���
        Case ERROR_TYPE.CHK_INFO
            str = CHK_INFO_MSG
        ' �x��
        Case ERROR_TYPE.CHK_WARNING
            str = CHK_WARNING_MSG
        ' �G���[
        Case ERROR_TYPE.CHK_ERROR
            str = CHK_ERROR_MSG
        Case Else
            str = ""
    End Select
    
    getTypeStr = str
End Function

Public Sub setType(tp As String)
    errType = tp
End Sub

' �u�G���[���e�v
Public Function getContent() As String
    getContent = errContent
End Function

Public Sub setContent(con As String)
    errContent = con
End Sub

Public Sub setCheck(sheetNm As String, row As String, stype As Long, content As String)
    errSheetName = sheetNm
    errRow = row
    errType = stype
    errContent = content
End Sub