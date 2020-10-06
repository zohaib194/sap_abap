*--------------------------------------------------------------------*
* Demo: Class ZCL_APPL_LOG
*--------------------------------------------------------------------*

REPORT sy-repid.

PARAMETERS p_disp DEFAULT 'P'. "(P)opup, (F)ullscreen
PARAMETERS p_sess DEFAULT 'X'.
PARAMETERS p_dlvl DEFAULT 'X'.

DATA:
  lr_appl_log TYPE REF TO zcl_appl_log ##NEEDED,
  lx_appl_log TYPE REF TO zcx_appl_log ##NEEDED,
  lv_msgtx    TYPE msgfulltxt ##NEEDED.

DATA:
  ev_log_handle TYPE balloghndl,
  ev_log_number TYPE balognr,
  ev_ext_number TYPE balnrext.

TRY.
    CREATE OBJECT lr_appl_log
      EXPORTING
        iv_logobject = 'MASS'
        iv_subobject = 'TEST'
        iv_keep_days = 3.

  CATCH zcx_appl_log INTO lx_appl_log.
    lx_appl_log->display( ).
    RETURN.
ENDTRY.

DO 3 TIMES.
  lv_msgtx = sy-index.
  CONDENSE lv_msgtx.
  CONCATENATE 'Message text - ' lv_msgtx INTO lv_msgtx.

  TRY .
      MESSAGE s000(55) WITH lv_msgtx INTO lv_msgtx.
      lr_appl_log->add_sy_message( ).

      lr_appl_log->inc_detlevel( ).

      MESSAGE i000(55) WITH lv_msgtx '-1' INTO lv_msgtx.
      lr_appl_log->add_sy_message( ).

      MESSAGE w000(55) WITH lv_msgtx '-2' INTO lv_msgtx.
      lr_appl_log->add_sy_message( ).

      MESSAGE e000(55) WITH lv_msgtx '-3' INTO lv_msgtx.
      lr_appl_log->add_sy_message( ).

      lr_appl_log->dec_detlevel( ).

    CATCH zcx_appl_log INTO lx_appl_log.
      lx_appl_log->display( ).
      RETURN.
  ENDTRY.
ENDDO.

*TRY.
*    CALL METHOD lr_appl_log->save_to_db
*      IMPORTING
*        ev_log_handle = ev_log_handle
*        ev_log_number = ev_log_number
*        ev_ext_number = ev_ext_number.
*
*  CATCH zcx_appl_log INTO lx_appl_log.
*    lx_appl_log->display( ).
*    RETURN.
*ENDTRY.

DO 3 TIMES.
  lv_msgtx = sy-index.
  CONDENSE lv_msgtx.
  CONCATENATE 'Message text - ' lv_msgtx INTO lv_msgtx.

  TRY .
      MESSAGE s000(55) WITH lv_msgtx INTO lv_msgtx.
      lr_appl_log->add_sy_message( ).

      lr_appl_log->inc_detlevel( ).

      MESSAGE i000(55) WITH lv_msgtx '-1' INTO lv_msgtx.
      lr_appl_log->add_sy_message( ).

      MESSAGE w000(55) WITH lv_msgtx '-2' INTO lv_msgtx.
      lr_appl_log->add_sy_message( ).

      MESSAGE e000(55) WITH lv_msgtx '-3' INTO lv_msgtx.
      lr_appl_log->add_sy_message( ).

      lr_appl_log->dec_detlevel( ).

    CATCH zcx_appl_log INTO lx_appl_log.
      lx_appl_log->display( ).
      RETURN.
  ENDTRY.
ENDDO.

*TRY.
*    CALL METHOD lr_appl_log->save_to_db
*      IMPORTING
*        ev_log_handle = ev_log_handle
*        ev_log_number = ev_log_number
*        ev_ext_number = ev_ext_number.
*
*  CATCH zcx_appl_log INTO lx_appl_log.
*    lx_appl_log->display( ).
*    RETURN.
*ENDTRY.

TRY.
    lr_appl_log->display( iv_display_type = p_disp
                          iv_new_session  = p_sess
                          iv_by_detlevel  = p_dlvl ).

  CATCH zcx_appl_log INTO lx_appl_log.
    lx_appl_log->display( ).
    RETURN.
ENDTRY.
