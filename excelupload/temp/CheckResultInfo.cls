VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CheckResultInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private m_checkResults As Dictionary                    ' �G���[�`�F�b�N����
Private m_nWarningCount As Long                         ' �`�F�b�N�x����
Private m_nErrorCount As Long                           ' �`�F�b�N�G���[��

Private Sub Class_Initialize()
    Set m_checkResults = New Dictionary

    m_nErrorCount = 0
    m_nWarningCount = 0
End Sub

Private Sub Class_Terminate()
    m_checkResults.RemoveAll

    Set m_checkResults = Nothing
End Sub

Public Function getCheckResults() As Dictionary
    Set getCheckResults = m_checkResults
End Function

Public Function getCheckWarningCount() As Long
    getCheckWarningCount = m_nWarningCount
End Function

Public Function getCheckErrorCount() As Long
    getCheckErrorCount = m_nErrorCount
End Function

' �@�\�F�G���[�E�x�������G���[�`�F�b�N���ʃI�u�W�F�N�g�Ɋi�[����
' �����F
'   addr    : A1�`���̃Z���̃A�h���X
'   guid    : GID
'   name    : ����
'   fillId  : ��ID
'   colName : �񓚍��ږ��i���{��j
'   chkType : ERROR_CHECK_TYPE�i�G���[�`�F�b�N��ʁj
' �߂�l�F�Ȃ�
Public Sub addCheckResult(addr As String, guid As String, name As String, fillId As String, colName As String, chkType As ERROR_CHECK_TYPE)
    Dim count As Long
    Dim errMsg As String
    Dim errType As CHECK_RESULT_TYPE: errType = CHECK_RESULT_TYPE.TYPE_ERROR
    Dim result As CheckResultInfoDto

    On Error GoTo addCheckResult_Err

    Set result = New CheckResultInfoDto

    Select Case chkType
        ' �����̓`�F�b�N��
        Case ERROR_CHECK_TYPE.MISSING_CHECK
            If fillId = "jinik_kaito_ido_place" Then
                ' �ٓ���̑g�D���̂������͂ł��B" & vbCrLf & "�ٓ����т͗����̗��ɓ��͂��Ă��������B
                errMsg = MSG_MISSING_ERR_IDO_PLACE
            ElseIf fillId = "jinik_kaito_buyer_ninteikyu" Then
                ' �o�C���[�F��v��̔F�苉�������͂ł��B" & vbCrLf & "�F��v��͗����̗��ɓ��͂��Ă��������B
                errMsg = MSG_MISSING_ERR_BUYER_NINTEIKYU
            ElseIf fillId = "jinik_kaito_touyo_keikaku" Then
                ' �o�p�v��̓����Q�������͂ł��B" & vbCrLf & "�o�p�v��͗����̗��ɓ��͂��Ă��������B
                errMsg = MSG_MISSING_ERR_TOUYO_KEIKAKU
            ElseIf fillId = "jinik_kaito_genzai_tanto_gyomu" Then
                ' ���݂̒S���Ɩ��������͂ł��B
                errMsg = MSG_MISSING_ERR_GENZAI_TANTO_GYOMU
            ElseIf fillId Like "jinik_kaito_ido_month_0?" Or fillId Like "jinik_kaito_shokumu_0?" Or fillId Like "jinik_kaito_jigyojo_0?" Or _
                    fillId Like "jinik_kaito_kyoten_0?" Or fillId Like "jinik_kaito_idosaki_0?" Or fillId Like "jinik_kaito_konin_youhi_0?" Then
                ' �ٓ��`�F�b�N�������N�x�ɂ͈ٓ��v��̕K�{���ځi�ٓ����A�E���A���Ə�A���_�A�ٓ���̑g�D���́A��C�v�ہj����͂��Ă��������B
                errMsg = MSG_MISSING_ERR_KAITO
            End If
        ' ���s�������݃`�F�b�N��
        Case ERROR_CHECK_TYPE.CRLF_CHECK
            errType = CHECK_RESULT_TYPE.TYPE_WARNING
            ' ���s�͔��p�X�y�[�X�ɕϊ����܂����B
            errMsg = MSG_CRLF_WARN_MSG
        ' �����񒷃`�F�b�N��
        Case ERROR_CHECK_TYPE.LENGTH_CHECK
            If fillId = "jinik_kaito_other" Then
                ' �u���l�v��1000�����ȓ�
                errMsg = Replace(MSG_LENGTH_ERR_MSG, "{0}", "1000")
            Else
                ' �u���l�v�ȊO��100�����ȓ�
                errMsg = Replace(MSG_LENGTH_ERR_MSG, "{0}", "100")
            End If
        ' �������`�F�b�N��
        Case ERROR_CHECK_TYPE.CONSISTENT_CHECK
            If fillId = "jinik_kaito_buyer_jiki" Then
                ' �o�C���[�F��N�x�́A�ސE�N�x�ȑO���w�肵�Ă��������B
                errMsg = MSG_CONSIS_ERR_BUYER_JIKI
            ElseIf fillId = "jinik_kaito_buyer_ninteikyu" Then
                ' ���Ƀo�C���[2���̂��߁A����ʂ̔F�苉��I�����Ă��������B
                errMsg = MSG_CONSIS_ERR_BUYER_NINTEIKYU
            ElseIf fillId = "jinik_kaito_touyo_jiki" Then
                ' �o�p�N�x�́A�ސE�N�x�ȑO���w�肵�Ă��������B
                errMsg = MSG_CONSIS_ERR_TOUYO_JIKI
            ElseIf fillId = "jinik_kaito_touyo_keikaku" Then
                ' ���Ɋ�E�̂��߁A����ʂ̓����Q��I�����Ă��������B
                errMsg = MSG_CONSIS_ERR_TOUYO_KEIKAKU
            End If
        ' �����t�������̓`�F�b�N��
        Case ERROR_CHECK_TYPE.COND_MISSING_CHECK
            If fillId Like "jinik_kaito_idosaki_kyoten_0?" Then
                ' ���_���ύX�����ꍇ�͈ٓ��拒�_����͂��Ă��������B
                errMsg = MSG_COND_MISS_ERR_IDOSAKI_KYOTEN
            ElseIf fillId Like "jinik_kaito_konin_youken_0?" Then
                ' ��C���K�v�ȏꍇ�͌�C�v������͂��Ă��������B
                errMsg = MSG_COND_MISS_ERR_KONIN_YOUKEN
            End If
        ' �͈̓`�F�b�N��
        Case ERROR_CHECK_TYPE.RANGE_CHECK
            errType = CHECK_RESULT_TYPE.TYPE_ERROR
            ' ���͋K�����̒l��I�����Ă��������B
            errMsg = MSG_RANGE_ERR_MSG
    End Select

    With result
        .ErrCellAddr = addr
        .OwnGuid = guid
        .PersonName = name
        .ColumnName = colName
        .ErrResultType = errType
        .ErrMsgContent = errMsg
    End With

    count = m_checkResults.count

    ' key�́A1����̘A��
    Call m_checkResults.Add(count + 1, result)

    If errType = CHECK_RESULT_TYPE.TYPE_ERROR Then
        m_nErrorCount = m_nErrorCount + 1
    ElseIf errType = CHECK_RESULT_TYPE.TYPE_WARNING Then
        m_nWarningCount = m_nWarningCount + 1
    End If

    Exit Sub

addCheckResult_Err:
    If result Is Nothing Then
        Set result = Nothing
    End If

    err.Raise err.Number, "addCheckResult", err.Description

End Sub

' �@�\�F�G���[�E�x�������G���[�`�F�b�N���ʃI�u�W�F�N�g�Ɋi�[����
' �����F
'   addr    : A1�`���̃Z���̃A�h���X
'   guid    : GID
'   name    : ����
'   fillId  : ��ID
'   colName : �񓚍��ږ��i���{��j
'   chkType : ERROR_CHECK_TYPE�i�G���[�`�F�b�N��ʁj
'   errMsg  : �G���[���b�Z�[�W
' �߂�l�F�Ȃ�
Public Sub addCheckResultWithErrMsg(addr As String, guid As String, name As String, colName As String, errType As CHECK_RESULT_TYPE, errMsg As String)
    Dim count As Long
    Dim result As CheckResultInfoDto

    On Error GoTo addCheckResultWithErrMsg_Err

    Set result = New CheckResultInfoDto

    With result
        .ErrCellAddr = addr
        .OwnGuid = guid
        .PersonName = name
        .ColumnName = colName
        .ErrResultType = errType
        .ErrMsgContent = errMsg
    End With

    count = m_checkResults.count

    Call m_checkResults.Add(count + 1, result)

    If errType = CHECK_RESULT_TYPE.TYPE_ERROR Then
        m_nErrorCount = m_nErrorCount + 1
    ElseIf errType = CHECK_RESULT_TYPE.TYPE_WARNING Then
        m_nWarningCount = m_nWarningCount + 1
    End If

    Set result = Nothing

    Exit Sub

addCheckResultWithErrMsg_Err:
    err.Raise err.Number, "addCheckResultWithErrMsg", err.Description

End Sub
