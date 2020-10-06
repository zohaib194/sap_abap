*--------------------------------------------------------------------*
* Read Multiple Texts (Selection Using Wildcards or Ranges Tables)
*--------------------------------------------------------------------*

TYPES:
  BEGIN OF ty_tdname,
    vbeln TYPE vbeln,
    posnr TYPE posnr,
  END OF ty_tdname.

DATA:
  ls_tdname  TYPE ty_tdname,
  ls_tdrname TYPE stxdrname,
  lt_tdrname TYPE tspsrname,
  lt_text_hl TYPE text_lh.   "Header + Lines

*--------------------------------------------------------------------*

DEFINE collect_names.
  ls_tdrname = 'IEQ'.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = &1 "vbeln
    IMPORTING
      output = ls_tdname-vbeln.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = &2 "posnr
    IMPORTING
      output = ls_tdname-posnr.

  ls_tdrname-low = ls_tdname.
  COLLECT ls_tdrname INTO lt_tdrname.
END-OF-DEFINITION.

*--------------------------------------------------------------------*

collect_names:
  '<vbeln>' '<posnr>',
  '<vbeln>' '<posnr>'.

*--------------------------------------------------------------------*

CALL FUNCTION 'READ_MULTIPLE_TEXTS'
  EXPORTING
    object      = 'VBBP'
    id          = '0001'
    language    = '*'
    name_ranges = lt_tdrname
  IMPORTING
    text_table  = lt_text_hl
  EXCEPTIONS
    OTHERS      = 2.

*--------------------------------------------------------------------*

LOOP AT lt_text_hl ASSIGNING FIELD-SYMBOL(<ls_text_hl>).
  ls_tdname = <ls_text_hl>-header-tdname.
  WRITE:/ 'VBELN:', ls_tdname-vbeln.
  WRITE:/ 'POSNR:', ls_tdname-posnr.
  WRITE:/ 'LANGU:', <ls_text_hl>-header-tdspras.

  WRITE:/ 'TEXT :'.
  LOOP AT <ls_text_hl>-lines ASSIGNING FIELD-SYMBOL(<ls_lines>).
    WRITE:/ <ls_lines>.
  ENDLOOP.

  ULINE.
ENDLOOP.
