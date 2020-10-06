*--------------------------------------------------------------------*
* Encryption and Decryption a Text Using Class CL_SEC_SXML_WRITER
*--------------------------------------------------------------------*

DATA:
  lv_key        TYPE xstring,
  lv_inputtext  TYPE string,
  lv_plaintext  TYPE xstring,
  lv_ciphertext TYPE xstring,
  lt_binary     TYPE TABLE OF x,
  lv_length     TYPE i.

*--------------------------------------------------------------------*

lv_inputtext = 'Lorem ipsum dolor sit amet.'.
WRITE:/ 'Inputtext :', lv_inputtext.

*--------------------------------------------------------------------*

CLEAR lv_plaintext.

CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
  EXPORTING
    text   = lv_inputtext
  IMPORTING
    buffer = lv_plaintext
  EXCEPTIONS
    failed = 1
    OTHERS = 2.

IF sy-subrc <> 0.
  RETURN.
ENDIF.

WRITE:/ 'Plaintext :', lv_plaintext.

*--------------------------------------------------------------------*

CALL METHOD cl_sec_sxml_writer=>generate_key
  EXPORTING
    algorithm = cl_sec_sxml_writer=>co_aes128_algorithm
  RECEIVING
    key       = lv_key.

WRITE:/ 'Key       :', lv_key.

*--------------------------------------------------------------------*

CLEAR lv_ciphertext.

CALL METHOD cl_sec_sxml_writer=>encrypt
  EXPORTING
    plaintext  = lv_plaintext
    key        = lv_key
    algorithm  = cl_sec_sxml_writer=>co_aes128_algorithm
  IMPORTING
    ciphertext = lv_ciphertext.

WRITE:/ 'Ciphertext:', lv_ciphertext.

*--------------------------------------------------------------------*

CLEAR lv_plaintext.

CALL METHOD cl_sec_sxml_writer=>decrypt
  EXPORTING
    ciphertext = lv_ciphertext
    key        = lv_key
    algorithm  = cl_sec_sxml_writer=>co_aes128_algorithm
  IMPORTING
    plaintext  = lv_plaintext.

WRITE:/ 'Plaintext :', lv_plaintext.

*--------------------------------------------------------------------*

CLEAR lv_inputtext.

CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
  EXPORTING
    buffer        = lv_plaintext
  IMPORTING
    output_length = lv_length
  TABLES
    binary_tab    = lt_binary.

CALL FUNCTION 'SCMS_BINARY_TO_STRING'
  EXPORTING
    input_length = lv_length
  IMPORTING
    text_buffer  = lv_inputtext
  TABLES
    binary_tab   = lt_binary
  EXCEPTIONS
    failed       = 1
    OTHERS       = 2.

WRITE:/ 'Inputtext :', lv_inputtext.
