*--------------------------------------------------------------------*
* ZCL_FTP_UTIL
* FTP utility class
*--------------------------------------------------------------------*

CLASS zcl_ftp_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS connect
      IMPORTING
        !iv_host        TYPE c
        !iv_user        TYPE c
        !iv_pwd         TYPE c
        !iv_dest        TYPE rfcdest DEFAULT 'SAPFTPA'
      RETURNING
        VALUE(rv_subrc) TYPE sy-subrc .

    METHODS is_connected
      RETURNING
        VALUE(rv_result) TYPE boolean .
    
    METHODS execute_cmd
      IMPORTING
        !iv_command     TYPE c
        !iv_parameter   TYPE c OPTIONAL
      EXPORTING
        !et_result      TYPE table
      RETURNING
        VALUE(rv_subrc) TYPE sy-subrc .

    METHODS disconnect .
    
  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA mv_host TYPE char128 .
    DATA mv_user TYPE char50 .
    DATA mv_pwde TYPE char255 .
    DATA mv_dest TYPE rfcdest .
    DATA mv_hndl TYPE i .
    DATA mv_cmd  TYPE char255 .

ENDCLASS.



CLASS zcl_ftp_util IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_FTP_UTIL->CONNECT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_HOST                        TYPE        C
* | [--->] IV_USER                        TYPE        C
* | [--->] IV_PWD                         TYPE        C
* | [--->] IV_DEST                        TYPE        RFCDEST (default ='SAPFTPA')
* | [<-()] RV_SUBRC                       TYPE        SY-SUBRC
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD connect.
    "importing iv_host type c
    "importing iv_user type c
    "importing iv_pwd  type c
    "importing iv_dest type rfcdest default 'SAPFTPA'
    "returning value( rv_subrc ) type sy-subrc

*--------------------------------------------------------------------*

*    AUTHORITY-CHECK OBJECT 'S_ADMI_FCD'
*                        ID 'S_ADMI_FCD'
*                     FIELD 'SFTP'.
*    IF sy-subrc ne 0.
*      MESSAGE 'No authorization!' TYPE 'E'.
*      EXIT.
*    ENDIF.

*--------------------------------------------------------------------*

    CHECK NOT is_connected( ).

*--------------------------------------------------------------------*

    mv_host = iv_host.
    mv_user = iv_user.
    mv_dest = iv_dest.

*--------------------------------------------------------------------*

    CALL FUNCTION 'HTTP_SCRAMBLE'
      EXPORTING
        source      = iv_pwd
        sourcelen   = strlen( iv_pwd )
        key         = '26101957'
      IMPORTING
        destination = mv_pwde.

    CALL FUNCTION 'FTP_CONNECT'
      EXPORTING
        user            = mv_user
        password        = mv_pwde
        host            = mv_host
        rfc_destination = mv_dest
      IMPORTING
        handle          = mv_hndl
      EXCEPTIONS
        not_connected   = 1
        OTHERS          = 2.

    rv_subrc = sy-subrc.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_FTP_UTIL->DISCONNECT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD disconnect.

    CALL FUNCTION 'FTP_DISCONNECT'
      EXPORTING
        handle = mv_hndl.

    CALL FUNCTION 'RFC_CONNECTION_CLOSE'
      EXPORTING
        destination = mv_dest
      EXCEPTIONS
        OTHERS      = 2.

    CLEAR:
      mv_host,
      mv_user,
      mv_pwde,
      mv_dest,
      mv_hndl.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_FTP_UTIL->EXECUTE_CMD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_COMMAND                     TYPE        C
* | [--->] IV_PARAMETER                   TYPE        C(optional)
* | [<---] ET_RESULT                      TYPE        TABLE
* | [<-()] RV_SUBRC                       TYPE        SY-SUBRC
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD execute_cmd.
    "importing iv_command        type c
    "importing iv_parameter      type c
    "exporting et_result         type table
    "returning value( rv_subrc ) type sy-subrc

    CONCATENATE iv_command iv_parameter
           INTO mv_cmd SEPARATED BY space.

    CALL FUNCTION 'FTP_COMMAND'
      EXPORTING
        handle        = mv_hndl
        command       = mv_cmd
      TABLES
        data          = et_result
      EXCEPTIONS
        tcpip_error   = 1
        command_error = 2
        data_error    = 3
        OTHERS        = 4.

    rv_subrc = sy-subrc.
    CLEAR mv_cmd.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_FTP_UTIL->IS_CONNECTED
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_RESULT                      TYPE        BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_connected.

    IF mv_hndl IS INITIAL.
      rv_result = abap_false.
    ELSE.
      rv_result = abap_true.
    ENDIF.

  ENDMETHOD.
  
ENDCLASS.
