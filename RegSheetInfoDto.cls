VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "RegSheetInfoDto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' 登録するシート情報(dto)クラス

' シート情報
Private m_party As String                           ' PARTY
Private m_nendo As String                           ' 年度
Private m_guid As String                            ' GID
Private m_format As String                          ' フォーマット
Private m_statusCd As String                        ' ステータスコード
Private m_flowPtn As String                         ' フローパターン
Private m_actor1st As String                        ' １次評価者
Private m_actor2nd As String                        ' ２次評価者
Private m_actor3rd As String                        ' ３次評価者
Private m_actor4th As String                        ' ４次評価者

Private m_fillData As Dictionary                    ' シート回答情報

Private Sub Class_Initialize()
    Set m_fillData = New Dictionary
End Sub

Private Sub Class_Terminate()
    Set m_fillData = Nothing
End Sub

Public Property Get party() As String
    party = m_party
End Property

Public Property Let party(p As String)
    m_party = p
End Property

Public Property Get nendo() As String
    nendo = m_nendo
End Property

Public Property Let nendo(n As String)
    m_nendo = n
End Property

Public Property Get guid() As String
    guid = m_guid
End Property

Public Property Let guid(g As String)
    m_guid = g
End Property

Public Property Get format() As String
    format = m_format
End Property

Public Property Let format(fmt As String)
    m_format = fmt
End Property

Public Property Get statusCd() As String
    statusCd = m_statusCd
End Property

Public Property Let statusCd(cd As String)
    m_statusCd = cd
End Property

Public Property Get flowPtn() As String
    flowPtn = m_flowPtn
End Property

Public Property Let flowPtn(ptn As String)
    m_flowPtn = ptn
End Property

Public Property Get actor1st() As String
    actor1st = m_actor1st
End Property

Public Property Let actor1st(actor As String)
    m_actor1st = actor
End Property

Public Property Get actor2nd() As String
    actor2nd = m_actor2nd
End Property

Public Property Let actor2nd(actor As String)
    m_actor2nd = actor
End Property

Public Property Get actor3rd() As String
    actor3rd = m_actor3rd
End Property

Public Property Let actor3rd(actor As String)
    m_actor3rd = actor
End Property

Public Property Get actor4th() As String
    actor4th = m_actor4th
End Property

Public Property Let actor4th(actor As String)
    m_actor4th = actor
End Property

' シート回答情報
Public Property Get fillData() As Dictionary
    Set fillData = m_fillData
End Property

Public Sub addFillData(fillId As String, content As String)
    Call m_fillData.Add(fillId, content)
End Sub
