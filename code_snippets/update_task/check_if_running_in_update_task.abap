*--------------------------------------------------------------------*
* Check if Running in Update Task
*--------------------------------------------------------------------*
* When the code is running in an Update Task, COMMIT / ROLLBACK is 
* not required otherwise it might be required.
*--------------------------------------------------------------------*

*--------------------------------------------------------------------*
* Alternative #1:
* Check if running in Update Task
*--------------------------------------------------------------------*
CASE cl_system_transaction_state=>get_in_update_task( ).
  WHEN 0. "not in update task
  WHEN 1. "    in update task
ENDCASE.

*--------------------------------------------------------------------*
* Alternative #2:
* Check if running in Update Task
*--------------------------------------------------------------------*
DATA l_in_update_task TYPE sy-subrc.

CALL FUNCTION 'TH_IN_UPDATE_TASK'
  IMPORTING
    in_update_task = l_in_update_task.

CASE l_in_update_task.
  WHEN 0. "not in update task
  WHEN 1. "    in update task
ENDCASE.
