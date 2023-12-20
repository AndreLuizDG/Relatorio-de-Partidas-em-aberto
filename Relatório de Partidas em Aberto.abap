REPORT z_algj_40.

* Declara��es
TABLES: bkpf.

TYPES:

  BEGIN OF type_bkpf,
    bukrs TYPE bkpf-bukrs,
    belnr TYPE bkpf-belnr,
    gjahr TYPE bkpf-gjahr,
    blart TYPE bkpf-blart,
  END OF type_bkpf,

  BEGIN OF type_bseg,
    bukrs TYPE bseg-bukrs,
    belnr TYPE bseg-belnr,
    gjahr TYPE bseg-gjahr,
    buzei TYPE bseg-buzei,
    kunnr TYPE bseg-kunnr,
    lifnr TYPE bseg-lifnr,
  END OF type_bseg,

  BEGIN OF type_bsid,
    bukrs TYPE bsid-bukrs,
    kunnr TYPE bsid-kunnr,
    gjahr TYPE bsid-gjahr,
    belnr TYPE bsid-belnr,
    buzei TYPE bsid-buzei,
    budat TYPE bsid-budat,
    waers TYPE bsid-waers,
    blart TYPE bsid-blart,
    monat TYPE bsid-monat,
    bschl TYPE bsid-bschl,
    dmbtr TYPE bsid-dmbtr,
  END OF type_bsid,

  BEGIN OF type_bsik,
    bukrs TYPE bsik-bukrs,
    lifnr TYPE bsik-lifnr,
    gjahr TYPE bsik-gjahr,
    belnr TYPE bsik-belnr,
    buzei TYPE bsik-buzei,
    budat TYPE bsik-budat,
    waers TYPE bsik-waers,
    blart TYPE bsik-blart,
    monat TYPE bsik-monat,
    bschl TYPE bsik-bschl,
    dmbtr TYPE bsik-dmbtr,
    mark  TYPE flag,
  END OF type_bsik,

  BEGIN OF type_saida,
    bukrs TYPE bsid-bukrs,
    kunnr TYPE bsid-kunnr,
    lifnr TYPE bsik-lifnr,
    gjahr TYPE bsid-gjahr,
    belnr TYPE bsid-belnr,
    buzei TYPE bsid-buzei,
    blart TYPE bsid-blart,
    budat TYPE bsid-budat,
    waers TYPE bsid-waers,
    monat TYPE bsid-monat,
    bschl TYPE bsid-bschl,
    dmbtr TYPE bsid-dmbtr,
    mark  TYPE flag,
  END OF type_saida.

DATA:
  ti_bkpf       TYPE TABLE OF type_bkpf,
  ti_bseg       TYPE TABLE OF type_bseg,
  ti_bsid       TYPE TABLE OF type_bsid,
  ti_bsik       TYPE TABLE OF type_bsik,
  ti_saida      TYPE TABLE OF type_saida,
  ti_fieldcat   TYPE TABLE OF slis_fieldcat_alv,
  ti_sort       TYPE TABLE OF slis_sortinfo_alv,
  ti_listheader TYPE TABLE OF slis_listheader.

DATA:
  wa_bkpf       TYPE type_bkpf,
  wa_bseg       TYPE type_bseg,
  wa_bsid       TYPE type_bsid,
  wa_bsik       TYPE type_bsik,
  wa_saida      TYPE type_saida,
  wa_fieldcat   TYPE slis_fieldcat_alv,
  wa_sort       TYPE slis_sortinfo_alv,
  wa_listheader TYPE slis_listheader.

* Tela

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE text-001. "Tela de sele��o
PARAMETERS     p_bukrs TYPE bkpf-bukrs DEFAULT '3000'. "Empresa
SELECT-OPTIONS s_belnr FOR  bkpf-belnr.                 "N. Documento
PARAMETERS:    p_gjahr TYPE bkpf-gjahr DEFAULT '2008', "Ano
               p_kunnr RADIOBUTTON GROUP b1,              "Cliente
               p_lifnr RADIOBUTTON GROUP b1.           "Fornecedor
SELECTION-SCREEN: END OF BLOCK b1.

* Eventos

START-OF-SELECTION.

  PERFORM: zf_seleciona_dados.

END-OF-SELECTION.

  PERFORM: zf_processa_dados,
           zf_monta_alv,
           zf_sort_subtotal,
           zf_exibe_alv.

* Forms

FORM zf_seleciona_dados.

  FREE ti_bkpf.
  SELECT bukrs
         belnr
         gjahr
         blart
    FROM bkpf
    INTO TABLE ti_bkpf
   WHERE bukrs =  p_bukrs
     AND belnr IN s_belnr
     AND gjahr =  p_gjahr.

  IF sy-subrc = 0.

    IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado

      LOOP AT ti_bkpf INTO wa_bkpf.
        IF wa_bkpf-blart <> 'DR'.
          DELETE ti_bkpf INDEX sy-tabix.
        ENDIF.
      ENDLOOP.

    ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado

      LOOP AT ti_bkpf INTO wa_bkpf.
        IF wa_bkpf-blart <> 'KR'.
          DELETE ti_bkpf INDEX sy-tabix.
        ENDIF.
      ENDLOOP.

    ENDIF.

  ELSE.

    FREE ti_bkpf.
    MESSAGE 'Dados n�o encontrados' TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.

  ENDIF. "  IF sy-subrc = 0.


  FREE ti_bseg.
  SELECT bukrs
         belnr
         gjahr
         buzei
         kunnr
         lifnr
    FROM bseg
    INTO TABLE ti_bseg
     FOR ALL ENTRIES IN ti_bkpf
   WHERE bukrs = ti_bkpf-bukrs
     AND belnr = ti_bkpf-belnr
     AND gjahr = ti_bkpf-gjahr.

  IF sy-subrc <> 0.
    FREE ti_bseg.
  ENDIF.

  IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado

    FREE ti_bsid.
    SELECT bukrs
           kunnr
           gjahr
           belnr
           buzei
           budat
           waers
           blart
           monat
           bschl
           dmbtr
      FROM bsid
      INTO TABLE ti_bsid
       FOR ALL ENTRIES IN ti_bseg
     WHERE bukrs = ti_bseg-bukrs
       AND kunnr = ti_bseg-kunnr
       AND gjahr = ti_bseg-gjahr
       AND belnr = ti_bseg-belnr
       AND buzei = ti_bseg-buzei.

    IF sy-subrc <> 0.

      FREE ti_bsid.
      MESSAGE 'Dados n�o encontrados' TYPE 'S' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.

    ENDIF. "    IF sy-subrc <> 0.

  ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado

    FREE ti_bsik.
    SELECT bukrs
           lifnr
           gjahr
           belnr
           buzei
           budat
           waers
           blart
           monat
           bschl
           dmbtr
      FROM bsik
      INTO TABLE ti_bsik
       FOR ALL ENTRIES IN ti_bseg
     WHERE bukrs = ti_bseg-bukrs
       AND lifnr = ti_bseg-lifnr
       AND gjahr = ti_bseg-gjahr
       AND belnr = ti_bseg-belnr
       AND buzei = ti_bseg-buzei.

    IF sy-subrc <> 0.

      FREE ti_bsik.
      MESSAGE 'Dados n�o encontrados' TYPE 'S' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.

    ENDIF. "   IF sy-subrc <> 0.

  ENDIF. "Valida��o de cliente ou fornecedor

ENDFORM.

FORM zf_processa_dados.

  SORT: ti_bkpf BY bukrs
                   belnr,
        ti_bsid BY bukrs
                   kunnr
                   gjahr
                   belnr
                   buzei,
        ti_bsik BY bukrs
                   lifnr
                   gjahr
                   belnr
                   buzei.


  LOOP AT ti_bseg INTO wa_bseg.


    READ TABLE ti_bkpf INTO wa_bkpf WITH KEY
                                    bukrs = wa_bseg-bukrs
                                    belnr = wa_bseg-belnr BINARY SEARCH.


    IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado

      READ TABLE ti_bsid INTO wa_bsid WITH KEY
                                      bukrs = wa_bseg-bukrs
                                      kunnr = wa_bseg-kunnr
                                      gjahr = wa_bseg-gjahr
                                      belnr = wa_bseg-belnr
                                      buzei = wa_bseg-buzei BINARY SEARCH.
      IF sy-subrc = 0.
*     Preenchendo a tabela de saida.
        wa_saida-bukrs      = wa_bsid-bukrs.
        wa_saida-kunnr      = wa_bsid-kunnr.
        wa_saida-gjahr      = wa_bsid-gjahr.
        wa_saida-belnr      = wa_bsid-belnr.
        wa_saida-buzei      = wa_bsid-buzei.
        wa_saida-blart      = wa_bsid-blart.
        wa_saida-budat      = wa_bsid-budat.
        wa_saida-waers      = wa_bsid-waers.
        wa_saida-monat      = wa_bsid-monat.
        wa_saida-bschl      = wa_bsid-bschl.
        wa_saida-dmbtr      = wa_bsid-dmbtr.
        APPEND wa_saida TO ti_saida.
        CLEAR  wa_saida.

      ELSE.
        CONTINUE.
      ENDIF.
    ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado

      READ TABLE ti_bsik INTO wa_bsik WITH KEY
                                      bukrs = wa_bseg-bukrs
                                      lifnr = wa_bseg-lifnr
                                      gjahr = wa_bseg-gjahr
                                      belnr = wa_bseg-belnr
                                      buzei = wa_bseg-buzei BINARY SEARCH.
      IF sy-subrc = 0.
        wa_saida-bukrs      = wa_bsik-bukrs.
        wa_saida-lifnr      = wa_bsik-lifnr.
        wa_saida-gjahr      = wa_bsik-gjahr.
        wa_saida-belnr      = wa_bsik-belnr.
        wa_saida-buzei      = wa_bsik-buzei.
        wa_saida-blart      = wa_bsik-blart.
        wa_saida-budat      = wa_bsik-budat.
        wa_saida-waers      = wa_bsik-waers.
        wa_saida-monat      = wa_bsik-monat.
        wa_saida-bschl      = wa_bsik-bschl.
        wa_saida-dmbtr      = wa_bsik-dmbtr.
        APPEND wa_saida TO ti_saida.
        CLEAR  wa_saida.
      ELSE.
        CONTINUE.
      ENDIF.


    ENDIF.
  ENDLOOP.

ENDFORM.

FORM zf_monta_fieldcat USING field      TYPE any
                              tab       TYPE any
                              ref_field TYPE any
                              ref_tab   TYPE any
                              hotspot   TYPE any
                              sum       TYPE any
                              no_out    TYPE any.

  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname     = field.
  wa_fieldcat-tabname       = tab.
  wa_fieldcat-ref_fieldname = ref_field.
  wa_fieldcat-ref_tabname   = ref_tab.
  wa_fieldcat-hotspot       = hotspot.
  wa_fieldcat-do_sum        = sum.
  wa_fieldcat-no_out        = no_out.

  APPEND wa_fieldcat TO ti_fieldcat.

ENDFORM.

FORM zf_monta_alv.

  IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado

    PERFORM zf_monta_fieldcat USING:
       'BUKRS'      'TI_SAIDA'  'BUKRS'      'BSID'  ''   ''   '',
       'KUNNR'      'TI_SAIDA'  'KUNNR'      'BSID'  ''   ''   '',
       'GJAHR'      'TI_SAIDA'  'GJAHR'      'BSID'  ''   ''   '',
       'BELNR'      'TI_SAIDA'  'BELNR'      'BSID'  ''   ''   '',
       'BUZEI'      'TI_SAIDA'  'BUZEI'      'BSID'  ''   ''   '',
       'BLART'      'TI_SAIDA'  'BLART'      'BSID'  ''   ''   '',
       'BUDAT'      'TI_SAIDA'  'BUDAT'      'BSID'  ''   ''   '',
       'WAERS'      'TI_SAIDA'  'WAERS'      'BSID'  ''   ''   'X',
       'MONAT'      'TI_SAIDA'  'MONAT'      'BSID'  ''   ''   'X',
       'BSCHL'      'TI_SAIDA'  'BSCHL'      'BSID'  ''   ''   'X',
       'DMBTR'      'TI_SAIDA'  'DMBTR'      'BSID'  ''   'X'  ''.

  ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado

    PERFORM zf_monta_fieldcat USING:
       'BUKRS'       'TI_SAIDA'  'BUKRS'     'BSIK'  ''   ''   '',
       'LIFNR'      'TI_SAIDA'  'LIFNR'      'BSIK'  ''   ''   '',
       'GJAHR'      'TI_SAIDA'  'GJAHR'      'BSIK'  ''   ''   '',
       'BELNR'      'TI_SAIDA'  'BELNR'      'BSIK'  ''   ''   '',
       'BUZEI'      'TI_SAIDA'  'BUZEI'      'BSIK'  ''   ''   '',
       'BLART'      'TI_SAIDA'  'BLART'      'BSIK'  ''   ''   '',
       'BUDAT'      'TI_SAIDA'  'BUDAT'      'BSIK'  ''   ''   '',
       'WAERS'      'TI_SAIDA'  'WAERS'      'BSIK'  ''   ''   'X',
       'MONAT'      'TI_SAIDA'  'MONAT'      'BSIK'  ''   ''   'X',
       'BSCHL'      'TI_SAIDA'  'BSCHL'      'BSIK'  ''   ''   'X',
       'DMBTR'      'TI_SAIDA'  'DMBTR'      'BSIK'  ''   'X'  ''.

  ENDIF.

ENDFORM.

FORM zf_sort_subtotal.

  FREE ti_sort.
  CLEAR   wa_sort.
  wa_sort-spos      = 1.       "Pos�c�o na ordena��o
  wa_sort-fieldname = 'BUKRS'. "Campo a ser ordenado
  wa_sort-tabname   = 'TI_SAIDA'. "Tabela interna do alv
  wa_sort-up        = 'X'.     "Ordena��o crescente
  wa_sort-subtot    = 'X'.     "Exibir subtotais
  APPEND wa_sort TO ti_sort.

  CLEAR   wa_sort.
  wa_sort-spos      = 2.       "Pos�c�o na ordena��o

  IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado
    wa_sort-fieldname = 'KUNNR'. "Campo a ser ordenado
  ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado
    wa_sort-fieldname = 'LIFNR'. "Campo a ser ordenado
  ENDIF.
  wa_sort-tabname   = 'TI_SAIDA'. "Tabela interna do alv
  wa_sort-up        = 'X'.     "Ordena��o crescente
  wa_sort-subtot    = 'X'.     "Exibir subtotais
  APPEND wa_sort TO ti_sort.

ENDFORM.

FORM zf_exibe_alv.

  DATA: wa_layout TYPE slis_layout_alv.

  wa_layout-box_fieldname     = 'MARK'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK        = ' '
*     I_BYPASSING_BUFFER       = ' '
*     I_BUFFER_ACTIVE          = ' '
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'ZF_STATUS'
      i_callback_user_command  = 'Z_USER_COMMAND'
      i_callback_top_of_page   = 'ZF_TOP_OF_PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
*     I_BACKGROUND_ID          = ' '
*     I_GRID_TITLE             =
*     I_GRID_SETTINGS          =
      is_layout                = wa_layout
      it_fieldcat              = ti_fieldcat
*     IT_EXCLUDING             =
*     IT_SPECIAL_GROUPS        =
      it_sort                  = ti_sort
*     IT_FILTER                =
*     IS_SEL_HIDE              =
*     I_DEFAULT                = 'X'
*     I_SAVE                   = ' '
*     IS_VARIANT               =
*     IT_EVENTS                =
*     IT_EVENT_EXIT            =
*     IS_PRINT                 =
*     IS_REPREP_ID             =
*     I_SCREEN_START_COLUMN    = 0
*     I_SCREEN_START_LINE      = 0
*     I_SCREEN_END_COLUMN      = 0
*     I_SCREEN_END_LINE        = 0
*     I_HTML_HEIGHT_TOP        = 0
*     I_HTML_HEIGHT_END        = 0
*     IT_ALV_GRAPHICS          =
*     IT_HYPERLINK             =
*     IT_ADD_FIELDCAT          =
*     IT_EXCEPT_QINFO          =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab                 = ti_saida
* EXCEPTIONS
*     PROGRAM_ERROR            = 1
*     OTHERS                   = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.

FORM zf_top_of_page.

  DATA: data      TYPE char10,
        hora      TYPE char5,
        timestamp TYPE char20.

  FREE ti_listheader.

  CONCATENATE sy-datum+6(2)
              sy-datum+4(2)    "05/12/2023D
              sy-datum+0(4)
             INTO  data SEPARATED BY '/'.

  CONCATENATE sy-uzeit+0(2)
              sy-uzeit+2(2)
             INTO hora SEPARATED BY ':'.

  CONCATENATE data hora INTO timestamp SEPARATED BY space.

  IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado

    CLEAR wa_listheader.
    wa_listheader-typ  = 'S'.
    wa_listheader-info = 'Partidas em Aberto de Clientes'.
    APPEND wa_listheader TO ti_listheader.
    FREE wa_listheader.

  ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado

    CLEAR wa_listheader.
    wa_listheader-typ  = 'S'.
    wa_listheader-info = 'Partidas em Aberto de Fornecedores'.
    APPEND wa_listheader TO ti_listheader.
    FREE wa_listheader.

  ENDIF.

  CLEAR wa_listheader.
  CLEAR wa_listheader.
  wa_listheader-typ  = 'S'.
  wa_listheader-info = timestamp.
  APPEND wa_listheader TO ti_listheader.
  FREE wa_listheader.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = ti_listheader.


ENDFORM.

FORM z_user_command USING vl_ucomm LIKE sy-ucomm
                  rs_selfield TYPE slis_selfield.

  rs_selfield-refresh = 'X'.

  CASE vl_ucomm.

    WHEN 'CSV'.

      PERFORM zf_montar_csv.

    WHEN 'TXT'.

      PERFORM zf_montar_txt.

    WHEN OTHERS.

      IF rs_selfield-fieldname = 'BELNR'.
        SET PARAMETER ID 'BUK'  FIELD wa_saida-bukrs.
        SET PARAMETER ID 'BLN'  FIELD wa_saida-belnr.
        SET PARAMETER ID 'GJR'  FIELD wa_saida-gjahr.
        CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
      ENDIF.
  ENDCASE.

ENDFORM.

FORM zf_status USING pf_tab TYPE slis_t_extab.
  SET PF-STATUS 'GUI_STATUS_40'.
ENDFORM.

FORM zf_montar_csv.

  DATA: ti_saida_csv TYPE TABLE OF string,
        wa_saida_csv TYPE string,
        lv_dmbtr     TYPE string,
        lv_caminho   TYPE string.


  IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado

    CLEAR wa_saida_csv.
    CONCATENATE  'Empresa'
                 'Cliente'
                 'Ano'
                 'N� documento'
                 'N� Linha'
                 'Tipo de Documento'
                 'Data de lan�amento'
                 'Moeda'
                 'M�s do exerc�cio'
                 'Chave de Lan�amento'
                 'Montante'

    INTO wa_saida_csv
    SEPARATED BY ';'.

    APPEND wa_saida_csv TO ti_saida_csv.

    LOOP AT ti_saida INTO wa_saida WHERE mark = 'X'.

      lv_dmbtr = wa_saida-dmbtr.

      CLEAR wa_saida_csv.
      CONCATENATE  wa_saida-bukrs
                   wa_saida-kunnr
                   wa_saida-gjahr
                   wa_saida-belnr
                   wa_saida-buzei
                   wa_saida-blart
                   wa_saida-budat
                   wa_saida-waers
                   wa_saida-monat
                   wa_saida-bschl
                   lv_dmbtr

      INTO wa_saida_csv
      SEPARATED BY ';'.

      APPEND wa_saida_csv TO ti_saida_csv.

    ENDLOOP.


  ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado

    CLEAR wa_saida_csv.
    CONCATENATE  'Empresa'
                 'Fornecedor'
                 'Ano'
                 'N� documento'
                 'N� Linha'
                 'Tipo de Documento'
                 'Data de lan�amento'
                 'Moeda'
                 'M�s do exerc�cio'
                 'Chave de Lan�amento'
                 'Montante'

    INTO wa_saida_csv
    SEPARATED BY ';'.

    APPEND wa_saida_csv TO ti_saida_csv.

    LOOP AT ti_saida INTO wa_saida WHERE mark = 'X'.

      lv_dmbtr = wa_saida-dmbtr.

      CLEAR wa_saida_csv.
      CONCATENATE  wa_saida-bukrs
                   wa_saida-lifnr
                   wa_saida-gjahr
                   wa_saida-belnr
                   wa_saida-buzei
                   wa_saida-blart
                   wa_saida-budat
                   wa_saida-waers
                   wa_saida-monat
                   wa_saida-bschl
                   lv_dmbtr

      INTO wa_saida_csv
      SEPARATED BY ';'.

      APPEND wa_saida_csv TO ti_saida_csv.

    ENDLOOP. "  LOOP AT ti_saida INTO wa_saida.


  ENDIF.   "IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado

  IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado
    lv_caminho = 'C:\Users\Andr� LGJ\Desktop\Partidas de Clientes.CSV'.
  ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado
    lv_caminho = 'C:\Users\Andr� LGJ\Desktop\Partidas de Fornecedores.CSV'.
  ENDIF.


* Fun��o para baixar o CSV
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = lv_caminho
      filetype                = 'ASC'
    TABLES
      data_tab                = ti_saida_csv
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.

  IF sy-subrc <> 0.
    MESSAGE 'Erro ao salvar o arquivo!' TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.

FORM zf_montar_txt.

  DATA: ti_saida_aux TYPE TABLE OF type_saida,
        lv_caminho   TYPE string.

  ti_saida_aux = ti_saida.

  DELETE ti_saida_aux WHERE mark <> 'X'.

  IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado
    lv_caminho = 'C:\Users\Andr� LGJ\Desktop\Partidas de Clientes.TXT'.
  ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado
    lv_caminho = 'C:\Users\Andr� LGJ\Desktop\Partidas de Fornecedores.TXT'.
  ENDIF.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = lv_caminho
    TABLES
      data_tab                = ti_saida_aux
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc <> 0.
    MESSAGE 'Erro ao salvar o arquivo!' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
