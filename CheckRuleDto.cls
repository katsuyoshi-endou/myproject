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

'チェック条件クラス（dtoクラスのようなもの）

Private m_colIndex As Long                  ' 列位置
Private m_colLgcName As String              ' 列名（論理名）
Private m_colPhyName As String              ' 列名（物理名）
Private m_bCheck As Boolean                 ' チェック可否（TRUE : する、FLASE : しない）
Private m_bRequire As Boolean               ' 入力必須要否（TRUE : 必須、FALSE : 任意）
Private m_txtAttr As Long                   ' 入力文字属性
Private m_maxLength As Long                 ' 入力可能最大文字数
Private m_bCrLf As Boolean                  ' 入力文字の改行要否（TRUE : 許可、FALSE : 許可しない）
Private m_ptnType As String                 ' 入力形式タイプ
Private m_regPattern As String              ' 入力形式（正規表現）
Private m_bFixedVal As Boolean              ' 固定値有無（TRUE : あり、FALSE : なし）

' コンストラクタ
Private Sub Class_Initialize()
    m_colIndex = -1
    m_bCheck = False
    m_bRequire = False
    m_bCrLf = True
    m_maxLength = -1
    m_bFixedVal = False
End Sub

' デストラクタ
Private Sub Class_Terminate()

End Sub

' 「列位置」
Public Property Get ColIndex() As Long
    ColIndex = m_colIndex
End Property

' 「列名（論理名）」
Public Property Get ColLgcName() As String
    ColLgcName = m_colLgcName
End Property

' 「列名（物理名）」
Public Property Get ColPhyName() As String
    ColPhyName = m_colPhyName
End Property

' 「チェック可否」
Public Property Get isCheck() As Boolean
    isCheck = m_bCheck
End Property

' 「入力必須要否」
Public Property Get isRequire() As Boolean
    isRequire = m_bRequire
End Property

' 「入力文字属性」
Public Property Get TextAttr() As Long
    TextAttr = m_txtAttr
End Property

' 「入力可能最大文字数」
Public Property Get MaxLength() As Long
    MaxLength = m_maxLength
End Property

' 「改行要否」
Public Property Get isCrLf() As Boolean
    isCrLf = m_bCrLf
End Property

' 「入力形式タイプ」
Public Property Get PatternType() As String
    PatternType = m_ptnType
End Property

' 「入力形式」
Public Property Get RegPattern() As String
    RegPattern = m_regPattern
End Property

Public Property Get isFixedVal() As Boolean
    isFixedVal = m_bFixedVal
End Property

' チェックルールを設定する
'  @index チェック項目列位置
'  @lgcName 項目名（論理項目名）
'  @phyName カラム名（物理項目名）
'  @require 必須
'  @attr 入力属性
'  @length 入力可能文字数
'  @pattern 入力形式
'  fixedVal 固定値
Public Sub setCheckRule(index As Long, lgcName As String, phyName As String, require As String, attr As String, length As String, pattern As String, fixedVal As String)
    On Error GoTo addRule_Err
    
    m_colIndex = index
    m_colLgcName = lgcName
    m_colPhyName = phyName
    
    ' 固定値が設定されていれば、その項目はチェックしない
    If Len(fixedVal) > 0 Then
        m_bCheck = False
    ElseIf StrComp(require, "○") = 0 Or Len(length) > 0 Or Len(pattern) > 0 Then
        m_bCheck = True
        
        ' 「必須」項目欄に"○"がついていれば、TRUE
        If StrComp(require, "○") = 0 Then
            m_bRequire = True
        Else
            m_bRequire = False
        End If
        
        ' 最大文字数を格納（指定がなければ -1）
        If IsNumeric(length) = True And Len(length) > 0 Then
            m_maxLength = Val(length)
        Else
            m_maxLength = -1
        End If
        
        ' 「入力形式」の設定
        If pattern <> "-" And Len(pattern) > 0 Then
            ' 「入力形式」に"改行不可"と記載されていれば、FALSE（改行を認めない）
            If StrComp(attr, CHK_INPUT_TYPE_STRING_JP, vbTextCompare) = 0 Or StrComp(attr, CHK_INPUT_TYPE_STRING_EN, vbTextCompare) = 0 Then
                m_bCrLf = True
                
                If StrComp(pattern, CHK_PATTERN_NO_CRLF_JP, vbTextCompare) = 0 Or StrComp(pattern, CHK_PATTERN_NO_CRLF_EN, vbTextCompare) = 0 Then
                    m_bCrLf = False
                End If
            End If
            
            ' 入力形式を正規表現パターンで設定する
            
            ' 年(YYYY)
            If StrComp(UCase(pattern), CHK_PATTERN_YYYY) = 0 Then
                m_ptnType = "YYYY"
                m_regPattern = "^(\d{4})$"
            ' 年月(YYYY/MM)
            ElseIf StrComp(UCase(pattern), CHK_PATTERN_YYYYMM) = 0 Then
                m_ptnType = "YYYY/MM"
                m_regPattern = "^(\d{4})/(0[1-9]|1[0-2])$"
            ' 年月日(YYYY/MM/DD)
            ElseIf StrComp(UCase(pattern), CHK_PATTERN_YYYYMMDD) = 0 Then
                m_ptnType = "YYYY/MM/DD"
                m_regPattern = "^(\d{4})/(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])$"
            ElseIf StrComp(pattern, "0-100") = 0 Then
                m_ptnType = "NUMERIC[0-100]"
                
                ' 0から100までの半角数字
                ' ※入力範囲を0から100以外で設定するときは別途処理を追加（動的に作成するのが難しい？）
                m_regPattern = "^[1-9]?[0-9]$|100$"
            Else
                m_ptnType = ""
                m_regPattern = ""
            End If
            
            ' 入力形式の指定があればここに追記
        End If

    Else
        m_bCheck = False
    End If
    
    Exit Sub
    
addRule_Err:
    Err.Raise Err.Number, "setCheckRule", Err.Description
    
End Sub

