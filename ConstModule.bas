Attribute VB_Name = "ConstModule"
' ���b�Z�[�W�֘A�̋��ʃ��W���[��
' �c�[�����Ŏg�p���郁�b�Z�[�W�ނ������Œ�`����
Option Explicit


' ���ʃ��b�Z�[�W
Public Const ERR_RAISED_MSG As String = "�G���[���������܂����B"

Public Const ERR_SHEET_NOT_SELECTED As String = "���C���V�[�g�ɂāA�G���[�`�F�b�N�܂��͓o�^�Ώۂ̃V�[�g���ݒ肳��Ă��܂���B"
Public Const ERR_SHEET_NENDO_NOT_INPUT As String = "���C���V�[�g�ɂāA�G���[�`�F�b�N�܂��͓o�^�Ώۂ́u�N�x�v���w�肳��Ă��܂���"


' ���[�U��`�G���[�ԍ������b�Z�[�W�i���[�U��`�̃G���[�ԍ���513-65535�̂������j
' Oracle �p�b�P�[�W�Ăяo���G���[
Public Const USER_ERR_CD_PACKAGE_CALL As Long = 555
Public Const USER_ERR_MSG_PACKAGE_CALL As String = "�p�b�P�[�W:[{0}]�̌Ăяo���A�������͎��s�Ɏ��s���܂����B"


' �f�[�^�x�[�X�ڑ��֘A
Public Const EER_DB_CONNECT_STR_NOT_INPUT As String = "�ڑ����������͂��Ă��������"
Public Const EER_DB_USERID_NOT_INPUT As String = "���[�U�[������͂��Ă��������B"
Public Const ERR_DB_PASSWORD_NOT_INPUT As String = "�p�X���[�h����͂��Ă��������B"
Public Const ERR_DB_CONNECT As String = "�f�[�^�x�[�X�֐ڑ��ł��܂���ł����B" + vbCr + "�ڑ��ݒ���e�A�f�[�^�x�[�X�����m�F���Ă��������B"
Public Const ERR_DB_UNEXPECTED As String = "�G���[���������܂����B�������́A{0}Sheet��{1}�Ԗڂ̍s�ł��B"


' �f�[�^�`�F�b�N�֘A
Public Const CHK_INFO_MSG As String = "���"
Public Const CHK_WARNING_MSG As String = "�x��"
Public Const CHK_ERROR_MSG As String = "�G���["

Public Const CHECK_NO_ERROR As String = "�G���[�͂���܂���B"

Public Const ERR_NOT_CREATE_TARGET As String = "���͂��ꂽGID�̓V�[�g�쐬�Ώۂł͂���܂���B"
Public Const ERR_NOT_EXIST_GID As String = "���͂��ꂽ{0}��GID�͍ݐЂ��Ă��Ȃ��]�ƈ��ł��B"
Public Const ERR_MISSING As String = "{0}�������͂ł��B"
Public Const ERR_SAME_GID As String = "�����GID�����͂���Ă��܂��B"
Public Const ERR_MAX_LENGTH As String = "{0}��{1}�����ȓ��œ��͂��Ă��������B"
Public Const ERR_INVALID_FORMAT As String = "{0}�̓��͌`���Ɍ�肪����܂��B"
Public Const ERR_RANGE_0_TO_100 As String = "{0}��0�`100�̔��p��������͂��Ă��������B"
Public Const ERR_INPUT_CRLF As String = "{0}�ɉ��s�������܂܂�Ă��܂��B���s�����͎g�p�ł��܂���B"

Public Const WARN_DEFAULT_STATUS_CD As String = "�X�e�[�^�X�R�[�h���w�肳��Ă��܂���B�f�t�H���g�̃X�e�[�^�X�R�[�h���w�肳��܂��B"
Public Const WARN_DEFAULT_FLOW_PTN As String = "�t���[�p�^�[�����w�肳��Ă��܂���B�u�ʏ�t���[(1-4��)�v���w�肳��܂��B"

Public Const CHECK_COMPLETED_MSG As String = "�G���[�`�F�b�N���I�����܂����B�G���[�ꗗ�V�[�g���m�F���Ă��������B"


' �o�^�֘A
Public Const REGISTED_COMPLETED_MSG As String = "�o�^���������܂����B"
Public Const REGISTRATION_ERR_MSG As String = "�ُ�G���[�����݂��܂��B�G���[�ꗗ�V�[�g���m�F���Ă��������B"
Public Const REGISTRATION_WARN_MSG As String = "�x���G���[�����݂��܂��B�o�^���Ă�낵���ł����B"


' ***********************
' �]���V�[�g��
' ***********************
Public Const GYOSEKI_HYOKA_JP As String = "�Ɛѕ]���i��ʐE�j"
Public Const GYOSEKI_HYOKA_EN As String = "PerformanceEvaluation"
Public Const COMP_HYOKA_JP As String = "�R���s�e���V�[�]���i��ʐE�j"
Public Const COMP_HYOKA_EN As String = "CompetencyEvaluation"
Public Const CAREER_DEV_ME_JP As String = "�Ǘ��E�]���E�L�����A�J���iM,E�����j"
Public Const CAREER_DEV_ME_EN As String = "Appraisal & Development(M,E)"
Public Const CAREER_DEV_S_JP As String = "�Ǘ��E�]���E�L�����A�J���iS�����j"
Public Const CAREER_DEV_S_EN As String = "Appraisal & Development(S)"


' ***********************
' �`�F�b�N���[���̒�`
' ***********************
Public Const CHK_COLUMN_PARTY As String = "PARTY"
Public Const CHK_COLUMN_GID As String = "GID"
Public Const CHK_COLUMN_ACTOR_1ST As String = "ACTOR_1ST"
Public Const CHK_COLUMN_ACTOR_2ND As String = "ACTOR_2ND"
Public Const CHK_COLUMN_ACTOR_3RD As String = "ACTOR_3RD"
Public Const CHK_COLUMN_ACTOR_4TH As String = "ACTOR_4TH"

Public Const CHK_INPUT_TYPE_STRING_JP As String = "������"
Public Const CHK_INPUT_TYPE_STRING_EN As String = "Character String"
Public Const CHK_PATTERN_NO_CRLF_JP As String = "���s�s��"
Public Const CHK_PATTERN_NO_CRLF_EN As String = "Not line break"
Public Const CHK_PATTERN_YYYY As String = "YYYY"
Public Const CHK_PATTERN_YYYYMM As String = "YYYY/MM"
Public Const CHK_PATTERN_YYYYMMDD As String = "YYYY/MM/DD"


' ***********************
' ���̑��̒�`
' ***********************
Public Const MAIN_SHEET_NAME As String = "���C��"
Public Const ERR_LIST_SHEET_NAME As String = "�G���[�ꗗ"

' �l�����[�UID
Public Const JINJI_USER_ID As String = "ZZZZZZ"


' ���C���V�[�g��̏����̋N�_�i"B15"�j
Public Const M_START_CELL As String = "B15"
Public Const M_START_ROW As Long = 15                       ' �Z���FB15�̍s�ʒu
Public Const M_START_COL As Long = 2                        ' �Z���FB15�̗�ʒu

' ���C���V�[�g�̏������w������\�̊e���ڂ�B����N�_�Ƃ������Έʒu
Public Const REL_POS_REG_CHECK As Long = 1                  ' �u�o�^�v��ʒu
Public Const REL_POS_REG_NENDO As Long = 3                  ' �u�N�x�v��ʒu
Public Const REL_POS_EVAL_SHEET As Long = 5                 ' �u�]���V�[�g���v��ʒu
Public Const REL_POS_REG_DATE As Long = 12                  ' �u�o�^�����v��ʒu
Public Const REL_POS_REG_COUNT As Long = 17                 ' �u�o�^�����v��ʒu

' �e�]���V�[�g�̃f�[�^�J�n�s�i"B12"�j
Public Const START_DATA_CELL As String = "B12"
Public Const START_DATA_ROW As Long = 12
Public Const START_DATA_COL As Long = 2

' �e�]���V�[�g�̃f�[�^�擾�̋N�_�i"B4"�j
Public Const H_SHT_START_CELL As String = "B4"
Public Const H_SHT_START_ROW As Long = 4
Public Const H_SHT_START_COL As Long = 2

' �e�]���V�[�g�̃V�[�g�񓚏��擾�̋N�_�i"K4"�j
Public Const H_FILL_START_CELL As String = "K4"
Public Const H_FILL_START_ROW As Long = 4
Public Const H_FILL_START_COL As Long = 11

' �]���V�[�g�̍s�ʒu�̒�`
Public Const LGC_COL_NAME_ROW_NUM As Long = 4           ' �i�_���j���ږ�
Public Const PHY_COL_NAME_ROW_NUM As Long = 5           ' �i�����j�J������
Public Const REQUIRED_ROW_NUM As Long = 6               ' �K�{
Public Const DATA_ATTR_ROW_NUM As Long = 7              ' ����
Public Const DATA_LENGTH_ROW_NUM As Long = 8            ' ����
Public Const INPUT_TYPE_ROW_NUM As Long = 9             ' ���͌`��
Public Const FIXED_VAL_ROW_NUM As Long = 10             ' �Œ�l





' �G���[�ꗗ�V�[�g�̊e���ڂ̃Z���E��ʒu
Public Const ERR_LIST_WRITE_START_CELL As String = "B3"
Public Const ERR_LIST_SHEET_NAME_COL As Long = 2                ' �u�V�[�g�v��
Public Const ERR_LIST_ERROR_ROW_COL As Long = 3                 ' �u�G���[Excel�s�v��
Public Const ERR_LIST_ERR_TYPE_COL As Long = 4                  ' �u�G���[��ʁv��
Public Const ERR_LIST_ERR_CONTENT_COL As Long = 5               ' �u�G���[���e�v��

' DB�ڑ���񂪋L�ڂ���Ă��郁�C���V�[�g��̃Z���ʒu
Public Const DB_CONNECT_STR_CELL As String = "B5"               ' �ڑ�������
Public Const DB_USER_NAME_CELL As String = "G5"                 ' ���[�U��
Public Const DB_PASSWORD_CELL As String = "J5"                  ' �p�X���[�h
Public Const DB_KEEP_PASSWORD_CELL As String = "M5"             ' �p�X���[�h�ۑ���
Public Const DB_ODBC_DRIVER_NAME_CELL As String = "E8"          ' ODBC�h���C�o


' ***********************
' ���̑��̒�`�i�񋓌^�j
' ***********************

' �G���[���
Enum ERROR_TYPE
    CHK_INFO = 1
    CHK_WARNING = 2
    CHK_ERROR = 3
End Enum

' ���͕����̑����i���g�p�j
Enum CHECK_TEXT_ATTR
    ATTR_STRING = 1
    ATTR_NUMERIC = 2
End Enum

Enum CHK_SHEET_STATUS
    NOT_TARGET = 0              ' �o�^���Ȃ��i"��"�����Ă��Ȃ��j
    CHECK_OK = 1                ' �o�^�i�G���[�Ȃ��j
    CHECK_WARNING = 2           ' �o�^�i�x������j
    CHECK_ERROR = 3             ' �o�^�s�i�G���[����j
    NOT_CHECKED = 9             ' ���`�F�b�N
End Enum

' �u���C���v�V�[�g�̃`�F�b�N����
Enum MAIN_SHEET_CHK_RSLT
    NO_CHECK_ERROR = 0          ' �G���[�Ȃ�
    NOT_SELECTED_ERROR = -1     ' �����Ώۂ����I��
    NENDO_NO_INPUT_ERROR = -2   ' �u�N�x�v�����̓G���[
End Enum

