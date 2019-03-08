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

' 人材育成計画シート内の項目に関する定義（項目名・位置、チェック内容）を行うクラス
' FILL-ID、（物理）項目名、Excel上の列位置を設定する（必須）
' チェックに関する定義は以下のとおり
'  ・入力必須チェック：bRequired = Trueのとき、未入力チェックを実施する
'  ・改行文字入力チェック：bAllowCrlf = Trueのとき、改行文字の存在チェックを実施する
'  ・文字列長チェック：maxLength = -1 以外のとき、文字列長が指定された長さ以下であることのチェックを実施する
'  ・条件付き未入力チェック：reqFillIdに指定された文字が入力済み（文字列長 > 0）のとき、当該項目の未入力チェックを行う
'    （※入力必須チェックと併用は不可、入力必須チェックを優先し、本チェックは実施しない）
'  ・カスタムチェック：bCustomCheck = Trueのとき、別途定義したチェックを実施する

Private m_fillId As String                      ' FILL-ID
Private m_phyColName As String                  ' 物理項目名
Private m_column As String                      ' 項目列位置

Private m_bCheck As Boolean                     ' チェック要否（TRUE : 要、FALSE : 不要）
Private m_chkStatus As String                   ' チェックを行うステータス
Private m_bRequired As Boolean                  ' 必須チェック要否（TRUE : 要、FALSE : 不要）
Private m_bAllowCrlf As Boolean                 ' 改行文字を許可する/しない（TRUE : する、FALSE : しない）
Private m_maxLength As Long                     ' 入力可能文字数（制限するときはその値、デフォルトは-1（制限しない））
Private m_bRangeCheck As Boolean                ' 範囲チェック要否（TRUE : する、FALSE : しない）

Private m_ReqFillId As String                   ' 条件つき必須（この項目が指定されているときは、該当するFILL-IDの内容が入力ありのとき、入力されていないといけない）
Private m_bCustomCheck As Boolean               ' 上記以外の当該項目特有のチェックする/しない（TRUE : する、FALSE : しない）
                                                ' ※「する」をセットした場合、別途チェックロジックを実装する必要あり

' コンストラクタ
Private Sub Class_Initialize()
    Call initialize
End Sub

Private Sub initialize()
    m_fillId = ""
    m_phyColName = ""
    m_column = ""
    m_ReqFillId = ""

    m_bCheck = False
    m_chkStatus = ""
    m_bRequired = False
    m_bAllowCrlf = False
    m_maxLength = -1
    m_bCustomCheck = False
    m_bRangeCheck = False
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

Public Property Get CHECK_STATUS() As String
    CHECK_STATUS = m_chkStatus
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

Public Property Get RANGE_CHECK() As Boolean
    RANGE_CHECK = m_bRangeCheck
End Property

Public Function isCheck() As Boolean
    isCheck = m_bCheck
End Function

' 機能：項目のプロパティ（項目情報とかチェック条件）をセットする
' 引数：
'   id : 回答ID
'   colName : 回答項目名（日本語）
'   col : シート上の項目列位置
'   status : チェックを行うステータス
'   bRequire : 必須入力チェック要否（TRUE : する、FALSE : しない）
'   bCrlf : 改行文字存在チェック（TRUE : する、FALSE : しない）
'   length : 文字列長チェック（-1 : しない、0以上 : 指定した長さでチェック）
'   reqStr : 条件付き必須チェック（NULL : しない、指定あり : 引数に指定された項目が入力済みのとき、必須チェックを行う）
'   bCustom : カスタムチェック（TRUE : する、FALSE : しない）
' 戻り値：なし
Public Sub setAllProperty(id As String, colName As String, col As String, status As String, bRequire As Boolean, bCrlf As Boolean, length As Long, reqStr As String, bCustom As Boolean)
    m_fillId = id
    m_phyColName = colName
    m_column = col
    m_ReqFillId = reqStr

    ' チェックがどれか指定されていれば、当該項目に対するチェックを行うように
    If bRequire = True Or bCrlf = True Or length > 0 Or reqStr <> "" Or bCustom = True Then
        m_bCheck = True
    End If
    
    m_chkStatus = status
    m_bRequired = bRequire
    m_bAllowCrlf = bCrlf
    m_maxLength = length
    m_bCustomCheck = bCustom

    ' 必須入力と条件付き必須は併用不可（必須入力のみ実施）
    If bRequire = True And reqStr <> "" Then
        bRequire = True
        m_ReqFillId = ""
    End If
End Sub

' 機能：項目のプロパティ（項目情報のみ）をセットする（項目のチェックを必要としないとき用）
' 引数：
'   id : 回答ID
'   colName : 回答項目名（日本語）
'   col : シート上の項目列位置
' 戻り値：なし
Public Sub setItem(id As String, colName As String, col As String)
    Call setAllProperty(id, colName, col, "", False, False, -1, "", False)
End Sub

' 機能：範囲チェックをするかどうかを設定する
' 引数：
'       bRangeCheck : 範囲チェック（TRUE : する、FALSE : しない）
' 戻り値：なし
' 備考：本メソッドは必ず、事前にsetItemメソッドもしくは、setAllPropertyメソッドがコールされていること
Public Sub setRangeCheck(bCheck As Boolean)
    If bCheck = True Then
        m_bCheck = True
    End If

    m_bRangeCheck = bCheck
End Sub
