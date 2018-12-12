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

' �R���g�[���[���N���X�̂悤�Ȃ���
' �e�V�[�g�̃r���[��`���i�[���Ă����A�����̐�����s��
' �i�]���V�[�g����f�[�^�̎擾���w�����ăG���[�`�F�b�N�����{���Č��ʂ��G���[�ꗗ�ɏ������ގw���Ȃǁj

Private m_MainSheetView As MainSheetView        ' ���C���V�[�g�N���X
Private m_ErrListView As ErrorListView          ' �G���[�ꗗ�V�[�g�N���X
Private m_EvalSheetView As EvalSheetView        ' �]���V�[�g�N���X
Private m_DbConnect As DBConnection             ' �f�[�^�x�[�X�R�l�N�V�����N���X

Private Declare Function GetInputState Lib "USER32" () As Long
Private m_Time As Variant

Public Sub checkEvents()
    If GetInputState() Or (DateDiff("s", m_Time, Time) > 1) Then
        DoEvents
        m_Time = Time
    End If
End Sub

' �u���C���v�V�[�g
Public Property Let MainSheetView(view As MainSheetView)
    Set m_MainSheetView = view
End Property

' �u�G���[�ꗗ�v�V�[�g
Public Property Let ErrorListView(view As ErrorListView)
    Set m_ErrListView = view
End Property

' �u�i���ʁj�]���V�[�g�v
Public Property Let EvalSheetView(view As EvalSheetView)
    Set m_EvalSheetView = view
End Property

' �f�[�^�x�[�X�R�l�N�V�����N���X
Public Property Let DBConnection(conn As DBConnection)
    Set m_DbConnect = conn
End Property

' �G���[�`�F�b�N�������C��
Public Function checkErrorMain()
    Dim ret As Long
    Dim shtName As String           ' �]���V�[�g��
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
    
    ' �`�F�b�N�Ώۂ̃V�[�g������΁A�`�F�b�N�O�Ɂu�G���[�ꗗ�v�V�[�g�̓��e���N���A���Ă���
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

        ' ���݂̕]���V�[�g��ݒ�
        m_EvalSheetView.sheetName = sheetName
        
        ' �V�[�g�ɋL�q�����`�F�b�N�̓��e�����ƂɃ`�F�b�N���[���I�u�W�F�N�g���쐬
        Set rules = m_EvalSheetView.getCheckRule()
            
        ' �쐬�����`�F�b�N���[�������Ƃɂ��ē��Y�V�[�g�̃`�F�b�N�����{
        Set errors = checkSheetError(shtName, rules)
        
        ' �`�F�b�N���ʂ��u�G���[�ꗗ�v�V�[�g�ɏ�������
        Call m_ErrListView.writeCheckResult(shtName, errors)

        Set errors = Nothing
        Set rules = Nothing

    Next sheetName

    Application.ScreenUpdating = True
    Application.Calculation = xlCalculationAutomatic

    Set chkSheets = Nothing

    ' �G���[�ꗗ�̌r���`��
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

' �V�[�g�o�^���C������
Public Function registerSheetMain() As Long
    Dim ret As Long: ret = 0
    Dim rec As Long
    Dim sheetName As String
    Dim regNendo As String
    Dim sheetId As String                   ' �쐬�Ώۂ�SHEET_ID
    Dim operationCd As String               ' �쐬�Ώۂ̃V�[�g�̉^�p�R�[�h
    Dim formCd As String                    ' �쐬�Ώۂ̃V�[�g�̏����R�[�h
    Dim regUser As String
    Dim errMsg As String: errMsg = ""
    
    Dim sheets As Dictionary
    Dim key As Variant
    Dim info As Variant
    
    Dim row As Long: row = 0
    Dim regData As Collection
    
    On Error GoTo registerSheetMain_Err

    Set sheets = m_MainSheetView.getMaruCheckedSheets()
    
    ' CS_RSV�e�[�u���ɓo�^���邽�߂�RSV_ID, RSV_USER�p�̕ϐ���`
    regUser = "SYSTEM_" & format(Now, "yyyymmddhhnnss")


    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual

    ' "��"�̕t���Ă���V�[�g��o�^�Ώۂ�
    For Each key In sheets
        checkEvents

        m_DbConnect.beginTransaction

        For Each info In sheets.Item(key)
            sheetName = info
            regNendo = sheets.Item(key).Item(info)
        Next info

        ' �]���V�[�g���ł͂Ȃ��̂Œ��Ӂi�V�[�g�̌��o�����́j
        m_EvalSheetView.sheetName = key

        ' �V�[�g�̓��e��RegSheetIndoDto �̃I�u�W�F�N�g�z��ɕϊ�����
        Set regData = m_EvalSheetView.getSheetDataToRegSheetInfoDto

        For row = 1 To regData.Count
            checkEvents

            Application.StatusBar = "�]���V�[�g�y" & sheetName & "�z " & row & "���R�[�h�ڂ�������...."

            formCd = getSheetFormCd(sheetName, regData(row).format)
            operationCd = getSheetOperationCd(regData(row).party, regNendo, sheetName)
            Call m_DbConnect.getCsSlcSheet(regData(row).party, operationCd, regData(row).guid, sheetId, "", "", "")

            If Len(sheetId) > 0 Then
                ' ���͂��ꂽ�V�[�g�̏���\��e�[�u����
                Call createSheetReserve(sheetId, operationCd, formCd, regData(row), regUser)
            End If
        Next row

        ' �ȍ~�̗�O�������̍s�ʒu�\���̂��߁A0�Ƀ��Z�b�g
        row = 0

        Application.StatusBar = "�]���V�[�g�y" & sheetName & "�z �̃f�[�^��o�^��...."

        ' �\��e�[�u������CST_XXXX�e�[�u���ցi�����̃p�b�P�[�W�Ăяo���j
        Call migrateSheetReserve(regUser)

        ' �o�^���ʂ����C���V�[�g�ɏ�������
        Call m_MainSheetView.outputRegResult(sheetName, regData.Count)

        ' �����ł���܂ł̃g�����U�N�V�������R�~�b�g
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

    ' �G���[���������܂����B�������́A{0:�]���V�[�g��}Sheet��{1:�s�ʒu}�Ԗڂ̍s�ł��Boracle�G���[���e
    errMsg = Replace(Replace(ERR_DB_UNEXPECTED, "{0}", sheetName), "{1}", CStr(row))

    MsgBox errMsg & vbCrLf & Err.Description, vbCritical + vbOKOnly

    registerSheetMain = -1

End Function

' ���C���V�[�g��"��"������ꂽ�V�[�g���o�^�\�ł��邩�A�G���[�ꗗ�V�[�g�����Ƃɔ��肷��
' �߂�l�F TRUE  : �㑱���������s
'          FALSE : �㑱���������s���Ȃ�
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
        ' �����ЂƂ��t���Ă��Ȃ��Ƃ�
        MsgBox "�o�^�Ώۂ��I������Ă��܂���B", vbExclamation + vbOKOnly
        isRegisteredMaruCheckSheets = False
        Exit Function
    End If
    
    For Each sheet In sheets
        For Each name In sheets.Item(sheet)
            sheetName = name
        Next name

        status = m_ErrListView.getStatusCheckedSheet(sheetName)
        If status = CHK_SHEET_STATUS.CHECK_ERROR Then
            ' 1�V�[�g�ł��`�F�b�N�G���[������΁A�o�^�s��
            canRegister = CHK_SHEET_STATUS.CHECK_ERROR
        ElseIf (canRegister = CHK_SHEET_STATUS.CHECK_OK Or canRegister = CHK_SHEET_STATUS.CHECK_WARNING) And status = CHK_SHEET_STATUS.CHECK_WARNING Then
            '
            canRegister = CHK_SHEET_STATUS.CHECK_WARNING
        ElseIf canRegister = CHK_SHEET_STATUS.CHECK_OK And status = CHK_SHEET_STATUS.CHECK_OK Then
            canRegister = CHK_SHEET_STATUS.CHECK_OK
        End If
    Next sheet

    Set sheets = Nothing

    ' �o�^�s�i�G���[����j�A�o�^�i�x������j�A�o�^�i�x���Ȃ��j�̂ǂꂩ
    If canRegister = CHK_SHEET_STATUS.CHECK_ERROR Then
        ' �u�ُ�G���[�����݂��܂��B�G���[�ꗗ�V�[�g���m�F���Ă��������B"�v
        MsgBox REGISTRATION_ERR_MSG, vbExclamation + vbOKOnly
        checked = False
    ElseIf canRegister = CHK_SHEET_STATUS.CHECK_WARNING Then
        ' �u�x���G���[�����݂��܂��B�o�^���Ă�낵���ł����B�v
        If MsgBox(REGISTRATION_WARN_MSG, vbYesNo + vbQuestion) = vbNo Then
            checked = False
        End If
    End If
    
    isRegisteredMaruCheckSheets = checked
    
    Exit Function

isRegisteredMaruCheckSheets_Err:
    Err.Raise Err.Number, "isRegisteredMaruCheckSheets", Err.Description

End Function

' �\��e�[�u���ɃV�[�g�̏���o�^����
'  @sheetId �V�[�gID
'  @operCd �^�p�R�[�h
'  @formCd �����R�[�h
'  @regData ���̓f�[�^
'  @regUser �\�񃆁[�U
Private Sub createSheetReserve(sheetId As String, operCd As String, formCd As String, regData As RegSheetInfoDto, regUser As String)

    On Error GoTo createSheetReserve_Err

    ' �V�K/�X�V��킸�ACST_SHEET�ɓo�^����Ă��郌�R�[�h����������폜
    Call m_DbConnect.deleteCstSheet(sheetId, regData.party)

    ' CS_RSV_DSTRBT�փV�[�g�̏���o�^
    Call m_DbConnect.createSheetReserve(sheetId, operCd, formCd, regData, regUser)

    ' CS_RSV_ACTOR�֕]���҂�o�^
    Call m_DbConnect.createActorReserve(sheetId, regData, regUser)

    ' CS_RSV_FILL�փV�[�g�񓚂�o�^
    Call m_DbConnect.createFillReserve(sheetId, regData, regUser)

    ' CS_RSV_FILL ��"RelatedSheetID-xxxxx"�̃��R�[�h���쐬
    Call m_DbConnect.createRelatedSheetFillData(regData.party, operCd, regData.guid, sheetId, regUser)

    Exit Sub

createSheetReserve_Err:
    Err.Raise Err.Number, "createSheetReserve", Err.Description
    
End Sub

' �z�z�\��e�[�u������CST_SHEET_XXX�փf�[�^���R�s�[����
'  CS_RSV_DSTRBT, CS_RSV_ACTOR�́A�R�s�[��Ƀf�[�^��j������i�V�[�g�񓚗\��f�[�^�͔j�����Ȃ��j
'  @regUser �\�񃆁[�U
Private Sub migrateSheetReserve(regUser As String)

    On Error GoTo migrateSheetReserve_Err

    ' CS_RSV_DSTRBT �� CST_SHEET
    Call m_DbConnect.migrateSheetReserve(regUser)

    ' CS_RSV_ACTOR �� CST_SHEET_ACTOR
    Call m_DbConnect.migrateActorReserve(regUser)

    ' CS_RSV_FILL �� CST_SHEET_FILL
    Call m_DbConnect.migrateSheetFillReserve(regUser)

    Exit Sub

migrateSheetReserve_Err:
    Err.Raise Err.Number, "migrateSheetReserve", Err.Description

End Sub

' ���O�Ɏ擾�����`�F�b�N���������Ƃɂ��ăV�[�g�̃`�F�b�N���s��
'  @sheetName �]���V�[�g��
'  @chkRules �`�F�b�N����
'
'  �߂�l�F�`�F�b�N�G���[����
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

    ' �`�F�b�N���镨�����ږ��i�̔z��j
    phyColNames = chkRules.keys

    sheetData = m_EvalSheetView.getSheetArrayData()

    For row = START_DATA_ROW To UBound(sheetData, 1)
        Application.StatusBar = "�]���V�[�g�y" & sheetName & "�z�̃`�F�b�N��.... " & CStr(row) & "�s��"

        For Each phyColName In phyColNames
            DoEvents

            Set chkRule = chkRules(phyColName)

            chkValue = CStr(sheetData(row, chkRule.ColIndex))

            If chkRule.isCheck() = True Then
                ' �����̓`�F�b�N
                If chkRule.isRequire() = True And Len(chkValue) = 0 Then
                    ' {0}�������͂ł��i{0}�͘_�����ږ��ɒu�������j
                    Call chkRslts.addCheckResult(sheetName, CStr(row), ERROR_TYPE.CHK_ERROR, Replace(ERR_MISSING, "{0}", chkRule.ColLgcName))
                End If

                ' �����̓��͂�������̂ɑ΂��ă`�F�b�N���s��
                If Len(chkValue) > 0 Then
                    If StrComp(chkRule.ColLgcName, CHK_COLUMN_PARTY, vbTextCompare) = 0 Then
                        party = chkValue
                    End If

                    ' GID�Ɋւ���`�F�b�N
                    If StrComp(chkRule.ColLgcName, CHK_COLUMN_GID, vbTextCompare) = 0 Or StrComp(chkRule.ColPhyName, CHK_COLUMN_GID, vbTextCompare) = 0 Then
                        ' ���͂��ꂽGUID�̓V�[�g�̍쐬�Ώۂ�
                        ' GID�����͂��ꂽ���_�œ��YGID���V�[�g�̍쐬�Ώۂ��`�F�b�N����
                        If isSheetCreated(CStr(sheetData(row, 2)), CStr(sheetData(row, 3)), CStr(sheetData(row, 4)), sheetName) = False Then
                            Call chkRslts.addCheckResult(sheetName, CStr(row), ERROR_TYPE.CHK_ERROR, ERR_NOT_CREATE_TARGET)
                        End If

                        ' ���͍ς݂�GID�ɑ΂��ē����GID���������݂��Ă��Ȃ���
                        If isExistSameGuid(chkedGuids, chkValue) = True Then
                            Call chkRslts.addCheckResult(sheetName, CStr(row), ERROR_TYPE.CHK_ERROR, ERR_SAME_GID)
                        Else
                            chkedGuids(UBound(chkedGuids)) = chkValue
                            ReDim Preserve chkedGuids(UBound(chkedGuids) + 1)
                        End If
                    End If
                    
                    ' 1�`4���]���҂Ɋւ���`�F�b�N
                    If StrComp(chkRule.ColPhyName, CHK_COLUMN_ACTOR_1ST, vbTextCompare) = 0 Or _
                        StrComp(chkRule.ColPhyName, CHK_COLUMN_ACTOR_2ND, vbTextCompare) = 0 Or _
                        StrComp(chkRule.ColPhyName, CHK_COLUMN_ACTOR_3RD, vbTextCompare) = 0 Or _
                        StrComp(chkRule.ColPhyName, CHK_COLUMN_ACTOR_4TH, vbTextCompare) = 0 Then
                        If m_DbConnect.isRegisteredGid(party, chkValue) = False Then
                            Call chkRslts.addCheckResult(sheetName, CStr(row), ERROR_TYPE.CHK_WARNING, Replace(ERR_NOT_EXIST_GID, "{0}", chkRule.ColLgcName))
                        End If
                    End If

                    ' ���s�����������Ȃ��Ƃ��A�Y�������ɉ��s���܂܂�Ă��Ȃ���
                    If chkRule.isCrLf() = False Then
                        If InStr(chkValue, vbCrLf) > 0 Or InStr(chkValue, vbCr) > 0 Or InStr(chkValue, vbLf) > 0 Then
                            ' {0}�ɉ��s�������܂܂�Ă��܂��B���s�����͎g�p�ł��܂���B�i{0}�͘_�����ږ��ɒu�������j
                            Call chkRslts.addCheckResult(sheetName, CStr(row), ERROR_TYPE.CHK_ERROR, Replace(ERR_INPUT_CRLF, "{0}", chkRule.ColLgcName))
                        End If
                    End If
                
                    ' ���͕������̃`�F�b�N
                    If chkRule.MaxLength() > 0 Then
                        If Len(chkValue) > chkRule.MaxLength Then
                            ' {0}��{1}�����ȓ��œ��͂��Ă��������B�i{0}�͘_�����ږ��A{1}�͐����������ɒu�������j
                            Call chkRslts.addCheckResult(sheetName, CStr(row), ERROR_TYPE.CHK_ERROR, Replace(Replace(ERR_MAX_LENGTH, "{0}", chkRule.ColLgcName), "{1}", CStr(chkRule.MaxLength)))
                        End If
                    End If
                    
                    ' ���͌`���̃`�F�b�N
                    If Len(chkRule.RegPattern()) > 0 Then
                        Set reg = New RegExp
                        
                        reg.pattern = chkRule.RegPattern

                        If reg.Test(chkValue) = False Then
                            ' {0}�̓��͌`���Ɍ�肪����܂��B�i{0}�͘_�����ږ��ɒu�������j
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

' �w�肵��GID�ł��łɍ쎌�w��������Ă��邩�ǂ����H
'  @guids �쐬�w���ς݂�GID
'  @chkGuid �`�F�b�NGID
'
'  �߂�l�FTRUE�i���łɍ쐬�w���ς݁j�AFALSE�i���w���j
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

' �V�[�g���쐬�Ώۂ��`�F�b�N����
'  @party PARTY
'  @gid GID
'  @format �t�H�[�}�b�g
'  @sheetName �]���V�[�g��
'
'  �߂�l�FTRUE�i�쐬�j�AFALSE�i�쐬�s�j
Private Function isSheetCreated(ByVal party As String, ByVal gid As String, ByVal format As String, ByVal sheetName As String) As Boolean
    On Error GoTo isSheetCreated_Err

    Dim sheetId As String
    Dim defFormCd As String, defStatusCd As String, defFlowPtn As String            ' �g�p���Ȃ�

    '���̓V�[�g�̍s�����̂܂ܓǂݍ���ł���̂łO�n�܂�̗�ʒu�Ŏw�肷��
    Dim nendo As String: nendo = m_MainSheetView.getSheetNendo(sheetName)

    Dim operCd As String: operCd = getSheetOperationCd(party, nendo, sheetName)

    Call m_DbConnect.getCsSlcSheet(party, operCd, gid, sheetId, defFormCd, defStatusCd, defFlowPtn)

    isSheetCreated = m_DbConnect.IsExistSlcDstrbt(party, operCd, sheetId)

    Exit Function

isSheetCreated_Err:
    Err.Raise Err.Number, "isSheetCreated", Err.Description

End Function
