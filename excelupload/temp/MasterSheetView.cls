VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "MasterSheetView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' �umaster�v�V�[�g�Ɋւ���r���[�N���X

Private m_thisWorksheet As Worksheet
Private m_IdoMonthRange() As String
Private m_BuyerNendoRange() As String
Private m_BuyerRankRange() As String
Private m_TouyoNendoRange() As String
Private m_ToukyuGunRange() As String
Private m_IdoTaishokuRange() As String
Private m_IdoShokumuRange() As String
Private m_IdoJigyojoRange() As String
Private m_IdoKyotenRange() As String
Private m_IdoKouniRange() As String

' �R���X�g���N�^
Private Sub Class_Initialize()

    Set m_thisWorksheet = Worksheets(MASTER_SHEET_NAME)

    Call initialRangeValue
End Sub

' �f�X�g���N�^
Private Sub Class_Terminate()

End Sub

Public Property Get MONTH_RANGE() As String()
    MONTH_RANGE = m_IdoMonthRange
End Property

Public Property Get BUYER_NENDO_RANGE() As String()
    BUYER_NENDO_RANGE = m_BuyerNendoRange
End Property

Public Property Get BUYER_NINTEIKYU_RANGE() As String()
    BUYER_NINTEIKYU_RANGE = m_BuyerRankRange
End Property

Public Property Get TOUYO_NENDO_RANGE() As String()
    TOUYO_NENDO_RANGE = m_TouyoNendoRange
End Property

Public Property Get TOUKYU_GUN_RANGE() As String()
    TOUKYU_GUN_RANGE = m_ToukyuGunRange
End Property

Public Property Get IDO_TAISHOKU_RANGE() As String()
    IDO_TAISHOKU_RANGE = m_IdoTaishokuRange
End Property

Public Property Get IDO_SHOKUMU_RANGE() As String()
    IDO_SHOKUMU_RANGE = m_IdoShokumuRange
End Property

Public Property Get IDO_JIGYOJO_RANGE() As String()
    IDO_JIGYOJO_RANGE = m_IdoJigyojoRange
End Property

Public Property Get IDO_KYOTEN_RANGE() As String()
    IDO_KYOTEN_RANGE = m_IdoKyotenRange
End Property

Public Property Get IDO_KOUNIN_RANGE() As String()
    IDO_KOUNIN_RANGE = m_IdoKouniRange
End Property

Private Sub initialRangeValue()
    ' �i�ٓ����сE�ٓ��v��j�ٓ����v�͈̔͒l���擾
    m_IdoMonthRange = getRangeValue("B4")

    ' �i�o�C���[�F��j�F��N�x
    m_BuyerNendoRange = getRangeValue("C4")

    ' �i�o�C���[�F��j�F�苉
    m_BuyerRankRange = getRangeValue("D4")

    ' �i�o�p�v��j�o�p�N�x
    m_TouyoNendoRange = getRangeValue("E4")

    ' �i�o�p�v��j�����Q
    m_ToukyuGunRange = getRangeValue("F4")

    ' �ٓ��E�ސE
    m_IdoTaishokuRange = getRangeValue("G4")

    ' �i�ٓ��v��j�E��
    m_IdoShokumuRange = getRangeValue("H4")

    ' �i�ٓ��v��j���Ə�
    m_IdoJigyojoRange = getRangeValue("I4")

    ' �i�ٓ��v��j���_
    m_IdoKyotenRange = getRangeValue("J4")

    ' �i�ٓ��v��j��C�v��
    m_IdoKouniRange = getRangeValue("K4")
End Sub

Private Function getRangeValue(cellAddr As String) As String()
    Dim row As Range
    Dim i As Long: i = 1
    Dim arr() As String: ReDim arr(0)

    On Error GoTo getRangeValue_Err

    Set row = m_thisWorksheet.Range(cellAddr)

    Do Until row.Offset(i, 0).value = ""
        arr(UBound(arr)) = row.Offset(i, 0).value

        ReDim Preserve arr(UBound(arr) + 1)

        i = i + 1
    Loop

    ReDim Preserve arr(UBound(arr) - 1)

    Set row = Nothing

    getRangeValue = arr

    Exit Function

getRangeValue_Err:
    err.Raise err.Number, "getRangeValue", err.Description

    If row Is Nothing Then
        Set row = Nothing
    End If

End Function
