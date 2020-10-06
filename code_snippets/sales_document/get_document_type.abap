*----------------------------------------------------------------------*
* Sales Document - Get Document Type
*----------------------------------------------------------------------*

DATA:
  lv_vbeln TYPE vbeln,
  ls_kopf  TYPE vbkop.

CALL FUNCTION 'RV_GET_DOCUMENT_TYPE'
  EXPORTING
    vbeln   = lv_vbeln
  IMPORTING
    kopf_wa = ls_kopf
  EXCEPTIONS
    no_likp = 1
    no_lips = 2
    no_mseg = 3
    no_vbak = 4
    no_vbap = 5
    no_vbbk = 6
    no_vbep = 7
    no_vbrk = 8
    no_vbrp = 9
    no_vbuk = 10
    OTHERS  = 11.

"VBKOP-BEZKO - Document Type Description
"VBKOP-KUNNR - Customer Number
"VBKOP-VBART - SD Document Type
"VBKOP-VBTYP - SD Document Category
"VBKOP-VBGRP - SD Document Group
"VBKOP-VKORG - Sales Organization
"VBKOP-VTWEG - Distribution Channel
