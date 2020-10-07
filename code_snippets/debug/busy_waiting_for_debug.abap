*&---------------------------------------------------------------------*
*&      BUSY_WAITING_FOR_DEBUG
*&---------------------------------------------------------------------*
*       Wait for a specific length of time.
*
*       Busy-waiting is a technique that was necessary on systems that 
*       lacked a method of waiting a specific length of time.
*
*       SET/GET parameters for debug
*       - Z_DEBUG_IS_ACTIVE - Debug on/off switch
*       - Z_DEBUG_DURATION  - Debug duration in seconds
*
*       SM51 - Work Processes
*----------------------------------------------------------------------*
FORM busy_waiting_for_debug.

  DATA:
    lv_time TYPE sy-uzeit,
    lv_actv TYPE boolean,
    lv_dura TYPE numc3,
    lv_diff TYPE i.

  GET PARAMETER ID 'Z_DEBUG_IS_ACTIVE' FIELD lv_actv.
  GET PARAMETER ID 'Z_DEBUG_DURATION'  FIELD lv_dura.

  CHECK lv_actv EQ abap_true.
  CHECK lv_dura GT 0.

  GET TIME.
  lv_time = sy-uzeit.

  WHILE lv_actv EQ abap_true.
    GET TIME.
    lv_diff = sy-uzeit - lv_time.
    IF lv_diff GT lv_dura.
      EXIT. "while
    ENDIF.
  ENDWHILE.

ENDFORM.
