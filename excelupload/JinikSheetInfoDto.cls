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

' 人材育成計画シート情報クラス

' 更新対象でない項目は個別に定義する

Private m_sheetNendo As String                  ' シートの年度

' 社員属性など
Private m_statusNm As String                    ' ステーテス
Private m_guid As String                        ' GUID
Private m_personName As String                  ' 名前

' 上記以外の編集対象の項目は、Dictionaryオブジェクトで格納
Private m_sheetAnsFields As Dictionary

' コンストラクタ
Private Sub Class_Initialize()
    Set m_sheetAnsFields = New Dictionary
End Sub

' デストラクタ
Private Sub Class_Terminate()
    m_sheetAnsFields.RemoveAll

    Set m_sheetAnsFields = Nothing
End Sub

Public Property Get getSheetNendo() As String
    getSheetNendo = m_sheetNendo
End Property

Public Property Let setSheetNendo(nendo As String)
    m_sheetNendo = nendo
End Property

Public Property Get getStatusNm() As String
    getStatusNm = m_statusNm
End Property

Public Property Let setStatusNm(name As String)
    m_statusNm = name
End Property

Public Property Get getGuid() As String
    getGuid = m_guid
End Property

Public Property Let setGuid(id As String)
    m_guid = id
End Property

Public Property Get getPersonName() As String
    getPersonName = m_personName
End Property

Public Property Let setPersonName(name As String)
    m_personName = name
End Property

Public Function getFillData() As Dictionary
    Set getFillData = m_sheetAnsFields
End Function

Public Sub addSheetFillData(fillId As String, address As String, phyColName As String, value As String)
    Dim str As String

    If m_sheetNendo <> "" Then
        str = Replace(phyColName, "{0}", CLng(m_sheetNendo) + 0)
        str = Replace(str, "{1}", CLng(m_sheetNendo) + 1)
        str = Replace(str, "{2}", CLng(m_sheetNendo) + 2)
        str = Replace(str, "{3}", CLng(m_sheetNendo) + 3)
        str = Replace(str, "{4}", CLng(m_sheetNendo) + 4)
    End If

    Call m_sheetAnsFields.Add(fillId, Array(address, str, value))
End Sub

' *************************************************************
'  キー（FILL-ID）を指定して、一致するシート回答情報を取得する
' *************************************************************
Public Function getSheetFillData(fillId As String) As Variant
    If m_sheetAnsFields.Exists(fillId) = False Then
        getSheetFillData = Nothing
    End If

    getSheetFillData = m_sheetAnsFields.item(fillId)
End Function
