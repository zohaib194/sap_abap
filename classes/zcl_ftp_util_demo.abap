*--------------------------------------------------------------------*
* Demo: Class ZCL_FTP_UTIL
*--------------------------------------------------------------------*

REPORT sy-repid.

PARAMETERS:
  p_host TYPE char70  DEFAULT 'ftp.dlptest.com'           LOWER CASE,
  p_user TYPE char70  DEFAULT 'dlpuser@dlptest.com'       LOWER CASE,
  p_pwd  TYPE char70  DEFAULT 'SzMf7rTE4pCrf9dV286GuNe4N' LOWER CASE,
  p_dest TYPE rfcdest DEFAULT 'SAPFTP'. " SAPFTP or SAPFTPA

PARAMETERS:
  p_srcdir TYPE char70 DEFAULT '/path/to/src/', " Source directory
  p_file   TYPE char70 DEFAULT 'file.ext',      " File to transfer
  p_ftpdir TYPE char70 DEFAULT '/path/to/ftp/'. " FTP Server directory

*--------------------------------------------------------------------*

DATA:
  go_ftp    TYPE REF TO zcl_ftp_util,
  gv_cmd    TYPE char255,
  gs_result TYPE char255,
  gt_result TYPE tchar255.

*--------------------------------------------------------------------*
* START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

  CREATE OBJECT go_ftp.
  CHECK go_ftp IS BOUND.

* Connect to FTP
  CALL METHOD go_ftp->connect
    EXPORTING
      iv_host = p_host
      iv_user = p_user
      iv_pwd  = p_pwd
      iv_dest = p_dest.

  CHECK go_ftp->is_connected( ).

* Change local directory
  CALL METHOD go_ftp->execute_cmd
    EXPORTING
      iv_command   = 'lcd'
      iv_parameter = p_srcdir
    IMPORTING
      et_result    = gt_result.

* Create remote directory
  CALL METHOD go_ftp->execute_cmd
    EXPORTING
      iv_command   = 'mkdir'
      iv_parameter = p_ftpdir
    IMPORTING
      et_result    = gt_result.

* Change remote directory
  CALL METHOD go_ftp->execute_cmd
    EXPORTING
      iv_command   = 'cd'
      iv_parameter = p_ftpdir
    IMPORTING
      et_result    = gt_result.

* Transfer the file
  CALL METHOD go_ftp->execute_cmd
    EXPORTING
      iv_command   = 'put'
      iv_parameter = p_file
    IMPORTING
      et_result    = gt_result.

* Disconnect from FTP
  CALL METHOD go_ftp->disconnect.

* Display results
  LOOP AT gt_result INTO gs_result.
    WRITE / gs_result.
  ENDLOOP.
