Attribute VB_Name = "ConstantModule"
Option Explicit

' �萔��`�p���W���[��
' �萔�⃁�b�Z�[�W�̒�`�͂��ׂĂ����ɋL�ڂ���悤��


' ****************
' �萔�֘A�̒�`
' ****************

Public Const BOOK_PROTECT_PASSWORD As String = "jinik_upload"
Public Const SHEET_PROTECT_PASSWORD As String = "jinik_upload"

' �V�[�g����`
Public Const WARNING_SHEET_NAME As String = "�x��"
Public Const MAIN_SHEET_NAME As String = "�l�ވ琬�v��"
Public Const RESULT_SHEET_NAME As String = "�`�F�b�N����"
Public Const MASTER_SHEET_NAME As String = "master"


' ���x����`
Public Const TITLE_UPLOAD_ENABLE_MSG = "�A�b�v���[�h��"
Public Const TITLE_UPLOAD_DISABLE_MSG = "�A�b�v���[�h�s��"
Public Const SUB_TITLE_UPLOAD_DISABLE_MSG = "�i�`�F�b�N���ʃV�[�g���Q�Ƃ��Ă��������j"
Public Const SUB_TITLE_NO_CHECK_MSG = "�i�G���[�`�F�b�N�����{�j"


' ���b�Z�[�W�֘A
Public Const ERR_RAISED_MSG As String = "�G���[���������܂����B"

Public Const MSG_CHECK_NO_ERROR As String = "�G���[�`�F�b�N���I�����܂����B" + vbCrLf + "�G���[�͂���܂���B"
Public Const MSG_CHECK_ERROR As String = "�G���[�`�F�b�N���I�����܂����B" + vbCrLf + "�`�F�b�N���ʃV�[�g���m�F���Ă��������B"

Public Const CONFIRM_DATA_ERASE_MSG As String = "�O���[�A�E�g���Ă��鍀�ڂɂ��ẮA�f�[�^��ێ����܂���B" & vbCrLf & "��낵���ł����H"
Public Const CONFIRM_SAVE_MSG As String = "�ۑ����܂��B��낵���ł����H" & vbCrLf & "�G���[�`�F�b�N���s���Ă��Ȃ����߁A�A�b�v���[�h�ł��܂���B" & vbCrLf & "�A�b�v���[�h����ɂ́u�G���[�`�F�b�N���{�v�ŃG���[�`�F�b�N���s���K�v������܂��B"
Public Const CONFIRM_CHK_RSLT_SAVE_MSG As String = "�`�F�b�N���ʂ�ۑ����܂��B��낵���ł����H"
Public Const CONFIRM_EXCEL_BOOK_SAVE_MSG As String = "�t�@�C�����ύX����Ă��܂��B" + vbCrLf + "�ۑ����܂��B��낵���ł����H"


' �G���[�`�F�b�N���b�Z�[�W
Public Const MSG_MISSING_ERR_IDO_PLACE As String = "�ٓ���̑g�D���̂������͂ł��B" & vbCrLf & "�ٓ����т͗����̗��ɓ��͂��Ă��������B "
Public Const MSG_MISSING_ERR_BUYER_NINTEIKYU As String = "�o�C���[�F��v��̔F�苉�������͂ł��B" & vbCrLf & "�F��v��͗����̗��ɓ��͂��Ă��������B"
Public Const MSG_MISSING_ERR_TOUYO_KEIKAKU As String = "�o�p�v��̓����Q�������͂ł��B" & vbCrLf & "�o�p�v��͗����̗��ɓ��͂��Ă��������B"
Public Const MSG_MISSING_ERR_GENZAI_TANTO_GYOMU As String = "���݂̒S���Ɩ��������͂ł��B"
Public Const MSG_MISSING_ERR_KAITO As String = "�ٓ��`�F�b�N�������N�x�ɂ͈ٓ��v��̕K�{���ځi�ٓ����A�E���A���Ə�A���_�A�ٓ���̑g�D���́A��C�v�ہj����͂��Ă��������B"
Public Const MSG_LENGTH_ERR_MSG As String = "{0}�����ȓ��œ��͂��Ă��������B"
Public Const MSG_CONSIS_ERR_BUYER_JIKI As String = "�o�C���[�F��N�x�́A�ސE�N�x�ȑO���w�肵�Ă��������B"
Public Const MSG_CONSIS_ERR_BUYER_NINTEIKYU As String = "���Ƀo�C���[2���̂��߁A����ʂ̔F�苉��I�����Ă��������B"
Public Const MSG_CONSIS_ERR_TOUYO_JIKI As String = "�o�p�N�x�́A�ސE�N�x�ȑO���w�肵�Ă��������B"
Public Const MSG_CONSIS_ERR_TOUYO_KEIKAKU As String = "���Ɋ�E�̂��߁A����ʂ̓����Q��I�����Ă��������B"
Public Const MSG_COND_MISS_ERR_IDOSAKI_KYOTEN As String = "���_���ύX�����ꍇ�͈ٓ��拒�_����͂��Ă��������B"
Public Const MSG_COND_MISS_ERR_KONIN_YOUKEN As String = "��C���K�v�ȏꍇ�͌�C�v������͂��Ă��������B"
Public Const MSG_RANGE_ERR_MSG As String = "���X�g���̒l��I�����Ă��������B"

Public Const MSG_CRLF_WARN_MSG = "���s�͔��p�X�y�[�X�ɕϊ����܂����B"


Public Const ADDR_UPLOAD_STATUS_TITLE As String = "B4"             ' �A�b�v���[�h��/�s�̃Z���ʒu
Public Const ADDR_UPLOAD_STATUS_SUB_TITLE As String = "B7"         ' �A�b�v���[�h��/�s�̃T�u�^�C�g���̃Z���ʒu
Public Const ADDR_FIRST_JINIK_DATA As String = "B17"               ' �l�ވ琬�v��f�[�^�擪�ʒu
Public Const ADDR_LAST_JINIK_DATA As String = "CY17"               ' �l�ވ琬�v��f�[�^�I���ʒu
Public Const ADDR_SHEET_NENDO As String = "AM13"                   ' �V�[�g�̔N�x�������Ă���ʒu


' �A�b�v���[�h�ە\���Z���̔w�i�F��`�iCOLOR INDEX�j
Public Const CELL_BKCOLOR_ERROR As Variant = 3                      ' �u�A�b�v���[�h�s�v�̂Ƃ��̔w�i�F�i�ԁj
Public Const CELL_BKCOLOR_NO_ERROR As Variant = 5                   ' �u�A�b�v���[�h�v�̂Ƃ��̔w�i�F�i�j


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
    RANGE_CHECK = 6                         ' �͈̓`�F�b�N
End Enum

