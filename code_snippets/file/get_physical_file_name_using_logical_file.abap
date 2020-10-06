*--------------------------------------------------------------------*
* Get Physical File Name Using Logical File
*--------------------------------------------------------------------*
* Prerequisites
*  1. Define Logical File Path and Logical File Name (TCode FILE)
*   1.1. Launch the FILE transaction.
*   1.2. Select 'Logical File Path Definition' and click the 
*        'New Entries' button.
*   1.3. Enter the following values:
*          Logical file path: Z_LOGICAL_PATH
*          Name             : Path 'folder'
*   1.4. Click the 'Save' button.
*   1.5. Select the logical file path 'Z_LOGICAL_PATH' and double
*        click 'Assignment of Physical Paths to Logical Path'.
*   1.6. Select a syntax group and enter the physical path. 
*          Syntax group : UNIX
*          Physical path: /usr/sap/<SYSID>/[FOLDER]/<FILENAME>
*   1.7. Click the 'Save' button.
*   1.8. Double click 'Logical File Name Definition, Cross-Client'.
*   1.9. Click 'New Entries' and enter the following values:
*          Log. File    : Z_LOGICAL_FILE
*          Name         : <Logical file description>
*          Physical file: prefix_<DATE><HOUR><MINUTE><SECOND>.txt or 
*                         prefix_<DATE><TIME>.txt 
*                         (i) Physical file name format.
*          Data format  : ASC
*          Logical path : Z_LOGICAL_PATH
*                         (i) Logical path to store the file.
*   1.10. Click the 'Save' button.
*--------------------------------------------------------------------*

PARAMETERS:
  p_lfile TYPE filename-fileintern DEFAULT 'Z_LOGICAL_FILE'.

DATA:
  lv_lfile TYPE filename-fileintern, "Physical path
  lv_pfile TYPE c LENGTH 255,        "Physical file
  lv_pfrmt TYPE filename-fileformat. "File format

lv_lfile = p_lfile.

CALL FUNCTION 'FILE_GET_NAME'
  EXPORTING
    logical_filename = lv_lfile
    operating_system = sy-opsys
  IMPORTING
    file_format      = lv_pfrmt
    file_name        = lv_pfile
  EXCEPTIONS
    file_not_found   = 1
    OTHERS           = 2.

CALL FUNCTION 'FILE_VALIDATE_NAME'
  EXPORTING
    logical_filename           = lv_lfile
    operating_system           = sy-opsys
  CHANGING
    physical_filename          = lv_pfile
  EXCEPTIONS
    logical_filename_not_found = 1
    validation_failed          = 2
    OTHERS                     = 3.

WRITE:
  / 'Logical file :', lv_lfile,
  / 'Physical file:', lv_pfile,
  / 'File format  :', lv_pfrmt.
  
*--------------------------------------------------------------------*
* Result
*--------------------------------------------------------------------*
* Logical file : Z_LOGICAL_FILE
* Physical file: /usr/sap/[SYSID]>/[FOLDER]/prefix_20200628203629.txt
* File format  : ASC
