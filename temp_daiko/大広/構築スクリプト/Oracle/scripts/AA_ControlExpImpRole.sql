SET SERVEROUTPUT ON;
SET VERIFY OFF;

DECLARE
    USER_NAME VARCHAR2(40);
    PROC_TYPE VARCHAR2(40);
    ROLE_TYPE VARCHAR2(40);
    ROLE_KIND VARCHAR2(40);

    w_count   PLS_INTEGER;
BEGIN
    USER_NAME := UPPER('&1');
    ROLE_TYPE := UPPER('&2');
    PROC_TYPE := UPPER('&3');

    IF ROLE_TYPE = 'EXP' THEN
        ROLE_KIND := 'EXP_FULL_DATABASE';
    ELSIF ROLE_TYPE = 'IMP' THEN
        ROLE_KIND := 'IMP_FULL_DATABASE';
    END IF;

    IF PROC_TYPE = 'GRANT' THEN
        -- 当該ユーザに適切なロールが付与されているか？
        SELECT COUNT(*) INTO w_count FROM DBA_ROLE_PRIVS WHERE GRANTEE = USER_NAME AND GRANTED_ROLE = ROLE_KIND;

        IF w_count = 0 THEN
            DBMS_OUTPUT.NEW_LINE;
            DBMS_OUTPUT.NEW_LINE;
            DBMS_OUTPUT.PUT_LINE( '★★適切なロールが付与されていないため、ロールを付与します。★★' );

            EXECUTE IMMEDIATE 'GRANT ' || ROLE_KIND || ' TO ' || USER_NAME;
        END IF;
    ELSIF PROC_TYPE = 'REVOKE' THEN
        EXECUTE IMMEDIATE 'REVOKE ' || ROLE_KIND || ' FROM ' || USER_NAME;

        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE( '★★エクスポートまたはインポートのロールを取り消しました。★★' );
    END IF;
END;
/

exit
