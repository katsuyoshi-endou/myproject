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

' 機能：シート回答情報を格納する
' 引数：
'   fillId     : 回答ID
'   address    : 回答項目のセル位置（A1形式）
'   phyColName : 回答項目名（日本語）
'   value      : 回答データ
' 引数：なし
Public Sub addSheetFillData(fillId As String, address As String, phyColName As String, value As String)
    Dim str As String

    ' "xx年度担当業務計画　異動"と出力するために、基準となる年度から計算して置き換え
    If m_sheetNendo <> "" Then
        str = Replace(phyColName, "{0}", CLng(m_sheetNendo) + 0)
        str = Replace(str, "{1}", CLng(m_sheetNendo) + 1)
        str = Replace(str, "{2}", CLng(m_sheetNendo) + 2)
        str = Replace(str, "{3}", CLng(m_sheetNendo) + 3)
        str = Replace(str, "{4}", CLng(m_sheetNendo) + 4)
    End If

    Call m_sheetAnsFields.Add(fillId, Array(address, str, value))
End Sub

' 機能：キー（FILL-ID）を指定して、一致するシート回答情報を取得する
' 引数：
'   fillId : データを取得する回答ID
' 戻り値：回答データ
Public Function getValueByFillId(fillId As String) As String
    Dim var As Variant

    If m_sheetAnsFields.Exists(fillId) = False Then
        getValueByFillId = ""
        Exit Function
    End If

    ' varには、セル位置・項目名（日本語）・回答データが配列で格納されているので回答データを返す
    var = m_sheetAnsFields.item(fillId)

    getValueByFillId = var(2)
End Function
