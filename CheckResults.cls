VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CheckResults"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' �`�F�b�N���ʂ��i�[����N���X
Private errors As Dictionary                ' �`�F�b�N����

' �R���X�g���N�^
Private Sub Class_Initialize()
    Set errors = New Dictionary
End Sub

' �f�X�g���N�^
Private Sub Class_Terminate()
    errors.RemoveAll

    Set errors = Nothing
End Sub

' �G���[������Ԃ�
Public Property Get Count() As Long
    Count = errors.Count
End Property

' �`�F�b�N���ʂ��i�[����
'  @name �]���V�[�g��
'  @row �G���[�s�ʒu
'  @stype �G���[���
'  @content �G���[���e
Public Sub addCheckResult(name As String, row As String, stype As Long, content As String)
    Dim error As ErrorItemDto
    
    On Error GoTo addCheckResult_Err

    Set error = New ErrorItemDto

    Call error.setCheck(name, row, stype, content)

    Call errors.Add(CStr(errors.Count + 1), error)
    
    Set error = Nothing

    Exit Sub

addCheckResult_Err:
    Set error = Nothing

    Err.Raise Err.Number, "addCheckResult", Err.Description

End Sub

' �`�F�b�N�G���[�I�u�W�F�N�g�̃L�[�i1����̘A�ԁj��Ԃ�
Public Function getKeys() As Variant
    getKeys = errors.keys
End Function

' �L�[�i1����̘A�ԁj�Ɉ�v����v�f�i�`�F�b�N���e�j��Ԃ�
'  @key �L�[
Public Function getError(key As String) As Variant
    On Error GoTo getError_Err

    Set getError = errors.Item(key)

    Exit Function

getError_Err:
    Err.Raise Err.Number, "getError", Err.Description

End Function
