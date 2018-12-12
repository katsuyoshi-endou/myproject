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

Private m_checkResults As Dictionary

Private Sub Class_Initialize()
    Set m_checkResults = New Dictionary
End Sub

Private Sub Class_Terminate()
    m_checkResults.RemoveAll

    Set m_checkResults = Nothing
End Sub

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
                errMsg = "�ٓ���̑g�D���̂������͂ł��B" & vbCrLf & "�ٓ����т͗����̗��ɓ��͂��Ă�������� "
            ElseIf fillId = "jinik_kaito_buyer_ninteikyu" Then
                errMsg = "�o�C���[�F��v��̔F�苉�������͂ł��B" & vbCrLf & "�F��v��͗����̗��ɓ��͂��Ă�������� "
            ElseIf fillId = "jinik_kaito_touyo_keikaku" Then
                errMsg = "�o�p�v��̓����Q�������͂ł��B" & vbCrLf & "�o�p�v��͗����̗��ɓ��͂��Ă�������� "
            ElseIf fillId = "jinik_kaito_genzai_tanto_gyomu" Then
                errMsg = "���݂̒S���Ɩ��������͂ł��B"
            ElseIf fillId Like "jinik_kaito_ido_month_0?" Or fillId Like "jinik_kaito_shokumu_0?" Or fillId Like "jinik_kaito_jigyojo_0?" Or _
                    fillId Like "jinik_kaito_kyoten_0?" Or fillId Like "jinik_kaito_idosaki_0?" Or fillId Like "jinik_kaito_konin_youhi_0?" Then
                errMsg = "�ٓ��`�F�b�N�������N�x�ɂ͈ٓ��v��̕K�{���ځi�ٓ����A�E���A���Ə�A���_�A�ٓ���̑g�D���́A��C�v�ہj����͂��Ă��������B"
            End If
        ' ���s�������݃`�F�b�N��
        Case ERROR_CHECK_TYPE.CRLF_CHECK
            errType = CHECK_RESULT_TYPE.TYPE_WARNING
            errMsg = "���s�͔��p�X�y�[�X�ɕϊ����܂����B"
        ' �����񒷃`�F�b�N��
        Case ERROR_CHECK_TYPE.LENGTH_CHECK
            If fillId = "jinik_kaito_other" Then
                errMsg = "1000�����ȓ��œ��͂��Ă��������B"
            Else
                errMsg = "100�����ȓ��œ��͂��Ă��������B"
            End If
        ' �������`�F�b�N��
        Case ERROR_CHECK_TYPE.CONSISTENT_CHECK
            If fillId = "jinik_kaito_buyer_jiki" Then
                errMsg = "�o�C���[�F��N�x�́A�ސE�N�x�ȑO���w�肵�Ă��������B"
            ElseIf fillId = "jinik_kaito_buyer_ninteikyu" Then
                errMsg = "���Ƀo�C���[2���̂��߁A����ʂ̔F�苉��I�����Ă�������� "
            ElseIf fillId = "jinik_kaito_touyo_jiki" Then
                errMsg = "�o�p�N�x�́A�ސE�N�x�ȑO���w�肵�Ă��������B"
            ElseIf fillId = "jinik_kaito_touyo_keikaku" Then
                errMsg = "���Ɋ�E�̂��߁A����ʂ̓����Q��I�����Ă�������� "
            End If
        ' �����t�������̓`�F�b�N��
        Case ERROR_CHECK_TYPE.COND_MISSING_CHECK
            If fillId Like "jinik_kaito_idosaki_kyoten_0?" Then
                errMsg = "���_���ύX�����ꍇ�͈ٓ��拒�_����͂��Ă��������B"
            ElseIf fillId = "jinik_kaito_konin_youken_0" Then
                errMsg = "��C���K�v�ȏꍇ�͌�C�v������͂��Ă��������B"
            End If
    End Select

    result.getErrCellAddr = addr
    result.setGuid = guid
    result.getPersonName = name
    result.getColumnName = colName
    result.getErrType = errType
    result.setErrContent = errMsg

    count = m_checkResults.count

    Call m_checkResults.Add(count + 1, result)

    Exit Sub

addCheckResult_Err:
    err.Raise err.Number, "addCheckResult", err.Description

End Sub

Public Function getCheckResults() As Dictionary
    Set getCheckResults = m_checkResults
End Function
