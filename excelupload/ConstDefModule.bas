Attribute VB_Name = "ConstDefModule"
Option Explicit

' �萔��`�p���W���[��
' �萔�⃁�b�Z�[�W�̒�`�͂��ׂĂ����ɋL�ڂ���悤��


' ****************
' �萔�֘A�̒�`
' ****************

' �V�[�g����`
Public Const WARNING_SHEET_NAME As String = "�x��"
Public Const MAIN_SHEET_NAME As String = "�l�ވ琬�v��"
Public Const RESULT_SHEET_NAME As String = "�`�F�b�N����"


' ���x����`
Public Const TITLE_UPLOAD_ENABLE_MSG = "�A�b�v���[�h��"
Public Const TITLE_UPLOAD_DISABLE_MSG = "�A�b�v���[�h�s��"
Public Const SUB_TITLE_UPLOAD_DISABLE_MSG = "�i�`�F�b�N���ʃV�[�g���Q�Ƃ��Ă��������j"
Public Const SUB_TITLE_NO_CHECK_MSG = "�i�G���[�`�F�b�N�����{�j"


' ���b�Z�[�W�֘A
Public Const ERR_RAISED_MSG As String = "�G���[���������܂����B"

Public Const MSG_CHECK_NO_ERROR As String = "�G���[�`�F�b�N���I�����܂����B" + vbCrLf + "�G���[�͂���܂���B"
Public Const MSG_CHECK_ERROR As String = "�G���[�`�F�b�N���I�����܂����B" + vbCrLf + "�`�F�b�N���ʃV�[�g���m�F���Ă��������B"


' ****************************
' ���̑��i�񋓌^�Ȃǁj�̒�`
' ****************************
Enum UPLOAD_TYPE
    UPLOAD_ENABLE = 0
    UPLOAD_DISABLE = 1
End Enum

Enum CHECK_RESULT
    CHK_NO_ERROR = 0
    CHK_WARNING = 1
    CHK_ERROR = 2
End Enum

Enum CHECK_RESULT_TYPE
    TYPE_ERROR = 1
    TYPE_WARNING = 2
End Enum

Enum ERROR_CHECK_TYPE
    MISSING_CHECK = 1                       ' �����̓`�F�b�N
    CRLF_CHECK = 2                          ' ���s�������݃`�F�b�N
    LENGTH_CHECK = 3                        ' �����񒷃`�F�b�N
    CONSISTENT_CHECK = 4                    ' �������`�F�b�N
    COND_MISSING_CHECK = 5                  ' �����t�������̓`�F�b�N
End Enum

