VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FieldProperty"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' �l�ވ琬�v��V�[�g���̍��ڂɊւ����`�i���ږ��E�ʒu�A�`�F�b�N���e�j���s���N���X
' FILL-ID�A�i�����j���ږ��AExcel��̗�ʒu��ݒ肷��i�K�{�j
' �`�F�b�N�Ɋւ����`�͈ȉ��̂Ƃ���
'  �E���͕K�{�`�F�b�N�FbRequired = True�̂Ƃ��A�����̓`�F�b�N�����{����
'  �E���s�������̓`�F�b�N�FbAllowCrlf = True�̂Ƃ��A���s�����̑��݃`�F�b�N�����{����
'  �E�����񒷃`�F�b�N�FmaxLength = -1 �ȊO�̂Ƃ��A�����񒷂��w�肳�ꂽ�����ȉ��ł��邱�Ƃ̃`�F�b�N�����{����
'  �E�����t�������̓`�F�b�N�FreqFillId�Ɏw�肳�ꂽ���������͍ς݁i������ > 0�j�̂Ƃ��A���Y���ڂ̖����̓`�F�b�N���s��
'    �i�����͕K�{�`�F�b�N�ƕ��p�͕s�A���͕K�{�`�F�b�N��D�悵�A�{�`�F�b�N�͎��{���Ȃ��j
'  �E�J�X�^���`�F�b�N�FbCustomCheck = True�̂Ƃ��A�ʓr��`�����`�F�b�N�����{����

Private m_fillId As String                      ' FILL-ID
Private m_phyColName As String                  ' �������ږ�
Private m_column As String                      ' ���ڗ�ʒu

Private m_bCheck As Boolean                     ' �`�F�b�N�v�ہiTRUE : �v�AFALSE : �s�v�j
Private m_bRequired As Boolean                  ' �K�{�`�F�b�N�v�ہiTRUE : �v�AFALSE : �s�v�j
Private m_bAllowCrlf As Boolean                 ' ���s������������/���Ȃ��iTRUE : ����AFALSE : ���Ȃ��j
Private m_maxLength As Long                     ' ���͉\�������i��������Ƃ��͂��̒l�A�f�t�H���g��-1�i�������Ȃ��j�j

Private m_ReqFillId As String                   ' �������K�{�i���̍��ڂ��w�肳��Ă���Ƃ��́A�Y������FILL-ID�̓��e�����͂���̂Ƃ��A���͂���Ă��Ȃ��Ƃ����Ȃ��j
Private m_bCustomCheck As Boolean               ' ��L�ȊO�̓��Y���ړ��L�̃`�F�b�N����/���Ȃ��iTRUE : ����AFALSE : ���Ȃ��j
                                                ' ���u����v���Z�b�g�����ꍇ�A�ʓr�`�F�b�N���W�b�N����������K�v����

' �R���X�g���N�^
Private Sub Class_Initialize()
    Call initialize
End Sub

Private Sub initialize()
    m_fillId = ""
    m_phyColName = ""
    m_column = ""
    m_ReqFillId = ""

    m_bCheck = False
    m_bRequired = False
    m_bAllowCrlf = False
    m_maxLength = -1
    m_bCustomCheck = False
End Sub

Public Property Get FILL_ID() As String
    FILL_ID = m_fillId
End Property

Public Property Get PHY_COL_NAME() As String
    PHY_COL_NAME = m_phyColName
End Property

Public Property Get COLUMN_POS() As String
    COLUMN_POS = m_column
End Property

Public Property Get REQUIRED_CHECK() As Boolean
    REQUIRED_CHECK = m_bRequired
End Property

Public Property Get CRLF_CHECK() As Boolean
    CRLF_CHECK = m_bAllowCrlf
End Property

Public Property Get MAX_LENGTH() As Long
    MAX_LENGTH = m_maxLength
End Property

Public Property Get COND_REQ_CHECK() As String
    COND_REQ_CHECK = m_ReqFillId
End Property

Public Property Get CUSTOM_CHECK() As Boolean
    CUSTOM_CHECK = m_bCustomCheck
End Property

Public Function isCheck() As Boolean
    isCheck = m_bCheck
End Function

Public Sub setAll(id As String, colName As String, col As String, bRequire As Boolean, bCrlf As Boolean, length As Long, reqStr As String, bCustom As Boolean)
    m_fillId = id
    m_phyColName = colName
    m_column = col
    m_ReqFillId = reqStr

    ' �`�F�b�N���ǂꂩ�w�肳��Ă���΁A���Y���ڂɑ΂���`�F�b�N���s���悤��
    If bRequire = True Or bCrlf = True Or length > 0 Or reqStr <> "" Or bCustom = True Then
        m_bCheck = True
    End If
    
    m_bRequired = bRequire
    m_bAllowCrlf = bCrlf
    m_maxLength = length
    m_bCustomCheck = bCustom

    ' �K�{���͂Ə����t���K�{�͕��p�s�i�K�{���͂̂ݎ��{�j
    If bRequire = True And reqStr <> "" Then
        bRequire = True
        m_ReqFillId = ""
    End If
End Sub

' �`�F�b�N�s�v�̒�`
Public Sub setNoCheck(id As String, colName As String, col As String)
    Call setAll(id, colName, col, False, False, -1, "", False)
End Sub