VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CheckRuleDto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'�`�F�b�N�����N���X�idto�N���X�̂悤�Ȃ��́j

Private m_colIndex As Long                  ' ��ʒu
Private m_colLgcName As String              ' �񖼁i�_�����j
Private m_colPhyName As String              ' �񖼁i�������j
Private m_bCheck As Boolean                 ' �`�F�b�N�ہiTRUE : ����AFLASE : ���Ȃ��j
Private m_bRequire As Boolean               ' ���͕K�{�v�ہiTRUE : �K�{�AFALSE : �C�Ӂj
Private m_txtAttr As Long                   ' ���͕�������
Private m_maxLength As Long                 ' ���͉\�ő啶����
Private m_bCrLf As Boolean                  ' ���͕����̉��s�v�ہiTRUE : ���AFALSE : �����Ȃ��j
Private m_ptnType As String                 ' ���͌`���^�C�v
Private m_regPattern As String              ' ���͌`���i���K�\���j
Private m_bFixedVal As Boolean              ' �Œ�l�L���iTRUE : ����AFALSE : �Ȃ��j

' �R���X�g���N�^
Private Sub Class_Initialize()
    m_colIndex = -1
    m_bCheck = False
    m_bRequire = False
    m_bCrLf = True
    m_maxLength = -1
    m_bFixedVal = False
End Sub

' �f�X�g���N�^
Private Sub Class_Terminate()

End Sub

' �u��ʒu�v
Public Property Get ColIndex() As Long
    ColIndex = m_colIndex
End Property

' �u�񖼁i�_�����j�v
Public Property Get ColLgcName() As String
    ColLgcName = m_colLgcName
End Property

' �u�񖼁i�������j�v
Public Property Get ColPhyName() As String
    ColPhyName = m_colPhyName
End Property

' �u�`�F�b�N�ہv
Public Property Get isCheck() As Boolean
    isCheck = m_bCheck
End Property

' �u���͕K�{�v�ہv
Public Property Get isRequire() As Boolean
    isRequire = m_bRequire
End Property

' �u���͕��������v
Public Property Get TextAttr() As Long
    TextAttr = m_txtAttr
End Property

' �u���͉\�ő啶�����v
Public Property Get MaxLength() As Long
    MaxLength = m_maxLength
End Property

' �u���s�v�ہv
Public Property Get isCrLf() As Boolean
    isCrLf = m_bCrLf
End Property

' �u���͌`���^�C�v�v
Public Property Get PatternType() As String
    PatternType = m_ptnType
End Property

' �u���͌`���v
Public Property Get RegPattern() As String
    RegPattern = m_regPattern
End Property

Public Property Get isFixedVal() As Boolean
    isFixedVal = m_bFixedVal
End Property

' �`�F�b�N���[����ݒ肷��
'  @index �`�F�b�N���ڗ�ʒu
'  @lgcName ���ږ��i�_�����ږ��j
'  @phyName �J�������i�������ږ��j
'  @require �K�{
'  @attr ���͑���
'  @length ���͉\������
'  @pattern ���͌`��
'  fixedVal �Œ�l
Public Sub setCheckRule(index As Long, lgcName As String, phyName As String, require As String, attr As String, length As String, pattern As String, fixedVal As String)
    On Error GoTo addRule_Err
    
    m_colIndex = index
    m_colLgcName = lgcName
    m_colPhyName = phyName
    
    ' �Œ�l���ݒ肳��Ă���΁A���̍��ڂ̓`�F�b�N���Ȃ�
    If Len(fixedVal) > 0 Then
        m_bCheck = False
    ElseIf StrComp(require, "��") = 0 Or Len(length) > 0 Or Len(pattern) > 0 Then
        m_bCheck = True
        
        ' �u�K�{�v���ڗ���"��"�����Ă���΁ATRUE
        If StrComp(require, "��") = 0 Then
            m_bRequire = True
        Else
            m_bRequire = False
        End If
        
        ' �ő啶�������i�[�i�w�肪�Ȃ���� -1�j
        If IsNumeric(length) = True And Len(length) > 0 Then
            m_maxLength = Val(length)
        Else
            m_maxLength = -1
        End If
        
        ' �u���͌`���v�̐ݒ�
        If pattern <> "-" And Len(pattern) > 0 Then
            ' �u���͌`���v��"���s�s��"�ƋL�ڂ���Ă���΁AFALSE�i���s��F�߂Ȃ��j
            If StrComp(attr, CHK_INPUT_TYPE_STRING_JP, vbTextCompare) = 0 Or StrComp(attr, CHK_INPUT_TYPE_STRING_EN, vbTextCompare) = 0 Then
                m_bCrLf = True
                
                If StrComp(pattern, CHK_PATTERN_NO_CRLF_JP, vbTextCompare) = 0 Or StrComp(pattern, CHK_PATTERN_NO_CRLF_EN, vbTextCompare) = 0 Then
                    m_bCrLf = False
                End If
            End If
            
            ' ���͌`���𐳋K�\���p�^�[���Őݒ肷��
            
            ' �N(YYYY)
            If StrComp(UCase(pattern), CHK_PATTERN_YYYY) = 0 Then
                m_ptnType = "YYYY"
                m_regPattern = "^(\d{4})$"
            ' �N��(YYYY/MM)
            ElseIf StrComp(UCase(pattern), CHK_PATTERN_YYYYMM) = 0 Then
                m_ptnType = "YYYY/MM"
                m_regPattern = "^(\d{4})/(0[1-9]|1[0-2])$"
            ' �N����(YYYY/MM/DD)
            ElseIf StrComp(UCase(pattern), CHK_PATTERN_YYYYMMDD) = 0 Then
                m_ptnType = "YYYY/MM/DD"
                m_regPattern = "^(\d{4})/(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])$"
            ElseIf StrComp(pattern, "0-100") = 0 Then
                m_ptnType = "NUMERIC[0-100]"
                
                ' 0����100�܂ł̔��p����
                ' �����͔͈͂�0����100�ȊO�Őݒ肷��Ƃ��͕ʓr������ǉ��i���I�ɍ쐬����̂�����H�j
                m_regPattern = "^[1-9]?[0-9]$|100$"
            Else
                m_ptnType = ""
                m_regPattern = ""
            End If
            
            ' ���͌`���̎w�肪����΂����ɒǋL
        End If

    Else
        m_bCheck = False
    End If
    
    Exit Sub
    
addRule_Err:
    Err.Raise Err.Number, "setCheckRule", Err.Description
    
End Sub
