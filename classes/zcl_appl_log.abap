*--------------------------------------------------------------------*
* ZCL_APPL_LOG
* Application log utility class
*--------------------------------------------------------------------*
* Prerequisites 
*  1. Exception Class ZCX_APPL_LOG
*       Super Class: CX_STATIC_CHECK
*       Description: Exception Class for ZCL_APPL_LOG
*       Interfaces : IF_T100_MESSAGE
*       Methods    : METHOD display.
*                      MESSAGE me TYPE 'I'.
*                    ENDMETHOD.
*--------------------------------------------------------------------*

CLASS zcl_appl_log DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !iv_logobject TYPE balobj_d
        !iv_subobject TYPE balsubobj
        !iv_extnumber TYPE balnrext OPTIONAL
        !iv_keep_days TYPE i OPTIONAL
      RAISING
        zcx_appl_log .

    METHODS add_message
      IMPORTING
        !is_message  TYPE bal_s_msg
        !iv_detlevel TYPE ballevel OPTIONAL
        !iv_cumulate TYPE boolean OPTIONAL
      RAISING
        zcx_appl_log .

    METHODS add_sy_message
      IMPORTING
        !iv_detlevel TYPE ballevel OPTIONAL
        !iv_cumulate TYPE boolean OPTIONAL
      RAISING
        zcx_appl_log .

    METHODS add_exception
      IMPORTING
        !io_exception TYPE REF TO cx_root
        !iv_detlevel  TYPE ballevel OPTIONAL
      RAISING
        zcx_appl_log .

    METHODS add_bapireturn
      IMPORTING
        !is_bapiret  TYPE bapiret2 OPTIONAL
        !it_bapiret  TYPE bapiret2_tab OPTIONAL
        !iv_detlevel TYPE ballevel OPTIONAL
        !iv_cumulate TYPE boolean OPTIONAL
      RAISING
        zcx_appl_log .

    METHODS add_bdcmsgcoll
      IMPORTING
        !is_bdcmsg   TYPE bdcmsgcoll OPTIONAL
        !it_bdcmsg   TYPE tab_bdcmsgcoll OPTIONAL
        !iv_detlevel TYPE ballevel OPTIONAL
        !iv_cumulate TYPE boolean OPTIONAL
      RAISING
        zcx_appl_log .

    METHODS get_log_handle
      RETURNING
        VALUE(rv_log_handle) TYPE balloghndl .

    METHODS get_log_number
      RETURNING
        VALUE(rv_log_number) TYPE balognr .

    METHODS get_ext_number
      RETURNING
        VALUE(rv_ext_number) TYPE balnrext .

    METHODS get_messages
      EXPORTING
        !et_message  TYPE bal_t_msg
        !et_bapiret2 TYPE bapiret2_t
      RAISING
        zcx_appl_log .

    METHODS get_msg_counts
      EXPORTING
        !ev_msg_cnt_a   TYPE i
        !ev_msg_cnt_e   TYPE i
        !ev_msg_cnt_w   TYPE i
        !ev_msg_cnt_i   TYPE i
        !ev_msg_cnt_s   TYPE i
        !ev_msg_cnt_all TYPE i
      RAISING
        zcx_appl_log .

    METHODS get_detlevel
      RETURNING
        VALUE(rv_detlevel) TYPE ballevel .

    METHODS dec_detlevel .

    METHODS inc_detlevel .

    METHODS is_empty
      RETURNING
        VALUE(rv_is_empty) TYPE boolean
      RAISING
        zcx_appl_log .

    METHODS has_error
      RETURNING
        VALUE(rv_has_error) TYPE boolean
      RAISING
        zcx_appl_log .

    METHODS delete_messages
      RAISING
        zcx_appl_log .

    METHODS read_from_db
      RAISING
        zcx_appl_log .

    METHODS save_to_db
      EXPORTING
        !ev_log_handle TYPE balloghndl
        !ev_log_number TYPE balognr
        !ev_ext_number TYPE balnrext
      RAISING
        zcx_appl_log .

    METHODS display
      IMPORTING
        !iv_display_type TYPE char1 OPTIONAL
        !iv_new_session  TYPE boolean OPTIONAL
        !iv_by_detlevel  TYPE boolean OPTIONAL
      RAISING
        zcx_appl_log .

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA mv_log_handle TYPE balloghndl .
    DATA ms_log_header TYPE bal_s_log .
    DATA mv_log_number TYPE balognr .
    DATA ms_log_message TYPE bal_s_msg .
    DATA mv_log_detlevel TYPE ballevel .

    METHODS get_text_id
      RETURNING
        VALUE(rs_text_id) TYPE scx_t100key .

    METHODS get_problem_class
      RETURNING
        VALUE(rv_problem_class) TYPE bal_s_msg-probclass .

ENDCLASS.

CLASS zcl_appl_log IMPLEMENTATION.

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->ADD_BAPIRETURN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_BAPIRET                     TYPE        BAPIRET2(optional)
* | [--->] IT_BAPIRET                     TYPE        BAPIRET2_TAB(optional)
* | [--->] IV_DETLEVEL                    TYPE        BALLEVEL(optional)
* | [--->] IV_CUMULATE                    TYPE        BOOLEAN(optional)
* | [!CX!] ZCX_APPL_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_bapireturn.

* Add BAPI return messages

    FIELD-SYMBOLS:
      <ls_bapiret> TYPE bapiret2.

    IF is_bapiret IS SUPPLIED.
      CLEAR ms_log_message.
      ms_log_message-msgty = is_bapiret-type.
      ms_log_message-msgid = is_bapiret-id.
      ms_log_message-msgno = is_bapiret-number.
      ms_log_message-msgv1 = is_bapiret-message_v1.
      ms_log_message-msgv2 = is_bapiret-message_v2.
      ms_log_message-msgv3 = is_bapiret-message_v3.
      ms_log_message-msgv4 = is_bapiret-message_v4.

      IF iv_detlevel IS SUPPLIED.
        ms_log_message-detlevel = iv_detlevel.
      ELSE.
        ms_log_message-detlevel = mv_log_detlevel.
      ENDIF.

      TRY .
          CALL METHOD add_message
            EXPORTING
              is_message  = ms_log_message
              iv_cumulate = iv_cumulate.

        CATCH zcx_appl_log .
          RAISE EXCEPTION TYPE zcx_appl_log
            EXPORTING
              textid = get_text_id( ).
      ENDTRY.
    ENDIF.

    LOOP AT it_bapiret ASSIGNING <ls_bapiret>.
      CLEAR ms_log_message.
      ms_log_message-msgty = <ls_bapiret>-type.
      ms_log_message-msgid = <ls_bapiret>-id.
      ms_log_message-msgno = <ls_bapiret>-number.
      ms_log_message-msgv1 = <ls_bapiret>-message_v1.
      ms_log_message-msgv2 = <ls_bapiret>-message_v2.
      ms_log_message-msgv3 = <ls_bapiret>-message_v3.
      ms_log_message-msgv4 = <ls_bapiret>-message_v4.

      IF iv_detlevel IS SUPPLIED.
        ms_log_message-detlevel = iv_detlevel.
      ELSE.
        ms_log_message-detlevel = mv_log_detlevel.
      ENDIF.

      TRY .
          CALL METHOD add_message
            EXPORTING
              is_message  = ms_log_message
              iv_cumulate = iv_cumulate.

        CATCH zcx_appl_log .
          RAISE EXCEPTION TYPE zcx_appl_log
            EXPORTING
              textid = get_text_id( ).
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.                    "add_bapireturn

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->ADD_BDCMSGCOLL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_BDCMSG                      TYPE        BDCMSGCOLL(optional)
* | [--->] IT_BDCMSG                      TYPE        TAB_BDCMSGCOLL(optional)
* | [--->] IV_DETLEVEL                    TYPE        BALLEVEL(optional)
* | [--->] IV_CUMULATE                    TYPE        BOOLEAN(optional)
* | [!CX!] ZCX_APPL_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_bdcmsgcoll.

* Add batch input messages

    FIELD-SYMBOLS:
      <ls_bdcmsg> TYPE bdcmsgcoll.

    IF is_bdcmsg IS SUPPLIED.
      CLEAR ms_log_message.
      ms_log_message-msgty = is_bdcmsg-msgtyp.
      ms_log_message-msgid = is_bdcmsg-msgid.
      ms_log_message-msgno = is_bdcmsg-msgnr.
      ms_log_message-msgv1 = is_bdcmsg-msgv1.
      ms_log_message-msgv2 = is_bdcmsg-msgv2.
      ms_log_message-msgv3 = is_bdcmsg-msgv3.
      ms_log_message-msgv4 = is_bdcmsg-msgv4.

      IF iv_detlevel IS SUPPLIED.
        ms_log_message-detlevel = iv_detlevel.
      ELSE.
        ms_log_message-detlevel = mv_log_detlevel.
      ENDIF.

      TRY .
          CALL METHOD add_message
            EXPORTING
              is_message  = ms_log_message
              iv_cumulate = iv_cumulate.

        CATCH zcx_appl_log .
          RAISE EXCEPTION TYPE zcx_appl_log
            EXPORTING
              textid = get_text_id( ).
      ENDTRY.
    ENDIF.

    LOOP AT it_bdcmsg ASSIGNING <ls_bdcmsg>.
      CLEAR ms_log_message.
      ms_log_message-msgty = <ls_bdcmsg>-msgtyp.
      ms_log_message-msgid = <ls_bdcmsg>-msgid.
      ms_log_message-msgno = <ls_bdcmsg>-msgnr.
      ms_log_message-msgv1 = <ls_bdcmsg>-msgv1.
      ms_log_message-msgv2 = <ls_bdcmsg>-msgv2.
      ms_log_message-msgv3 = <ls_bdcmsg>-msgv3.
      ms_log_message-msgv4 = <ls_bdcmsg>-msgv4.

      IF iv_detlevel IS SUPPLIED.
        ms_log_message-detlevel = iv_detlevel.
      ELSE.
        ms_log_message-detlevel = mv_log_detlevel.
      ENDIF.

      TRY .
          CALL METHOD add_message
            EXPORTING
              is_message  = ms_log_message
              iv_cumulate = iv_cumulate.

        CATCH zcx_appl_log .
          RAISE EXCEPTION TYPE zcx_appl_log
            EXPORTING
              textid = get_text_id( ).
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.                    "add_bdcmsgcoll

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->ADD_EXCEPTION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_EXCEPTION                   TYPE REF TO CX_ROOT
* | [--->] IV_DETLEVEL                    TYPE        BALLEVEL(optional)
* | [!CX!] ZCX_APPL_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_exception.

* Add exception

    DATA:
      lo_exception TYPE REF TO cx_root,
      ls_exception TYPE bal_s_exc.

    CHECK io_exception IS BOUND.

    TRY .
        lo_exception ?= io_exception.
      CATCH cx_sy_move_cast_error .
    ENDTRY.

    " Add all exceptions in the exception chain

    WHILE lo_exception IS BOUND.
      TRY .
          ls_exception-msgty     = 'E'. "error
          ls_exception-exception = lo_exception.
          ls_exception-probclass = '2'. "important.

          CALL FUNCTION 'BAL_LOG_EXCEPTION_ADD'
            EXPORTING
              i_log_handle     = mv_log_handle
              i_s_exc          = ls_exception
            EXCEPTIONS
              log_not_found    = 1
              msg_inconsistent = 2
              log_is_full      = 3
              OTHERS           = 4.

          lo_exception = lo_exception->previous.

        CATCH zcx_appl_log .
          RAISE EXCEPTION TYPE zcx_appl_log
            EXPORTING
              textid = get_text_id( ).

        CATCH cx_sy_move_cast_error .
      ENDTRY.
    ENDWHILE.

* 2nd alternative

*    CHECK io_exception IS BOUND.
*
*    DATA lt_log_message TYPE rs_t_msg.
*
*    CALL FUNCTION 'RS_EXCEPTION_TO_MESSAGE'
*      EXPORTING
*        i_r_exception = io_exception
*      CHANGING
*        c_t_msg       = lt_log_message.
*
*    LOOP AT lt_log_message INTO ms_log_message.
*      IF iv_detlevel IS SUPPLIED.
*        ms_log_message-detlevel = iv_detlevel.
*      ELSE.
*        ms_log_message-detlevel = mv_log_detlevel.
*      ENDIF.
*
*      TRY.
*          CALL METHOD add_message
*            EXPORTING
*              is_message  = ms_log_message
*              iv_cumulate = iv_cumulate.
*
*        CATCH zcx_appl_log .
*          RAISE EXCEPTION TYPE zcx_appl_log
*            EXPORTING
*              textid = get_text_id( ).
*      ENDTRY.
*    ENDLOOP.

  ENDMETHOD.                    "add_exception

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->ADD_MESSAGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_MESSAGE                     TYPE        BAL_S_MSG
* | [--->] IV_DETLEVEL                    TYPE        BALLEVEL(optional)
* | [--->] IV_CUMULATE                    TYPE        BOOLEAN(optional)
* | [!CX!] ZCX_APPL_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_message.

* Add message

    ms_log_message = is_message.

    IF iv_detlevel IS SUPPLIED.
      ms_log_message-detlevel = iv_detlevel.
    ELSE.
      ms_log_message-detlevel = mv_log_detlevel.
    ENDIF.

    ms_log_message-probclass = get_problem_class( ).

    IF iv_cumulate IS INITIAL.

      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle     = mv_log_handle
          i_s_msg          = ms_log_message
        EXCEPTIONS
          log_not_found    = 1
          msg_inconsistent = 2
          log_is_full      = 3 "252(BL)
          OTHERS           = 4.

      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_appl_log
          EXPORTING
            textid = get_text_id( ).
      ENDIF.

    ELSE.

      CALL FUNCTION 'BAL_LOG_MSG_CUMULATE'
        EXPORTING
          i_log_handle         = mv_log_handle
          i_s_msg              = ms_log_message
          i_compare_attributes = abap_false
          i_compare_context    = abap_false
          i_compare_parameters = abap_false
        EXCEPTIONS
          log_not_found        = 1
          msg_inconsistent     = 2
          log_is_full          = 3
          OTHERS               = 4.

      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_appl_log
          EXPORTING
            textid = get_text_id( ).
      ENDIF.

    ENDIF.

  ENDMETHOD.                    "add_message

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->ADD_SY_MESSAGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DETLEVEL                    TYPE        BALLEVEL(optional)
* | [--->] IV_CUMULATE                    TYPE        BOOLEAN(optional)
* | [!CX!] ZCX_APPL_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_sy_message.

* Add system message

    CLEAR ms_log_message.

    ms_log_message-msgty = sy-msgty.
    ms_log_message-msgid = sy-msgid.
    ms_log_message-msgno = sy-msgno.
    ms_log_message-msgv1 = sy-msgv1.
    ms_log_message-msgv2 = sy-msgv2.
    ms_log_message-msgv3 = sy-msgv3.
    ms_log_message-msgv4 = sy-msgv4.

    IF iv_detlevel IS SUPPLIED.
      ms_log_message-detlevel = iv_detlevel.
    ELSE.
      ms_log_message-detlevel = mv_log_detlevel.
    ENDIF.

    ms_log_message-probclass = get_problem_class( ).

    TRY .
        CALL METHOD add_message
          EXPORTING
            is_message  = ms_log_message
            iv_cumulate = iv_cumulate.

      CATCH zcx_appl_log .
        RAISE EXCEPTION TYPE zcx_appl_log
          EXPORTING
            textid = get_text_id( ).
    ENDTRY.

  ENDMETHOD.                    "add_sy_message

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_LOGOBJECT                   TYPE        BALOBJ_D
* | [--->] IV_SUBOBJECT                   TYPE        BALSUBOBJ
* | [--->] IV_EXTNUMBER                   TYPE        BALNREXT(optional)
* | [--->] IV_KEEP_DAYS                   TYPE        I(optional)
* | [!CX!] ZCX_APPL_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.

* Set log header

    CLEAR ms_log_header.
    ms_log_header-extnumber  = iv_extnumber.
    ms_log_header-object     = iv_logobject.
    ms_log_header-subobject  = iv_subobject.
    ms_log_header-aldate_del = sy-datum + iv_keep_days. " Expiration Date

    IF ms_log_header-extnumber IS INITIAL.
      TRY.
          ms_log_header-extnumber = cl_system_uuid=>create_uuid_c32_static( ).
        CATCH cx_uuid_error.
      ENDTRY.
    ENDIF.

* Set detail level

    mv_log_detlevel = 1.

* Get log handle

    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log                 = ms_log_header
      IMPORTING
        e_log_handle            = mv_log_handle
      EXCEPTIONS
        log_header_inconsistent = 1
        OTHERS                  = 2.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_appl_log
        EXPORTING
          textid = get_text_id( ).
    ENDIF.

* Add log handle and external number as a first message

    TRY.
        DATA lv_msgtx TYPE msgfulltxt.

        MESSAGE i000(55) WITH 'Log handle:' mv_log_handle
                              'Ext.number:' ms_log_header-extnumber
                         INTO lv_msgtx.

        add_sy_message( ).

      CATCH zcx_appl_log .
    ENDTRY.

  ENDMETHOD.                    "constructor

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->DEC_DETLEVEL
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD dec_detlevel.

* Decrement detail level

    IF mv_log_detlevel GT 1.
      mv_log_detlevel = mv_log_detlevel - 1.
    ENDIF.

  ENDMETHOD.                    "set_detlevel

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->DELETE_MESSAGES
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] ZCX_APPL_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD delete_messages.

* Delete all messages

    CALL FUNCTION 'BAL_LOG_MSG_DELETE_ALL'
      EXPORTING
        i_log_handle  = mv_log_handle
      EXCEPTIONS
        log_not_found = 1
        OTHERS        = 2.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_appl_log
        EXPORTING
          textid = get_text_id( ).
    ENDIF.

  ENDMETHOD.                    "refresh

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->DISPLAY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DISPLAY_TYPE                TYPE        CHAR1(optional)
* | [--->] IV_NEW_SESSION                 TYPE        BOOLEAN(optional)
* | [--->] IV_BY_DETLEVEL                 TYPE        BOOLEAN(optional)
* | [!CX!] ZCX_APPL_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD display.

* Display log

    DATA:
      lt_log_handle      TYPE bal_t_logh,
      ls_display_profile TYPE bal_s_prof.

* Get display profile

    CASE iv_display_type.

      WHEN 'P'. " display popup
        IF iv_by_detlevel EQ abap_true.
          CALL FUNCTION 'BAL_DSP_PROFILE_DETLEVEL_GET'
            IMPORTING
              e_s_display_profile = ls_display_profile.
        ELSE.
          CALL FUNCTION 'BAL_DSP_PROFILE_POPUP_GET'
            IMPORTING
              e_s_display_profile = ls_display_profile.
        ENDIF.

        ls_display_profile-start_col = 5.
        ls_display_profile-start_row = 5.
        ls_display_profile-end_col   = 150.
        ls_display_profile-end_row   = 35.
        ls_display_profile-use_grid  = abap_true.

      WHEN 'F'. " display fullscreen
        IF iv_by_detlevel EQ abap_true.
          CALL FUNCTION 'BAL_DSP_PROFILE_DETLEVEL_GET'
            IMPORTING
              e_s_display_profile = ls_display_profile.
        ELSE.
          CALL FUNCTION 'BAL_DSP_PROFILE_STANDARD_GET'
            IMPORTING
              e_s_display_profile = ls_display_profile.
        ENDIF.
    ENDCASE.

* Display log

    APPEND mv_log_handle TO lt_log_handle.

    CALL FUNCTION 'BAL_DSP_LOG_DISPLAY'
      EXPORTING
        i_s_display_profile  = ls_display_profile
        i_t_log_handle       = lt_log_handle
        i_amodal             = iv_new_session
      EXCEPTIONS
        profile_inconsistent = 1
        internal_error       = 2
        no_data_available    = 3
        no_authority         = 4
        OTHERS               = 5.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_appl_log
        EXPORTING
          textid = get_text_id( ).
    ENDIF.

  ENDMETHOD.                    "display

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->GET_DETLEVEL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_DETLEVEL                    TYPE        BALLEVEL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_detlevel.

* Get detail level

    rv_detlevel = mv_log_detlevel.

  ENDMETHOD.                    "get_detlevel

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->GET_EXT_NUMBER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_EXT_NUMBER                  TYPE        BALNREXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ext_number.

* Get external number

    rv_ext_number = ms_log_header-extnumber.

  ENDMETHOD.                    "get_ext_number

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->GET_LOG_HANDLE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_LOG_HANDLE                  TYPE        BALLOGHNDL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_log_handle.

* Get log handle

    rv_log_handle = mv_log_handle.

  ENDMETHOD.                    "get_log_handle

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->GET_LOG_NUMBER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_LOG_NUMBER                  TYPE        BALOGNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_log_number.

* Get log number (log number is given only when the log is saved to the database)

    rv_log_number = mv_log_number.

  ENDMETHOD.                    "get_log_number

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->GET_MESSAGES
* +-------------------------------------------------------------------------------------------------+
* | [<---] ET_MESSAGE                     TYPE        BAL_T_MSG
* | [<---] ET_BAPIRET2                    TYPE        BAPIRET2_T
* | [!CX!] ZCX_APPL_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_messages.

* Get messages

    DATA:
      lt_logh TYPE bal_t_logh,
      lt_msgh TYPE bal_t_msgh,
      ls_msg  TYPE bal_s_msg.

    FIELD-SYMBOLS:
      <ls_msgh>     TYPE balmsghndl,
      <ls_bapiret2> TYPE bapiret2.

    CLEAR:
      et_message,
      et_bapiret2.

* Get all messages

    INSERT mv_log_handle INTO TABLE lt_logh.

    CALL FUNCTION 'BAL_GLB_SEARCH_MSG'
      EXPORTING
        i_t_log_handle = lt_logh
      IMPORTING
        e_t_msg_handle = lt_msgh
      EXCEPTIONS
        msg_not_found  = 1
        OTHERS         = 0.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_appl_log
        EXPORTING
          textid = get_text_id( ).
    ENDIF.

    " Get message long texts

    LOOP AT lt_msgh ASSIGNING <ls_msgh>.
      CLEAR ls_msg.

      CALL FUNCTION 'BAL_LOG_MSG_READ'
        EXPORTING
          i_s_msg_handle = <ls_msgh>
        IMPORTING
          e_s_msg        = ls_msg
        EXCEPTIONS
          log_not_found  = 1
          msg_not_found  = 2
          OTHERS         = 3.

      IF sy-subrc EQ 0.
        APPEND ls_msg TO et_message.

        " If requested, convert to BAPIRET2

        IF et_bapiret2 IS REQUESTED.
          APPEND INITIAL LINE TO et_bapiret2 ASSIGNING <ls_bapiret2>.

          CALL FUNCTION 'BALW_BAPIRETURN_GET2'
            EXPORTING
              type       = ls_msg-msgty
              cl         = ls_msg-msgid
              number     = ls_msg-msgno
              par1       = ls_msg-msgv1
              par2       = ls_msg-msgv2
              par3       = ls_msg-msgv3
              par4       = ls_msg-msgv4
              log_no     = mv_log_number
              log_msg_no = <ls_msgh>-msgnumber
            IMPORTING
              return     = <ls_bapiret2>.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.                    "get_messages

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->GET_MSG_COUNTS
* +-------------------------------------------------------------------------------------------------+
* | [<---] EV_MSG_CNT_A                   TYPE        I
* | [<---] EV_MSG_CNT_E                   TYPE        I
* | [<---] EV_MSG_CNT_W                   TYPE        I
* | [<---] EV_MSG_CNT_I                   TYPE        I
* | [<---] EV_MSG_CNT_S                   TYPE        I
* | [<---] EV_MSG_CNT_ALL                 TYPE        I
* | [!CX!] ZCX_APPL_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_msg_counts.

* Get message counts

    DATA ls_scnt TYPE bal_s_scnt.

    CALL FUNCTION 'BAL_LOG_HDR_READ'
      EXPORTING
        i_log_handle  = mv_log_handle
      IMPORTING
        e_statistics  = ls_scnt
      EXCEPTIONS
        log_not_found = 1
        OTHERS        = 2.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_appl_log
        EXPORTING
          textid = get_text_id( ).
    ENDIF.

    ev_msg_cnt_a   = ls_scnt-msg_cnt_a.
    ev_msg_cnt_e   = ls_scnt-msg_cnt_e.
    ev_msg_cnt_w   = ls_scnt-msg_cnt_w.
    ev_msg_cnt_i   = ls_scnt-msg_cnt_i.
    ev_msg_cnt_s   = ls_scnt-msg_cnt_s.
    ev_msg_cnt_all = ls_scnt-msg_cnt_al.

  ENDMETHOD.                    "get_msg_counts

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_APPL_LOG->GET_PROBLEM_CLASS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_PROBLEM_CLASS               TYPE        BAL_S_MSG-PROBCLASS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_problem_class.

    CASE ms_log_message-msgty.
      WHEN 'X'. "exit
        rv_problem_class = '1'. "very important
      WHEN 'A'. "abnormal end
        rv_problem_class = '1'. "very important
      WHEN 'E'. "error
        rv_problem_class = '2'. "important
      WHEN 'W'. "warning
        rv_problem_class = '3'. "medium
      WHEN 'I'. "information
        rv_problem_class = '4'. "additional info
      WHEN 'S'. "success
        rv_problem_class = '4'. "additional info
      WHEN OTHERS.
        rv_problem_class = ' '. "other
    ENDCASE.

  ENDMETHOD.                    "get_problem_class

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_APPL_LOG->GET_TEXT_ID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_TEXT_ID                     TYPE        SCX_T100KEY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_text_id.

    CLEAR rs_text_id.
    rs_text_id-msgid = sy-msgid.
    rs_text_id-msgno = sy-msgno.
    rs_text_id-attr1 = sy-msgv1.
    rs_text_id-attr2 = sy-msgv2.
    rs_text_id-attr3 = sy-msgv3.
    rs_text_id-attr4 = sy-msgv4.

  ENDMETHOD.                    "get_text_id

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->HAS_ERROR
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_HAS_ERROR                   TYPE        BOOLEAN
* | [!CX!] ZCX_APPL_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD has_error.

* Check if log has error messages

    DATA ls_scnt TYPE bal_s_scnt.

    CALL FUNCTION 'BAL_LOG_HDR_READ'
      EXPORTING
        i_log_handle  = mv_log_handle
      IMPORTING
        e_statistics  = ls_scnt
      EXCEPTIONS
        log_not_found = 1
        OTHERS        = 2.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_appl_log
        EXPORTING
          textid = get_text_id( ).
    ENDIF.

    IF ls_scnt-msg_cnt_a GT 0 OR ls_scnt-msg_cnt_e GT 0.
      rv_has_error = abap_true.
    ELSE.
      rv_has_error = abap_false.
    ENDIF.

  ENDMETHOD.                    "has_error

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->INC_DETLEVEL
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD inc_detlevel.

* Increment detail level

    IF mv_log_detlevel LT 9.
      mv_log_detlevel = mv_log_detlevel + 1.
    ENDIF.

  ENDMETHOD.                    "set_detlevel

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->IS_EMPTY
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_IS_EMPTY                    TYPE        BOOLEAN
* | [!CX!] ZCX_APPL_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_empty.

* Check if log is empty (by checking the total number of messages)

    DATA ls_scnt TYPE bal_s_scnt.

    CALL FUNCTION 'BAL_LOG_HDR_READ'
      EXPORTING
        i_log_handle  = mv_log_handle
      IMPORTING
        e_statistics  = ls_scnt
      EXCEPTIONS
        log_not_found = 1
        OTHERS        = 2.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_appl_log
        EXPORTING
          textid = get_text_id( ).
    ENDIF.

    IF ls_scnt-msg_cnt_al EQ 0.
      rv_is_empty = abap_true.
    ELSE.
      rv_is_empty = abap_false.
    ENDIF.

  ENDMETHOD.                    "is_empty

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->READ_FROM_DB
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] ZCX_APPL_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_from_db.

* Read log from database
* <not yet implemented>

  ENDMETHOD.                    "read_from_db

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_APPL_LOG->SAVE_TO_DB
* +-------------------------------------------------------------------------------------------------+
* | [<---] EV_LOG_HANDLE                  TYPE        BALLOGHNDL
* | [<---] EV_LOG_NUMBER                  TYPE        BALOGNR
* | [<---] EV_EXT_NUMBER                  TYPE        BALNREXT
* | [!CX!] ZCX_APPL_LOG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_to_db.

* Save log to database

    DATA:
      lt_log_handle TYPE bal_t_logh,
      lt_log_number TYPE bal_t_lgnm.

    FIELD-SYMBOLS:
      <ls_log_number> TYPE bal_s_lgnm.

    INSERT mv_log_handle INTO TABLE lt_log_handle.

    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_in_update_task = abap_false
        i_save_all       = abap_true
        i_t_log_handle   = lt_log_handle
      IMPORTING
        e_new_lognumbers = lt_log_number
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_appl_log
        EXPORTING
          textid = get_text_id( ).
    ENDIF.

    LOOP AT lt_log_number ASSIGNING <ls_log_number>.
      mv_log_number = <ls_log_number>-lognumber.
      ev_log_handle = <ls_log_number>-log_handle.
      ev_log_number = <ls_log_number>-lognumber.
      ev_ext_number = <ls_log_number>-extnumber.
      EXIT. "loop
    ENDLOOP.

* Also save log to index db

    "EXPORT <data> TO DATABASE bal_indx(al) ID mv_log_number.

  ENDMETHOD.                    "save_to_db
  
ENDCLASS.
