*&---------------------------------------------------------------------*
*& Report ZTANJU_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTANJU_TEST.

***Customer/Partner Know-How***

SELECT matnr , 'Dummy' as maktx , meins , mtart , matkl , 'DummyCalc' AS calcfield FROM mara
  INTO TABLE @DATA(lt_mara).

DATA lt_makt TYPE TABLE OF makt.

IF lt_mara[] IS NOT INITIAL.

SELECT * FROM makt
  INTO TABLE lt_makt
  FOR ALL ENTRIES IN lt_mara
  WHERE matnr = lt_mara-matnr
    AND spras = sy-langu.
ENDIF.

*Some Calculation

LOOP AT lt_mara ASSIGNING FIELD-SYMBOL(<ls_mara>).
  CASE <ls_mara>-mtart.
    WHEN 'HAWA'.
      <ls_mara>-calcfield = 'Foo'.
    WHEN OTHERS.
      <ls_mara>-calcfield = 'Bar'.
  ENDCASe.

  READ TABLE lt_makt WITH KEY matnr = <ls_mara>-matnr
    ASSIGNING FIELD-SYMBOL(<ls_makt>).
  IF sy-subrc = 0.
    <ls_mara>-maktx = <ls_makt>-maktx.
  ENDIF.
ENDLOOP.

***Customer/Partner Know-How Bitir***

* On-Prem ABAP Specific Stuff -> Display in ALV etc.

cl_salv_table=>factory(
  IMPORTING
    r_salv_table   = DATA(lo_salv)                        " Basis Class Simple ALV Tables
  CHANGING
    t_table        = lt_mara
).

lo_salv->display( ).
