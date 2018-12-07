VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SheetControl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' コントーロールクラスのようなもの
' 各シートのビュー定義を格納しておき、処理の制御を行う
' （評価シートからデータの取得を指示してエラーチェックを実施して結果をエラー一覧に書き込む指示など）

Private m_MainSheetView As MainSheetView        ' メインシートクラス
Private m_ErrListView As ErrorListView          ' エラー一覧シートクラス
Private m_EvalSheetView As EvalSheetView        ' 評価シートクラス
Private m_DbConnect As DBConnection             ' データベースコネクションクラス

Private Declare Function GetInputState Lib "USER32" () As Long
Private m_Time As Variant

Public Sub checkEvents()
    If GetInputState() Or (DateDiff("s", m_Time, Time) > 1) Then
        DoEvents
        m_Time = Time
    End If
End Sub

' 「メイン」シート
Public Property Let MainSheetView(view As MainSheetView)
    Set m_MainSheetView = view
End Property

' 「エラー一覧」シート
Public Property Let ErrorListView(view As ErrorListView)
    Set m_ErrListView = view
End Property

' 「（共通）評価シート」
Public Property Let EvalSheetView(view As EvalSheetView)
    Set m_EvalSheetView = view
End Property

' データベースコネクションクラス
Public Property Let DBConnection(conn As DBConnection)
    Set m_DbConnect = conn
End Property

' エラーチェック処理メイン
Public Function checkErrorMain()
    Dim ret As Long
    Dim shtName As String           ' 評価シート名
    Dim regUser As String
    Dim errMsg As String
    
    Dim rules As Dictionary
    Dim errors As CheckResults
    
    Dim chkSheets As Dictionary
    Dim sheetName As Variant

    Dim shtInf As Dictionary
    Dim name As Variant
    
    On Error GoTo checkErrorMain_Err
    
    Set chkSheets = m_MainSheetView.getMaruCheckedSheets()
    
    ' チェック対象のシートがあれば、チェック前に「エラー一覧」シートの内容をクリアしておく
    If chkSheets.Count > 0 Then
        m_ErrListView.clearErrorList
    End If
    
    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual

    For Each sheetName In chkSheets
        Set shtInf = chkSheets.Item(sheetName)

        For Each name In shtInf
            shtName = name
        Next name
        
        Set shtInf = Nothing

        ' 現在の評価シートを設定
        m_EvalSheetView.sheetName = sheetName
        
        ' シートに記述したチェックの内容をもとにチェックルールオブジェクトを作成
        Set rules = m_EvalSheetView.getCheckRule()
            
        ' 作成したチェックルールをもとにして当該シートのチェックを実施
        Set errors = checkSheetError(shtName, rules)
        
        ' チェック結果を「エラー一覧」シートに書き込み
        Call m_ErrListView.writeCheckResult(shtName, errors)

        Set errors = Nothing
        Set rules = Nothing

    Next sheetName

    Application.ScreenUpdating = True
    Application.Calculation = xlCalculationAutomatic

    Set chkSheets = Nothing

    ' エラー一覧の罫線描画
    Call m_ErrListView.drawListLines

    checkErrorMain = 0
    
    Exit Function
    
checkErrorMain_Err:
    Set errors = Nothing
    Set rules = Nothing
    Set chkSheets = Nothing

    Application.ScreenUpdating = True
    Application.Calculation = xlCalculationAutomatic

    errMsg = Replace(Replace(ERR_DB_UNEXPECTED, "{0}", shtName), "{1}", "0")
    MsgBox errMsg & vbCrLf & Err.Description, vbCritical + vbOKOnly

    checkErrorMain = -1

End Function

' シート登録メイン処理
Public Function registerSheetMain() As Long
    Dim ret As Long: ret = 0
    Dim rec As Long
    Dim sheetName As String
    Dim regNendo As String
    Dim sheetId As String                   ' 作成対象のSHEET_ID
    Dim operationCd As String               ' 作成対象のシートの運用コード
    Dim formCd As String                    ' 作成対象のシートの書式コード
    Dim regUser As String
    Dim errMsg As String: errMsg = ""
    
    Dim sheets As Dictionary
    Dim key As Variant
    Dim info As Variant
    
    Dim row As Long: row = 0
    Dim regData As Collection
    
    On Error GoTo registerSheetMain_Err

    Set sheets = m_MainSheetView.getMaruCheckedSheets()
    
    ' CS_RSVテーブルに登録するためのRSV_ID, RSV_USER用の変数定義
    regUser = "SYSTEM_" & format(Now, "yyyymmddhhnnss")


    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual

    ' "○"の付いているシートを登録対象に
    For Each key In sheets
        checkEvents

        m_DbConnect.beginTransaction

        For Each info In sheets.Item(key)
            sheetName = info
            regNendo = sheets.Item(key).Item(info)
        Next info

        ' 評価シート名ではないので注意（シートの見出し名称）
        m_EvalSheetView.sheetName = key

        ' シートの内容をRegSheetIndoDto のオブジェクト配列に変換する
        Set regData = m_EvalSheetView.getSheetDataToRegSheetInfoDto

        For row = 1 To regData.Count
            checkEvents

            Application.StatusBar = "評価シート【" & sheetName & "】 " & row & "レコード目を処理中...."

            formCd = getSheetFormCd(sheetName, regData(row).format)
            operationCd = getSheetOperationCd(regData(row).party, regNendo, sheetName)
            Call m_DbConnect.getCsSlcSheet(regData(row).party, operationCd, regData(row).guid, sheetId, "", "", "")

            If Len(sheetId) > 0 Then
                ' 入力されたシートの情報を予約テーブルへ
                Call createSheetReserve(sheetId, operationCd, formCd, regData(row), regUser)
            End If
        Next row

        ' 以降の例外発生時の行位置表示のため、0にリセット
        row = 0

        Application.StatusBar = "評価シート【" & sheetName & "】 のデータを登録中...."

        ' 予約テーブルからCST_XXXXテーブルへ（既存のパッケージ呼び出し）
        Call migrateSheetReserve(regUser)

        ' 登録結果をメインシートに書き込み
        Call m_MainSheetView.outputRegResult(sheetName, regData.Count)

        ' ここでこれまでのトランザクションをコミット
        m_DbConnect.commitTransaction

        Set regData = Nothing

        m_DbConnect.beginTransaction

        Call m_DbConnect.copySheetFillViewToFillTbl(regUser)

        Call m_DbConnect.deleteSheetFillReserve(regUser)

        m_DbConnect.commitTransaction

    Next key

    Application.StatusBar = False

    Application.ScreenUpdating = True
    Application.Calculation = xlCalculationAutomatic

    Set sheets = Nothing

    registerSheetMain = 0

    Exit Function

registerSheetMain_Err:
    Set regData = Nothing
    Set sheets = Nothing

    m_DbConnect.rollbackTransaction

    ' エラーが発生しました。発生個所は、{0:評価シート名}Sheetの{1:行位置}番目の行です。oracleエラー内容
    errMsg = Replace(Replace(ERR_DB_UNEXPECTED, "{0}", sheetName), "{1}", CStr(row))

    MsgBox errMsg & vbCrLf & Err.Description, vbCritical + vbOKOnly

    registerSheetMain = -1

End Function

' メインシートに"○"がつけられたシートが登録可能であるか、エラー一覧シートをもとに判定する
' 戻り値： TRUE  : 後続処理を実行
'          FALSE : 後続処理を実行しない
Public Function isRegisteredMaruCheckSheets() As Boolean
    Dim status As Long
    Dim sheetName As String
    Dim checked As Boolean: checked = True
    Dim canRegister As Long: canRegister = CHK_SHEET_STATUS.CHECK_OK
    
    Dim sheets As Dictionary
    Dim sheet As Variant
    Dim name As Variant
    
    On Error GoTo isRegisteredMaruCheckSheets_Err
    
    Set sheets = m_MainSheetView.getMaruCheckedSheets()

    If sheets.Count = 0 Then
        ' ○がひとつも付いていないとき
        MsgBox "登録対象が選択されていません。", vbExclamation + vbOKOnly
        isRegisteredMaruCheckSheets = False
        Exit Function
    End If
    
    For Each sheet In sheets
        For Each name In sheets.Item(sheet)
            sheetName = name
        Next name

        status = m_ErrListView.getStatusCheckedSheet(sheetName)
        If status = CHK_SHEET_STATUS.CHECK_ERROR Then
            ' 1シートでもチェックエラーがあれば、登録不可
            canRegister = CHK_SHEET_STATUS.CHECK_ERROR
        ElseIf (canRegister = CHK_SHEET_STATUS.CHECK_OK Or canRegister = CHK_SHEET_STATUS.CHECK_WARNING) And status = CHK_SHEET_STATUS.CHECK_WARNING Then
            '
            canRegister = CHK_SHEET_STATUS.CHECK_WARNING
        ElseIf canRegister = CHK_SHEET_STATUS.CHECK_OK And status = CHK_SHEET_STATUS.CHECK_OK Then
            canRegister = CHK_SHEET_STATUS.CHECK_OK
        End If
    Next sheet

    Set sheets = Nothing

    ' 登録不可（エラーあり）、登録可（警告あり）、登録可（警告なし）のどれか
    If canRegister = CHK_SHEET_STATUS.CHECK_ERROR Then
        ' 「異常エラーが存在します。エラー一覧シートを確認してください。"」
        MsgBox REGISTRATION_ERR_MSG, vbExclamation + vbOKOnly
        checked = False
    ElseIf canRegister = CHK_SHEET_STATUS.CHECK_WARNING Then
        ' 「警告エラーが存在します。登録してよろしいですか。」
        If MsgBox(REGISTRATION_WARN_MSG, vbYesNo + vbQuestion) = vbNo Then
            checked = False
        End If
    End If
    
    isRegisteredMaruCheckSheets = checked
    
    Exit Function

isRegisteredMaruCheckSheets_Err:
    Err.Raise Err.Number, "isRegisteredMaruCheckSheets", Err.Description

End Function

' 予約テーブルにシートの情報を登録する
'  @sheetId シートID
'  @operCd 運用コード
'  @formCd 書式コード
'  @regData 入力データ
'  @regUser 予約ユーザ
Private Sub createSheetReserve(sheetId As String, operCd As String, formCd As String, regData As RegSheetInfoDto, regUser As String)

    On Error GoTo createSheetReserve_Err

    ' 新規/更新問わず、CST_SHEETに登録されているレコードをいったん削除
    Call m_DbConnect.deleteCstSheet(sheetId, regData.party)

    ' CS_RSV_DSTRBTへシートの情報を登録
    Call m_DbConnect.createSheetReserve(sheetId, operCd, formCd, regData, regUser)

    ' CS_RSV_ACTORへ評価者を登録
    Call m_DbConnect.createActorReserve(sheetId, regData, regUser)

    ' CS_RSV_FILLへシート回答を登録
    Call m_DbConnect.createFillReserve(sheetId, regData, regUser)

    ' CS_RSV_FILL に"RelatedSheetID-xxxxx"のレコードを作成
    Call m_DbConnect.createRelatedSheetFillData(regData.party, operCd, regData.guid, sheetId, regUser)

    Exit Sub

createSheetReserve_Err:
    Err.Raise Err.Number, "createSheetReserve", Err.Description
    
End Sub

' 配布予約テーブルからCST_SHEET_XXXへデータをコピーする
'  CS_RSV_DSTRBT, CS_RSV_ACTORは、コピー後にデータを破棄する（シート回答予約データは破棄しない）
'  @regUser 予約ユーザ
Private Sub migrateSheetReserve(regUser As String)

    On Error GoTo migrateSheetReserve_Err

    ' CS_RSV_DSTRBT → CST_SHEET
    Call m_DbConnect.migrateSheetReserve(regUser)

    ' CS_RSV_ACTOR → CST_SHEET_ACTOR
    Call m_DbConnect.migrateActorReserve(regUser)

    ' CS_RSV_FILL → CST_SHEET_FILL
    Call m_DbConnect.migrateSheetFillReserve(regUser)

    Exit Sub

migrateSheetReserve_Err:
    Err.Raise Err.Number, "migrateSheetReserve", Err.Description

End Sub

' 事前に取得したチェック条件をもとにしてシートのチェックを行う
'  @sheetName 評価シート名
'  @chkRules チェック条件
'
'  戻り値：チェックエラー結果
Public Function checkSheetError(sheetName As String, chkRules As Dictionary) As CheckResults
    Dim chkRslts As CheckResults
    Dim chkRule As CheckRuleDto
    Dim chkedGuids() As String: ReDim chkedGuids(0)
    Dim phyColNames() As Variant
    Dim sheetData() As Variant
    Dim phyColName As Variant
    Dim rowData As Variant
    Dim row As Long
    Dim chkValue As String
    Dim party As String
    Dim reg As RegExp

    On Error GoTo checkSheetError_Err

    Set chkRslts = New CheckResults

    ' チェックする物理項目名（の配列）
    phyColNames = chkRules.keys

    sheetData = m_EvalSheetView.getSheetArrayData()

    For row = START_DATA_ROW To UBound(sheetData, 1)
        Application.StatusBar = "評価シート【" & sheetName & "】のチェック中.... " & CStr(row) & "行目"

        For Each phyColName In phyColNames
            DoEvents

            Set chkRule = chkRules(phyColName)

            chkValue = CStr(sheetData(row, chkRule.ColIndex))

            If chkRule.isCheck() = True Then
                ' 未入力チェック
                If chkRule.isRequire() = True And Len(chkValue) = 0 Then
                    ' {0}が未入力です（{0}は論理項目名に置き換え）
                    Call chkRslts.addCheckResult(sheetName, CStr(row), ERROR_TYPE.CHK_ERROR, Replace(ERR_MISSING, "{0}", chkRule.ColLgcName))
                End If

                ' 文字の入力があるものに対してチェックを行う
                If Len(chkValue) > 0 Then
                    If StrComp(chkRule.ColLgcName, CHK_COLUMN_PARTY, vbTextCompare) = 0 Then
                        party = chkValue
                    End If

                    ' GIDに関するチェック
                    If StrComp(chkRule.ColLgcName, CHK_COLUMN_GID, vbTextCompare) = 0 Or StrComp(chkRule.ColPhyName, CHK_COLUMN_GID, vbTextCompare) = 0 Then
                        ' 入力されたGUIDはシートの作成対象か
                        ' GIDが入力された時点で当該GIDがシートの作成対象かチェックする
                        If isSheetCreated(CStr(sheetData(row, 2)), CStr(sheetData(row, 3)), CStr(sheetData(row, 4)), sheetName) = False Then
                            Call chkRslts.addCheckResult(sheetName, CStr(row), ERROR_TYPE.CHK_ERROR, ERR_NOT_CREATE_TARGET)
                        End If

                        ' 入力済みのGIDに対して同一のGIDが複数存在していないか
                        If isExistSameGuid(chkedGuids, chkValue) = True Then
                            Call chkRslts.addCheckResult(sheetName, CStr(row), ERROR_TYPE.CHK_ERROR, ERR_SAME_GID)
                        Else
                            chkedGuids(UBound(chkedGuids)) = chkValue
                            ReDim Preserve chkedGuids(UBound(chkedGuids) + 1)
                        End If
                    End If
                    
                    ' 1～4次評価者に関するチェック
                    If StrComp(chkRule.ColPhyName, CHK_COLUMN_ACTOR_1ST, vbTextCompare) = 0 Or _
                        StrComp(chkRule.ColPhyName, CHK_COLUMN_ACTOR_2ND, vbTextCompare) = 0 Or _
                        StrComp(chkRule.ColPhyName, CHK_COLUMN_ACTOR_3RD, vbTextCompare) = 0 Or _
                        StrComp(chkRule.ColPhyName, CHK_COLUMN_ACTOR_4TH, vbTextCompare) = 0 Then
                        If m_DbConnect.isRegisteredGid(party, chkValue) = False Then
                            Call chkRslts.addCheckResult(sheetName, CStr(row), ERROR_TYPE.CHK_WARNING, Replace(ERR_NOT_EXIST_GID, "{0}", chkRule.ColLgcName))
                        End If
                    End If

                    ' 改行文字を許可しないとき、該当文字に改行が含まれていないか
                    If chkRule.isCrLf() = False Then
                        If InStr(chkValue, vbCrLf) > 0 Or InStr(chkValue, vbCr) > 0 Or InStr(chkValue, vbLf) > 0 Then
                            ' {0}に改行文字が含まれています。改行文字は使用できません。（{0}は論理項目名に置き換え）
                            Call chkRslts.addCheckResult(sheetName, CStr(row), ERROR_TYPE.CHK_ERROR, Replace(ERR_INPUT_CRLF, "{0}", chkRule.ColLgcName))
                        End If
                    End If
                
                    ' 入力文字数のチェック
                    If chkRule.MaxLength() > 0 Then
                        If Len(chkValue) > chkRule.MaxLength Then
                            ' {0}は{1}文字以内で入力してください。（{0}は論理項目名、{1}は制限文字数に置き換え）
                            Call chkRslts.addCheckResult(sheetName, CStr(row), ERROR_TYPE.CHK_ERROR, Replace(Replace(ERR_MAX_LENGTH, "{0}", chkRule.ColLgcName), "{1}", CStr(chkRule.MaxLength)))
                        End If
                    End If
                    
                    ' 入力形式のチェック
                    If Len(chkRule.RegPattern()) > 0 Then
                        Set reg = New RegExp
                        
                        reg.pattern = chkRule.RegPattern

                        If reg.Test(chkValue) = False Then
                            ' {0}の入力形式に誤りがあります。（{0}は論理項目名に置き換え）
                            Call chkRslts.addCheckResult(sheetName, CStr(row), ERROR_TYPE.CHK_ERROR, Replace(ERR_INVALID_FORMAT, "{0}", chkRule.ColLgcName))
                        End If
                        
                        Set reg = Nothing
                    End If
                End If
            End If
            Set chkRule = Nothing
        Next phyColName

        Application.StatusBar = False
    Next row

    Erase chkedGuids

    Set checkSheetError = chkRslts

    Exit Function

checkSheetError_Err:
    Erase chkedGuids
    Set chkRule = Nothing
    Set reg = Nothing

    Err.Raise Err.Number, "checkSheetError", Err.Description

End Function

' 指定したGIDですでに作詞指示がされているかどうか？
'  @guids 作成指示済みのGID
'  @chkGuid チェックGID
'
'  戻り値：TRUE（すでに作成指示済み）、FALSE（未指示）
Private Function isExistSameGuid(guids() As String, chkGuid As String) As Boolean
    Dim bExist As Boolean: bExist = False
    Dim guid As Variant

    For Each guid In guids
        If StrComp(guid, chkGuid, vbTextCompare) = 0 Then
            bExist = True
            Exit For
        End If
    Next guid

    isExistSameGuid = bExist
End Function

' シートが作成対象かチェックする
'  @party PARTY
'  @gid GID
'  @format フォーマット
'  @sheetName 評価シート名
'
'  戻り値：TRUE（作成可）、FALSE（作成不可）
Private Function isSheetCreated(ByVal party As String, ByVal gid As String, ByVal format As String, ByVal sheetName As String) As Boolean
    On Error GoTo isSheetCreated_Err

    Dim sheetId As String
    Dim defFormCd As String, defStatusCd As String, defFlowPtn As String            ' 使用しない

    '入力シートの行をそのまま読み込んでいるので０始まりの列位置で指定する
    Dim nendo As String: nendo = m_MainSheetView.getSheetNendo(sheetName)

    Dim operCd As String: operCd = getSheetOperationCd(party, nendo, sheetName)

    Call m_DbConnect.getCsSlcSheet(party, operCd, gid, sheetId, defFormCd, defStatusCd, defFlowPtn)

    isSheetCreated = m_DbConnect.IsExistSlcDstrbt(party, operCd, sheetId)

    Exit Function

isSheetCreated_Err:
    Err.Raise Err.Number, "isSheetCreated", Err.Description

End Function

