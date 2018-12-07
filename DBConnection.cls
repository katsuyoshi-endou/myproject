VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "DBConnection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' データベース関連のクラス

Private m_connection As ADODB.connection        ' データベースコネクション
Private ConnectStr As String                    ' 接続文字列

' コンストラクタ
Private Sub Class_Initialize()
End Sub

' デストラクタ
Private Sub Class_Terminate()
    Call closeConnection
End Sub

' 接続文字列を設定する
'  @接続文字列
Public Sub setConnectString(connStr As String)
    ConnectStr = connStr
End Sub

' データベースコネクションを返す
Public Function getConnection() As ADODB.connection
    Set getConnection = m_connection
End Function

' データベースに接続する
Public Sub openConnection()
    On Error GoTo openConnection_Err
    
    ' 接続文字列指定なし
    If Len(ConnectStr) = 0 Then
        Exit Sub
    End If

    Set m_connection = New ADODB.connection
    
    ' すでに接続済み
    If m_connection.State = ADODB.ObjectStateEnum.adStateOpen Then
        Exit Sub
    End If

    m_connection.ConnectionString = ConnectStr
    m_connection.Open
    
    Exit Sub

openConnection_Err:
    Err.Raise Err.Number, "openConnection", Err.Description

End Sub

' データベースをクローズする
Public Sub closeConnection()
    If Not (m_connection Is Nothing) Then
        If m_connection.State = ADODB.ObjectStateEnum.adStateOpen Then
            m_connection.Close
        
            Set m_connection = Nothing
        End If
    End If
End Sub

' データベースとの接続がオープンであるかを返す
Public Function isOpen() As Boolean
    Dim ret As Boolean
    
    ret = False
    If m_connection.State = ADODB.ObjectStateEnum.adStateOpen Then
        ret = True
    End If

    isOpen = ret
End Function

' トランザクションを開始する
Public Sub beginTransaction()
    If isOpen() = True Then
        m_connection.BeginTrans
    End If
End Sub

' トランザクションをコミットする
Public Sub commitTransaction()
    If isOpen() = True Then
        m_connection.CommitTrans
    End If
End Sub

' トランザクションをロールバックする
Public Sub rollbackTransaction()
    If isOpen() = True Then
        m_connection.RollbackTrans
    End If
End Sub

' シート配布予約データを作成する
'  @sheetId シートID
'  @operCd 運用コード
'  @formCd 書式コード
'  @regData 入力データ
'  @regUser 予約ユーザ（予約テーブルのRSV_ID, RSV_USERで兼用）
Public Sub createSheetReserve(sheetId As String, operCd As String, formCd As String, regData As RegSheetInfoDto, regUser As String)
    Dim cmd As ADODB.Command
    Dim sql As String

    On Error GoTo createSheetReserve_Err

    Set cmd = New ADODB.Command

    sql = "INSERT INTO CS_RSV_DSTRBT( RSV_ID, RSV_USER, SHEET_ID, PARTY, OPERATION_CD, FORM_CD, GUID, STATUS_CD, FLOW_PTN ) VALUES( "

    sql = sql & "'" & regUser & "', "                   ' RSV_ID(REG_USERをセットする)
    sql = sql & "'" & regUser & "', "                   ' RSV_USER
    sql = sql & "'" & sheetId & "', "                   ' SHEET_ID
    sql = sql & "'" & regData.party & "', "             ' PARTY
    sql = sql & "'" & operCd & "', "                    ' OPERATION_CD
    sql = sql & "'" & formCd & "', "                    ' FORM_CD
    sql = sql & "'" & regData.guid & "', "              ' GUID
    sql = sql & "'" & regData.statusCd & "', "          ' STATUS_CD
    sql = sql & "'" & regData.flowPtn & "' )"           ' FLOW_PTN

    With cmd
        .ActiveConnection = m_connection
        .CommandText = sql
        .CommandType = adCmdText

        .Execute
    End With

    Exit Sub

createSheetReserve_Err:
    Set cmd = Nothing

    Err.Raise Err.Number, "createSheetReserve", Err.Description

End Sub

' シート配布データ反映
' 既存パッケージの「PLPKG_MIG_CS_DSTRBT.MAIN」を呼び出す
'  @regUser 予約ユーザ
Public Sub migrateSheetReserve(regUser As String)
    Dim ret As Long: ret = 0
    Dim sql As String
    Dim cmd As ADODB.Command

    On Error GoTo migrateSheetReserve_Err

    Set cmd = New ADODB.Command
    
    With cmd
        .CommandTimeout = 0
        .ActiveConnection = m_connection
        .CommandText = "PLPKG_MIG_CS_DSTRBT.MAIN"
        .CommandType = adCmdStoredProc

        .Parameters.Append .CreateParameter("rtn", adInteger, adParamReturnValue)

        .Parameters.Append .CreateParameter("vRsvUser", adVarChar, adParamInput, 40, regUser)
        .Parameters.Append .CreateParameter("vExecFunc", adVarChar, adParamInput, 40, "")
        
        .Execute

        If .Parameters.Item("rtn").value <> 0 Then
            GoTo PACKAGE_CALL_ERR
        End If
    End With

    Set cmd = Nothing

    Exit Sub

PACKAGE_CALL_ERR:
    Set cmd = Nothing

    Err.Raise USER_ERR_CD_PACKAGE_CALL, "migrateSheetReserve", Replace(USER_ERR_MSG_PACKAGE_CALL, "{0}", "PLPKG_MIG_CS_DSTRBT.MAIN")

    Exit Sub

migrateSheetReserve_Err:
    Set cmd = Nothing

    Err.Raise Err.Number, "migrateSheetReserve", Err.Description

End Sub

' シートを削除する
'  @sheetId シートID
'  @party PARTY
Public Sub deleteCstSheet(sheetId As String, party As String)
    Dim cmd As ADODB.Command
    Dim sql As String

    On Error GoTo deleteCstSheet_Err

    Set cmd = New ADODB.Command

    With cmd
        sql = "DELETE FROM CST_SHEET WHERE SHEET_ID = '" & sheetId & "' "
        sql = sql & "AND PARTY = '" & party & "'"

        .ActiveConnection = m_connection
        .CommandType = adCmdText
        .CommandText = sql

        .Execute
    End With

    Set cmd = Nothing

    Exit Sub

deleteCstSheet_Err:
    Set cmd = Nothing

    Err.Raise Err.Number, "deleteCsSheet", Err.Description

End Sub

' アクター予約データを作成する
'  @sheetId シートID
'  @regData 入力データ
'  @regUser 予約ユーザ
Public Sub createActorReserve(sheetId As String, regData As RegSheetInfoDto, regUser As String)
    Dim cmd As ADODB.Command
    Dim sql As String
    Dim actSql As String
    
    On Error GoTo createActorReserve_Err

    Set cmd = New ADODB.Command

    sql = "INSERT INTO CS_RSV_ACTOR( RSV_ID, RSV_USER, SHEET_ID, ACTOR_CD, GUID ) VALUES( '00000', '" & regUser & "', '" & sheetId & "'"

    With cmd
        .ActiveConnection = m_connection
        .CommandType = adCmdText

        ' act-owner
        actSql = sql & ", 'act-owner', '" & regData.guid & "' )"
        .CommandText = actSql
        .Execute

        ' act-jinji（'ZZZZZZ'で登録）
        actSql = sql & ", 'act-jinji', '" & JINJI_USER_ID & "' )"
        .CommandText = actSql
        .Execute

        ' 1次評価者
        actSql = sql & ", 'act-1st', '" & regData.actor1st & "' )"
        .CommandText = actSql
        .Execute

        ' 2次評価者
        actSql = sql & ", 'act-2nd', '" & regData.actor2nd & "' )"
        .CommandText = actSql
        .Execute

        ' 3次評価者
        actSql = sql & ", 'act-3rd', '" & regData.actor3rd & "' )"
        .CommandText = actSql
        .Execute

        ' 4次評価者
        actSql = sql & ", 'act-4th', '" & regData.actor4th & "' )"
        .CommandText = actSql
        .Execute
    End With

    Set cmd = Nothing

    Exit Sub

createActorReserve_Err:
    Set cmd = Nothing

    Err.Raise Err.Number, "createActorReserve", Err.Description

End Sub

' アクター配布データ反映
' 既存パッケージの「PLPKG_MIG_CS_ACTOR.MAIN」を呼び出す
'  @regUser 予約ユーザ
Public Sub migrateActorReserve(regUser As String)
    Dim ret As Long: ret = 0
    Dim cmd As ADODB.Command
    Dim sql As String

    On Error GoTo migrateActorReserve_Err

    Set cmd = New ADODB.Command
    
    With cmd
        .CommandTimeout = 0
        .ActiveConnection = m_connection
        .CommandText = "PLPKG_MIG_CS_ACTOR.MAIN"
        .CommandType = adCmdStoredProc

        .Parameters.Append .CreateParameter("rtn", adInteger, adParamReturnValue)

        .Parameters.Append .CreateParameter("vRsvUser", adVarChar, adParamInput, 40, regUser)
        .Parameters.Append .CreateParameter("vKeepOrClear", adVarChar, adParamInput, 10, "CLEAR")
        .Parameters.Append .CreateParameter("vExecfunc", adVarChar, adParamInput, 40, "")
        
        .Execute

        If .Parameters.Item("rtn").value <> 0 Then
            GoTo PACKAGE_CALL_ERR
        End If
    End With

    Set cmd = Nothing

    Exit Sub

PACKAGE_CALL_ERR:
    Set cmd = Nothing

    Err.Raise USER_ERR_CD_PACKAGE_CALL, "migrateActorReserve", Replace(USER_ERR_MSG_PACKAGE_CALL, "{0}", "PLPKG_MIG_CS_ACTOR.MAIN")

    Exit Sub

migrateActorReserve_Err:
    Set cmd = Nothing

    Err.Raise Err.Number, "migrateActorReserve", Err.Description

End Sub

' シートアクターを削除する
'  @sheetId シートID
Public Sub deleteSheetActor(sheetId As String)
    Dim cmd As ADODB.Command
    Dim sql As String

    On Error GoTo deleteSheetActor_Err

    Set cmd = New ADODB.Command

    With cmd
        sql = "DELETE FROM CST_SHEET_ACTOR WHERE SHEET_ID = '" & sheetId & "'"

        .ActiveConnection = m_connection
        .CommandType = adCmdText
        .CommandText = sql

        .Execute
    End With

    Set cmd = Nothing

    Exit Sub

deleteSheetActor_Err:
    Set cmd = Nothing

    Err.Raise Err.Number, "deleteSheetActor", Err.Description

End Sub

' シート回答予約データ作成
'  @sheetId シートID
'  @regData nyuuryokude-ta
'  @regUser 予約ユーザ
Public Sub createFillReserve(sheetId As String, regData As RegSheetInfoDto, regUser As String)
    Dim cmd As ADODB.Command
    Dim fillData As Dictionary
    Dim key As Variant
    Dim sql As String
    Dim fillContent As String

    On Error GoTo createFillReserve_Err

    Set cmd = New ADODB.Command

    With cmd
        .ActiveConnection = m_connection
        .CommandType = adCmdText

        Set fillData = regData.fillData

        For Each key In fillData
            fillContent = CStr(fillData.Item(key))

            sql = "INSERT INTO CS_RSV_FILL( RSV_ID, RSV_USER, SHEET_ID, FILL_ID, FILL_CONTENT ) VALUES( "
            sql = sql & "'" & regUser & "', "               ' RSV_ID(RSV_USERをそのままセット)
            sql = sql & "'" & regUser & "', "               ' RSV_USER
            sql = sql & "'" & sheetId & "', "               ' SHEET_ID
            sql = sql & "'" & CStr(key) & "', "             ' FILL_ID
            sql = sql & "'" & fillContent & "' "            ' FILL_CONTENT
            sql = sql & ")"

            .CommandText = sql

            .Execute
        Next key

        Set fillData = Nothing
    End With

    Set cmd = Nothing

    Exit Sub

createFillReserve_Err:
    Set fillData = Nothing
    Set cmd = Nothing

    Err.Raise Err.Number, "createFillReserve", Err.Description

End Sub

' シート回答予約データを反映する
'  @regUser 予約ユーザ
Public Sub migrateSheetFillReserve(regUser As String)
    Dim cmd As ADODB.Command
    Dim sql As String

    On Error GoTo migrateSheetFillReserve_Err

    Set cmd = New ADODB.Command

    With cmd
        .ActiveConnection = m_connection
        .CommandType = adCmdText

        sql = "DELETE FROM CST_SHEET_FILL CSF "
        sql = sql & " WHERE EXISTS "
        sql = sql & " ( "
        sql = sql & "     SELECT * FROM CS_RSV_FILL CRF WHERE CSF.SHEET_ID = CRF.SHEET_ID AND CRF.RSV_USER = '" & regUser & "' "
        sql = sql & " )"

        .CommandText = sql

        .Execute

        sql = "INSERT INTO CST_SHEET_FILL( SHEET_ID, FILL_ID, FILL_CONTENT ) SELECT SHEET_ID, FILL_ID, FILL_CONTENT FROM CS_RSV_FILL WHERE RSV_USER = '" & regUser & "'"

        .CommandText = sql

        .Execute
    End With

    Set cmd = Nothing

    Exit Sub

migrateSheetFillReserve_Err:
    Set cmd = Nothing

    Err.Raise Err.Number, "migrateSheetFillReserve", Err.Description

End Sub

' シート回答予約データを削除する
'  @regUser 予約ユーザ
Public Sub deleteSheetFillReserve(regUser As String)
    Dim cmd As ADODB.Command
    Dim sql As String

    On Error GoTo deleteSheetFillReserve_Err

    Set cmd = New ADODB.Command

    sql = "DELETE FROM CS_RSV_FILL WHERE RSV_USER = '" & regUser & "'"

    With cmd
        .ActiveConnection = m_connection
        .CommandType = adCmdText
        .CommandText = sql

        .Execute
    End With

    Set cmd = Nothing

    Exit Sub

deleteSheetFillReserve_Err:
    Set cmd = Nothing

    Err.Raise Err.Number, "deleteSheetFillReserve", Err.Description

End Sub

' 指定されたシートがシート配布断面（AR_SLC_CS_DSTRBT）に存在するか？
'  @party PARTY
'  @operCd 運用コード
'  @sheetId シートID
'
'  戻り値：TRUE（存在する）、FALSE（存在しない）
Public Function IsExistSlcDstrbt(party As String, operCd As String, sheetId As String) As Boolean
    Dim bExist As Boolean: bExist = False
    Dim sql As String
    
    On Error GoTo IsExistSlcDstrbt_Err
    
    Dim cmd As ADODB.Command
    Dim rs As ADODB.Recordset
    
    If Len(party) = 0 Or Len(operCd) = 0 Or Len(sheetId) = 0 Then
        IsExistSlcDstrbt = False
        Exit Function
    End If

    If isOpen = True Then
        Set cmd = New ADODB.Command
        
        sql = "SELECT COUNT(*) FROM AR_SLC_CS_DSTRBT"
        sql = sql & " WHERE SLC_PARTY = '" & party & "'"
        sql = sql & " AND SLC_OPERATION_CD = '" & operCd & "'"
        sql = sql & " AND SHEET_ID = '" & sheetId & "'"

        With cmd
            .ActiveConnection = m_connection
            .CommandText = sql
            .CommandType = adCmdText

            Set rs = .Execute
        End With

        If rs.Fields(0).value > 0 Then
            bExist = True
        End If

        rs.Close

        Set rs = Nothing
        Set cmd = Nothing
    End If
    
    IsExistSlcDstrbt = bExist
    
    Exit Function
    
IsExistSlcDstrbt_Err:
    Set rs = Nothing
    Set cmd = Nothing
    
    Err.Raise Err.Number, "IsExistSlcDstrbt", Err.Description

End Function

' 指定されたGIDがキャリア人テーブルに存在するか？
'  （PARTY, GIDが一致し、在籍フラグが'1'のユーザ）
'  @party PARTY
'  @gid GID
'
'  戻り値：TRUE（存在する）、FALSE（存在しない）
Public Function isRegisteredGid(party As String, gid As String) As Boolean
    Dim bRegistered As Boolean: bRegistered = False
    Dim sql As String

    Dim cmd As ADODB.Command
    Dim rs As ADODB.Recordset

    On Error GoTo isRegisteredGid_Err

    If Len(party) = 0 Or Len(gid) = 0 Then
        isRegisteredGid = False
        Exit Function
    End If

    Set cmd = New ADODB.Command

    sql = "SELECT COUNT(*) FROM CA_REGIST CR LEFT JOIN CA_PARTY_COMPANY CPC ON CR.CMPA_CD = CPC.CMPA_CD "
    sql = sql & " WHERE CPC.PARTY = '" & party & "'"
    sql = sql & " AND CR.REGIST_FLG = '1'"
    sql = sql & " AND CR.GUID = '" & gid & "'"

    With cmd
        .ActiveConnection = m_connection
        .CommandType = adCmdText
        .CommandText = sql
        .Prepared = True

        Set rs = .Execute
    End With

    If rs.Fields(0).value > 0 Then
        bRegistered = True
    End If

    rs.Close

    Set rs = Nothing
    Set cmd = Nothing

    isRegisteredGid = bRegistered

    Exit Function

isRegisteredGid_Err:
    Set rs = Nothing
    Set cmd = Nothing

    Err.Raise Err.Number, "isRegisteredGid", Err.Description

End Function

' 指定されたPARTY, 運用コード, GIDに一致するシートの情報をCSシート断面より取得する
'  一致するシートが存在しないとき、第４引数以降が""（空欄）となる
'  @party PARTY
'  @operCd 運用コード
'  @gid GID
'  @sheetId シートID（戻り値用）
'  @formCd 書式コード（戻り値用）
'  @statusCd ステータスコード（戻り値用）
'  @flowPtn フローパターン
Public Sub getCsSlcSheet(ByVal party As String, ByVal operCd As String, ByVal gid As String, ByRef sheetId As String, ByRef formCd As String, ByRef statusCd As String, ByRef flowPtn As String)
    Dim cmd As ADODB.Command
    Dim rs As ADODB.Recordset

    Dim sql As String

    ' PARTY, OPERATION_CD, GUID のどれかが未指定なら検索せずに終了させる
    If Len(party) = 0 Or Len(operCd) = 0 Or Len(gid) = 0 Then
        sheetId = ""
        formCd = ""
        statusCd = ""
        flowPtn = ""

        Exit Sub
    End If

    sql = "SELECT SHEET_ID, DEFAULT_FORM_CD, DEFAULT_STATUS_CD, DEFAULT_FLOW_PTN FROM AR_SLC_CS_SHEET"
    sql = sql & " WHERE SLC_PARTY = '" & party & "'"
    sql = sql & " AND SLC_OPERATION_CD = '" & operCd & "'"
    sql = sql & " AND GUID = '" & gid & "'"

    On Error GoTo getCsSlcSheet_Err

    Set cmd = New ADODB.Command

    With cmd
        .ActiveConnection = m_connection
        .CommandType = adCmdText
        .CommandText = sql

        Set rs = .Execute

        Do Until rs.EOF
            sheetId = rs.Fields("SHEET_ID").value
            formCd = rs.Fields("DEFAULT_FORM_CD").value
            statusCd = rs.Fields("DEFAULT_STATUS_CD").value
            flowPtn = rs.Fields("DEFAULT_FLOW_PTN").value

            Exit Do
        Loop
    End With

    Set rs = Nothing
    Set cmd = Nothing

    Exit Sub

getCsSlcSheet_Err:
    Set rs = Nothing
    Set cmd = Nothing

    Err.Raise Err.Number, "getCsSlcSheet", Err.Description
End Sub

' V_CST_SHEET_FILL_AUTO（ビュー）からCST_SHEET_FILL_AUTO（物理テーブル）へのコピー
'  @regUser 予約ユーザ
Public Sub copySheetFillViewToFillTbl(regUser As String)
    Dim cmd As ADODB.Command
    Dim sql As String

    On Error GoTo copySheetFillViewToFillTbl_Err

    Set cmd = New ADODB.Command

    With cmd
        .ActiveConnection = m_connection
        .CommandType = adCmdText

        ' CS_RSV_FILLに存在するシートIDが合致するシート回答情報をCST_SHEET_FILL_AUTOから削除する
        sql = "DELETE FROM CST_SHEET_FILL_AUTO CSFA "
        sql = sql & " WHERE EXISTS "
        sql = sql & " ( "
        sql = sql & "     SELECT * FROM CS_RSV_FILL CRF WHERE CSFA.SHEET_ID = CRF.SHEET_ID AND CRF.RSV_USER = '" & regUser & "' "
        sql = sql & " )"

        .CommandText = sql

        .Execute

        ' CS_RSV_FILLに存在するシートIDが合致するシート回答情報をV_CST_SHEET_FILL_AUTOからコピーする
        sql = "INSERT INTO CST_SHEET_FILL_AUTO "
        sql = sql & " ( "
        sql = sql & " SELECT * FROM V_CST_SHEET_FILL_AUTO VCSFA "
        sql = sql & "     WHERE EXISTS "
        sql = sql & "     ( "
        sql = sql & "         SELECT * FROM CS_RSV_FILL CRF WHERE VCSFA.SHEET_ID = CRF.SHEET_ID AND CRF.RSV_USER = '" & regUser & "'"
        sql = sql & "     ) "
        sql = sql & " )"

        .CommandText = sql

        .Execute
    End With

    Set cmd = Nothing

    Exit Sub

copySheetFillViewToFillTbl_Err:
    Set cmd = Nothing

    Err.Raise Err.Number, "copySheetFillViewToFillTbl", Err.Description

End Sub

' シート回答予約テーブルにRelatedSheetID-XXXレコードを作成する
'  @party PARTY
'  @operCd 運用コード
'  @gid GID
'  @sheetId シートID
'  @regUser 予約ユーザ
Public Sub createRelatedSheetFillData(party As String, operCd As String, gid As String, sheetId As String, regUser As String)
    Dim sql As String
    Dim relId As String: relId = ""
    Dim relOperCd As String: relOperCd = ""
    Dim relSheetId As String
    Dim relFormCD As String, relStatusCd As String, relFlowPtn As String
    Dim cmd As ADODB.Command
    Dim rs As ADODB.Recordset

    On Error GoTo createRelatedSheetFillData_Err

    Set cmd = New ADODB.Command

    With cmd
        .ActiveConnection = m_connection
        .CommandType = adCmdText

        sql = "SELECT PARTY, OPERATION_CD, RELATED_ID, RELATED_OPERATION_CD FROM UP_DF_CS_RELATED_OPERATION WHERE PARTY = '" & party & "' AND OPERATION_CD = '" & operCd & "'"

        .CommandText = sql

        Set rs = .Execute

        Do Until rs.EOF
            If rs.Fields(2).value Like "PAST*" Then
                relId = CStr(rs.Fields(2).value)
                relOperCd = CStr(rs.Fields(3).value)

                Exit Do
            End If

            rs.MoveNext
        Loop

        Set rs = Nothing

        If relId <> "" Then
            Call getCsSlcSheet(party, relOperCd, gid, relSheetId, relFormCD, relStatusCd, relFlowPtn)

            If relSheetId <> "" And Len(relSheetId) > 0 Then
                sql = "INSERT INTO CS_RSV_FILL( RSV_ID, RSV_USER, SHEET_ID, FILL_ID, FILL_CONTENT ) VALUES( "
                sql = sql & "'" & regUser & "', "                       ' RSV_ID(RSV_USERをそのままセット)
                sql = sql & "'" & regUser & "', "                       ' RSV_USER
                sql = sql & "'" & sheetId & "', "                       ' SHEET_ID
                sql = sql & "'" & "RelatedSheetID-" & relId & "', "     ' FILL_ID
                sql = sql & "'" & relSheetId & "' "                     ' FILL_CONTENT
                sql = sql & ")"

                .CommandText = sql

                .Execute
            End If
        End If
    End With

    Set cmd = Nothing

    Exit Sub

createRelatedSheetFillData_Err:
    Set rs = Nothing
    Set cmd = Nothing

    Err.Raise Err.Number, "createRelatedSheetFillData", Err.Description

End Sub
