*--------------------------------------------------------------------*
* File Transfer Using FTP
*--------------------------------------------------------------------*

REPORT sy-repid.

PARAMETERS:
  p_host   TYPE char70  DEFAULT 'ftp.dlptest.com'           LOWER CASE,
  p_user   TYPE char70  DEFAULT 'dlpuser@dlptest.com'       LOWER CASE,
  p_pwd    TYPE char70  DEFAULT 'SzMf7rTE4pCrf9dV286GuNe4N' LOWER CASE,
  p_dest   TYPE rfcdest DEFAULT 'SAPFTP'. " SAPFTP or SAPFTPA

PARAMETERS:
  p_srcdir TYPE string  DEFAULT '/path/to/src/', " Source directory
  p_file   TYPE string  DEFAULT 'file.ext',      " File to transfer
  p_ftpdir TYPE string  DEFAULT '/path/to/ftp/'. " FTP Server directory

*--------------------------------------------------------------------*

TYPES:
  BEGIN OF ty_s_cmd,
    line(255) TYPE c,
  END OF ty_s_cmd.

TYPES:
  BEGIN OF ty_s_result,
    line(255) TYPE c,
  END OF ty_s_result.

*--------------------------------------------------------------------*

DATA:
  gv_host(70)  TYPE c,
  gv_user(70)  TYPE c,
  gv_pwd(70)   TYPE c,
  gv_pwde(255) TYPE c,              "Encrypted password
  gv_dest      TYPE rfcdes-rfcdest, "SAPFTP or SAPFTPA
  gv_hdl       TYPE i.

DATA:
  gv_src_dir TYPE string,
  gv_file    TYPE string,
  gv_ftp_dir TYPE string.

DATA:
  gs_cmd    TYPE ty_s_cmd,
  gt_cmd    TYPE TABLE OF ty_s_cmd,
  gs_result TYPE ty_s_result,
  gt_result TYPE TABLE OF ty_s_result.

*--------------------------------------------------------------------*
* START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

  gv_host    = p_host.
  gv_user    = p_user.
  gv_pwd     = p_pwd.
  gv_dest    = p_dest.   "SAPFTP or SAPFTPA
  gv_src_dir = p_srcdir. "Source directory
  gv_file    = p_file.   "File to transfer
  gv_ftp_dir = p_ftpdir. "FTP Server directory

  PERFORM ftp_connect.
  PERFORM ftp_command.
  PERFORM ftp_disconnect.
  PERFORM ftp_result.

*&---------------------------------------------------------------------*
*&      Form  FTP_CONNECT
*&---------------------------------------------------------------------*
FORM ftp_connect .

  "DATA lv_slen TYPE i.
  "lv_slen = strlen( gv_pwd ).

  CALL FUNCTION 'HTTP_SCRAMBLE'
    EXPORTING
      source      = gv_pwd
      sourcelen   = strlen( gv_pwd )
      key         = '26101957'
    IMPORTING
      destination = gv_pwde.

  CALL FUNCTION 'FTP_CONNECT'
    EXPORTING
      user            = gv_user
      password        = gv_pwde
      host            = gv_host
      rfc_destination = gv_dest
    IMPORTING
      handle          = gv_hdl
    EXCEPTIONS
      not_connected   = 1
      OTHERS          = 2.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FTP_DISCONNECT
*&---------------------------------------------------------------------*
FORM ftp_disconnect .

  CALL FUNCTION 'FTP_DISCONNECT'
    EXPORTING
      handle = gv_hdl.

  CALL FUNCTION 'RFC_CONNECTION_CLOSE'
    EXPORTING
      destination = gv_dest
    EXCEPTIONS
      OTHERS      = 2.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FTP_COMMAND
*&---------------------------------------------------------------------*
FORM ftp_command .

* Fill FTP commands

  " Change local directory
  CONCATENATE 'lcd' gv_src_dir INTO gs_cmd-line SEPARATED BY space.
  APPEND gs_cmd TO gt_cmd.

  " Create remote directory
  CONCATENATE 'mkdir' gv_ftp_dir INTO gs_cmd-line SEPARATED BY space.
  APPEND gs_cmd TO gt_cmd.

  " Change remote directory
  CONCATENATE 'cd' gv_ftp_dir INTO gs_cmd-line SEPARATED BY space.
  APPEND gs_cmd TO gt_cmd.

  " Transfer the file
  CONCATENATE 'put' gv_file INTO gs_cmd-line SEPARATED BY space.
  APPEND gs_cmd TO gt_cmd.

* Execute FTP commands

  LOOP AT gt_cmd INTO gs_cmd WHERE line IS NOT INITIAL.
    CALL FUNCTION 'FTP_COMMAND'
      EXPORTING
        handle        = gv_hdl
        command       = gs_cmd-line
      TABLES
        data          = gt_result
      EXCEPTIONS
        tcpip_error   = 1
        command_error = 2
        data_error    = 3
        OTHERS        = 4.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FTP_RESULT
*&---------------------------------------------------------------------*
FORM ftp_result .

  LOOP AT gt_result INTO gs_result.
    WRITE / gs_result-line.
  ENDLOOP.

ENDFORM.
