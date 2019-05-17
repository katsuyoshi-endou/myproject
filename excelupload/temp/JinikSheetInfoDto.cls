VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "JinikSheetInfoDto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' �l�ވ琬�v��V�[�g���N���X

' �X�V�ΏۂłȂ����ڂ͌ʂɒ�`����

Private m_sheetNendo As String                  ' �V�[�g�̔N�x

' �Ј������Ȃ�
Private m_statusNm As String                    ' �X�e�[�e�X
Private m_guid As String                        ' GUID
Private m_personName As String                  ' ���O

' ��L�ȊO�̕ҏW�Ώۂ̍��ڂ́ADictionary�I�u�W�F�N�g�Ŋi�[
Private m_sheetAnsFields As Dictionary

' �R���X�g���N�^
Private Sub Class_Initialize()
    Set m_sheetAnsFields = New Dictionary
End Sub

' �f�X�g���N�^
Private Sub Class_Terminate()
    m_sheetAnsFields.RemoveAll

    Set m_sheetAnsFields = Nothing
End Sub

Public Property Get SheetNendo() As String
    SheetNendo = m_sheetNendo
End Property

Public Property Let SheetNendo(nendo As String)
    m_sheetNendo = nendo
End Property

Public Property Get statusName() As String
    statusName = m_statusNm
End Property

Public Property Let statusName(name As String)
    m_statusNm = name
End Property

Public Property Get OwnGuid() As String
    OwnGuid = m_guid
End Property

Public Property Let OwnGuid(id As String)
    m_guid = id
End Property

Public Property Get PersonName() As String
    PersonName = m_personName
End Property

Public Property Let PersonName(name As String)
    m_personName = name
End Property

Public Function getFillData() As Dictionary
    Set getFillData = m_sheetAnsFields
End Function

' �@�\�F�V�[�g�񓚏����i�[����
' �����F
'   fillId     : ��ID
'   address    : �񓚍��ڂ̃Z���ʒu�iA1�`���j
'   phyColName : �񓚍��ږ��i���{��j
'   value      : �񓚃f�[�^
' �����F�Ȃ�
Public Sub addSheetFillData(fillId As String, address As String, phyColName As String, value As String)
    Dim str As String

    ' "xx�N�x�S���Ɩ��v��@�ٓ�"�Əo�͂��邽�߂ɁA��ƂȂ�N�x����v�Z���Ēu������
    If m_sheetNendo <> "" Then
        str = Replace(phyColName, "{0}", CLng(m_sheetNendo) + 0)
        str = Replace(str, "{1}", CLng(m_sheetNendo) + 1)
        str = Replace(str, "{2}", CLng(m_sheetNendo) + 2)
        str = Replace(str, "{3}", CLng(m_sheetNendo) + 3)
        str = Replace(str, "{4}", CLng(m_sheetNendo) + 4)
    End If

    Call m_sheetAnsFields.Add(fillId, Array(address, str, value))
End Sub

' �@�\�F�L�[�iFILL-ID�j���w�肵�āA��v����V�[�g�񓚏����擾����
' �����F
'   fillId : �f�[�^���擾�����ID
' �߂�l�F�񓚃f�[�^
Public Function getValueByFillId(fillId As String) As String
    Dim var As Variant

    If m_sheetAnsFields.Exists(fillId) = False Then
        getValueByFillId = ""
        Exit Function
    End If

    ' var�ɂ́A�Z���ʒu�E���ږ��i���{��j�E�񓚃f�[�^���z��Ŋi�[����Ă���̂ŉ񓚃f�[�^��Ԃ�
    var = m_sheetAnsFields.item(fillId)

    getValueByFillId = var(2)
End Function