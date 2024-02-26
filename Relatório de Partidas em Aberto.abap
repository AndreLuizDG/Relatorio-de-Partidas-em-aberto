REPORT z_algj_40.

* Declara##es
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

CONSTANTS:
  c_x                     TYPE char1         VALUE 'X',
  c_s                     TYPE char1         VALUE 'S',
  c_e                     TYPE char1         VALUE 'E',
  c_separador1            TYPE char1         VALUE '/',
  c_separador2            TYPE char1         VALUE ':',
  c_separador3            TYPE char1         VALUE ';',
  c_dr                    TYPE char2         VALUE 'DR',
  c_kr                    TYPE char2         VALUE 'KR',
  c_buk                   TYPE char3         VALUE 'BUK',
  c_bln                   TYPE char3         VALUE 'BLN',
  c_gjr                   TYPE char3         VALUE 'GJR',
  c_txt                   TYPE char3         VALUE 'TXT',
  c_csv                   TYPE char3         VALUE 'CSV',
  c_asc                   TYPE char1         VALUE 'ASC',
  c_ano                   TYPE char3         VALUE 'Ano',
  c_3000                  TYPE char4         VALUE '3000',
  c_2008                  TYPE char4         VALUE '2008',
  c_fb03                  TYPE char4         VALUE 'FB03',
  c_mark                  TYPE char4         VALUE 'MARK',
  c_bsid                  TYPE char4         VALUE 'BSID',
  c_bsik                  TYPE char4         VALUE 'BSIK',
  c_bukrs                 TYPE char5         VALUE 'BUKRS',
  c_lifnr                 TYPE char5         VALUE 'LIFNR',
  c_gjahr                 TYPE char5         VALUE 'GJAHR',
  c_belnr                 TYPE char5         VALUE 'BELNR',
  c_buzei                 TYPE char5         VALUE 'BUZEI',
  c_blart                 TYPE char5         VALUE 'BLART',
  c_budat                 TYPE char5         VALUE 'BUDAT',
  c_waers                 TYPE char5         VALUE 'WAERS',
  c_monat                 TYPE char5         VALUE 'MONAT',
  c_bschl                 TYPE char5         VALUE 'BSCHL',
  c_dmbtr                 TYPE char5         VALUE 'DMBTR',
  c_kunnr                 TYPE char5         VALUE 'KUNNR',
  c_cliente               TYPE char7         VALUE 'cliente',
  c_empresa               TYPE char7         VALUE 'Empresa',
  c_moeda                 TYPE char5         VALUE 'Moeda',
  c_ti_saida              TYPE char8         VALUE 'TI_SAIDA',
  c_montante              TYPE char8         VALUE 'Montante',
  c_n_linha               TYPE char8         VALUE 'N° Linha',
  c_fornecedor            TYPE char10        VALUE 'Fornecedor',
  c_n_documento           TYPE char12        VALUE 'N° documento',
  c_gui_status_38         TYPE char13        VALUE 'GUI_STATUS_38',
  c_mes_do_exercicio      TYPE char16        VALUE 'Mês do exercício',
  c_tipo_de_documento     TYPE char17        VALUE 'Tipo de Documento',
  c_data_de_lancamento    TYPE char18        VALUE 'Data de lançamento',
  c_chave_de_lancamento   TYPE char19        VALUE 'Chave de Lançamento',
  c_partidas_clientes     TYPE char30        VALUE 'Partidas em Aberto de Clientes',
  c_partidas_fornecedores TYPE char34        VALUE 'Partidas em Aberto de Fornecedores',
  c_path_txt_clientes     TYPE char64        VALUE 'C:\Users\André LGJ\Desktop\Partidas de Clientes.TXT',
  c_path_csv_clientes     TYPE char64        VALUE 'C:\Users\André LGJ\Desktop\Partidas de Clientes.CSV',
  c_path_txt_fornecedores TYPE char64        VALUE 'C:\Users\André LGJ\Desktop\Partidas de Fornecedores.TXT',
  c_path_csv_fornecedores TYPE char64        VALUE 'C:\Users\André LGJ\Desktop\Partidas de Fornecedores.CSV',
  c_z_user_command        TYPE slis_formname VALUE 'Z_USER_COMMAND',
  c_zf_top_of_page        TYPE slis_formname VALUE 'ZF_TOP_OF_PAGE',
  c_zf_status             TYPE slis_formname VALUE 'ZF_STATUS'.

* Tela

SELECTION-SCREEN:       BEGIN OF BLOCK b1 WITH FRAME TITLE text-001. "Tela de seleção
PARAMETERS     p_bukrs TYPE bkpf-bukrs DEFAULT c_3000. "Empresa
SELECT-OPTIONS s_belnr FOR  bkpf-belnr.                "N. Documento
PARAMETERS:    p_gjahr TYPE bkpf-gjahr DEFAULT c_2008, "Ano
               p_kunnr RADIOBUTTON GROUP b1,           "Cliente
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
        IF wa_bkpf-blart <> c_dr.
          DELETE ti_bkpf INDEX sy-tabix.
        ENDIF.
      ENDLOOP.

    ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado

      LOOP AT ti_bkpf INTO wa_bkpf.
        IF wa_bkpf-blart <> c_kr.
          DELETE ti_bkpf INDEX sy-tabix.
        ENDIF.
      ENDLOOP.

    ENDIF.

  ELSE.

    FREE ti_bkpf.
    MESSAGE text-e01 TYPE c_s DISPLAY LIKE c_e. "Dados não encontrados!
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
      MESSAGE text-e01 TYPE c_s DISPLAY LIKE c_e. "Dados não encontrados!
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
      MESSAGE text-e01 TYPE c_s DISPLAY LIKE c_e. "Dados não encontrados!
      LEAVE LIST-PROCESSING.

    ENDIF. "   IF sy-subrc <> 0.

  ENDIF. "Valida##o de cliente ou fornecedor

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
       c_bukrs   c_ti_saida   c_bukrs   c_bsid   ''   ''    '',
       c_kunnr   c_ti_saida   c_kunnr   c_bsid   ''   ''    '',
       c_gjahr   c_ti_saida   c_gjahr   c_bsid   ''   ''    '',
       c_belnr   c_ti_saida   c_belnr   c_bsid   ''   ''    '',
       c_buzei   c_ti_saida   c_buzei   c_bsid   ''   ''    '',
       c_blart   c_ti_saida   c_blart   c_bsid   ''   ''    '',
       c_budat   c_ti_saida   c_budat   c_bsid   ''   ''    '',
       c_waers   c_ti_saida   c_waers   c_bsid   ''   ''    c_x,
       c_monat   c_ti_saida   c_monat   c_bsid   ''   ''    c_x,
       c_bschl   c_ti_saida   c_bschl   c_bsid   ''   ''    c_x,
       c_dmbtr   c_ti_saida   c_dmbtr   c_bsid   ''   c_x   ''.

  ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado

    PERFORM zf_monta_fieldcat USING:
       c_bukrs   c_ti_saida   c_bukrs   c_bsik   ''   ''    '',
       c_lifnr   c_ti_saida   c_lifnr   c_bsik   ''   ''    '',
       c_gjahr   c_ti_saida   c_gjahr   c_bsik   ''   ''    '',
       c_belnr   c_ti_saida   c_belnr   c_bsik   ''   ''    '',
       c_buzei   c_ti_saida   c_buzei   c_bsik   ''   ''    '',
       c_blart   c_ti_saida   c_blart   c_bsik   ''   ''    '',
       c_budat   c_ti_saida   c_budat   c_bsik   ''   ''    '',
       c_waers   c_ti_saida   c_waers   c_bsik   ''   ''    c_x,
       c_monat   c_ti_saida   c_monat   c_bsik   ''   ''    c_x,
       c_bschl   c_ti_saida   c_bschl   c_bsik   ''   ''    c_x,
       c_dmbtr   c_ti_saida   c_dmbtr   c_bsik   ''   c_x   ''.

  ENDIF.

ENDFORM.

FORM zf_sort_subtotal.

  FREE ti_sort.
  CLEAR   wa_sort.
  wa_sort-spos      = 1.
  wa_sort-fieldname = c_bukrs.
  wa_sort-tabname   = c_ti_saida.
  wa_sort-up        = c_x.
  wa_sort-subtot    = c_x.
  APPEND wa_sort TO ti_sort.

  CLEAR   wa_sort.
  wa_sort-spos      = 2.

  IF p_kunnr IS NOT INITIAL.
    wa_sort-fieldname = c_kunnr.
  ELSEIF p_lifnr IS NOT INITIAL.
    wa_sort-fieldname = c_lifnr.
  ENDIF.
  wa_sort-tabname   = c_ti_saida.
  wa_sort-up        = c_x.
  wa_sort-subtot    = c_x.
  APPEND wa_sort TO ti_sort.

ENDFORM.

FORM zf_exibe_alv.

  DATA: wa_layout TYPE slis_layout_alv.

  wa_layout-box_fieldname     = c_mark.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = c_zf_status
      i_callback_user_command  = c_z_user_command
      i_callback_top_of_page   = c_zf_top_of_page
      is_layout                = wa_layout
      it_fieldcat              = ti_fieldcat
      it_sort                  = ti_sort
    TABLES
      t_outtab                 = ti_saida
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
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
              sy-datum+4(2)
              sy-datum+0(4)
             INTO  data SEPARATED BY c_separador1.

  CONCATENATE sy-uzeit+0(2)
              sy-uzeit+2(2)
             INTO hora SEPARATED BY c_separador2.

  CONCATENATE data hora INTO timestamp SEPARATED BY space.

  IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado

    CLEAR wa_listheader.
    wa_listheader-typ  = c_s.
    wa_listheader-info = c_partidas_clientes.
    APPEND wa_listheader TO ti_listheader.
    FREE wa_listheader.

  ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado

    CLEAR wa_listheader.
    wa_listheader-typ  = c_s.
    wa_listheader-info = c_partidas_fornecedores.
    APPEND wa_listheader TO ti_listheader.
    FREE wa_listheader.

  ENDIF.

  CLEAR wa_listheader.
  CLEAR wa_listheader.
  wa_listheader-typ  = c_s.
  wa_listheader-info = timestamp.
  APPEND wa_listheader TO ti_listheader.
  FREE wa_listheader.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = ti_listheader.


ENDFORM.

FORM z_user_command USING vl_ucomm LIKE sy-ucomm
                  rs_selfield TYPE slis_selfield.

  rs_selfield-refresh = c_x.

  CASE vl_ucomm.

    WHEN c_csv.

      PERFORM zf_montar_csv.

    WHEN c_txt.

      PERFORM zf_montar_txt.

    WHEN OTHERS.

      IF rs_selfield-fieldname = c_belnr.
        SET PARAMETER ID c_buk  FIELD wa_saida-bukrs.
        SET PARAMETER ID c_bln  FIELD wa_saida-belnr.
        SET PARAMETER ID c_gjr  FIELD wa_saida-gjahr.
        CALL TRANSACTION c_fb03 AND SKIP FIRST SCREEN.
      ENDIF.
  ENDCASE.

ENDFORM.

FORM zf_status USING pf_tab TYPE slis_t_extab.
  SET PF-STATUS c_gui_status_38.
ENDFORM.

FORM zf_montar_csv.

  DATA: ti_saida_csv TYPE TABLE OF string,
        wa_saida_csv TYPE string,
        lv_dmbtr     TYPE string,
        lv_caminho   TYPE string.


  IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado

    CLEAR wa_saida_csv.
    CONCATENATE  c_empresa
                 c_cliente
                 c_ano
                 c_n_documento
                 c_n_linha
                 c_tipo_de_documento
                 c_data_de_lancamento
                 c_moeda
                 c_mes_do_exercicio
                 c_chave_de_lancamento
                 c_montante
    INTO wa_saida_csv
    SEPARATED BY c_separador3.

    APPEND wa_saida_csv TO ti_saida_csv.

    LOOP AT ti_saida INTO wa_saida WHERE mark = c_x.

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
      SEPARATED BY c_separador3.

      APPEND wa_saida_csv TO ti_saida_csv.

    ENDLOOP.


  ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado

    CLEAR wa_saida_csv.
    CONCATENATE  c_empresa
                 c_fornecedor
                 c_ano
                 c_n_documento
                 c_n_linha
                 c_tipo_de_documento
                 c_data_de_lancamento
                 c_moeda
                 c_mes_do_exercicio
                 c_chave_de_lancamento
                 c_montante
    INTO wa_saida_csv
    SEPARATED BY c_separador3.

    APPEND wa_saida_csv TO ti_saida_csv.

    LOOP AT ti_saida INTO wa_saida WHERE mark = c_x.

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
      SEPARATED BY c_separador3.

      APPEND wa_saida_csv TO ti_saida_csv.

    ENDLOOP. "  LOOP AT ti_saida INTO wa_saida.


  ENDIF.   "IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado

  IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado
    lv_caminho = c_path_csv_clientes.
  ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado
    lv_caminho = c_path_csv_fornecedores.
  ENDIF.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = lv_caminho
      filetype                = c_asc
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
    MESSAGE text-e02 TYPE c_s DISPLAY LIKE c_e. "Erro ao salvar o arquivo!
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.

FORM zf_montar_txt.

  DATA: ti_saida_aux TYPE TABLE OF type_saida,
        lv_caminho   TYPE string.

  ti_saida_aux = ti_saida.

  DELETE ti_saida_aux WHERE mark <> c_x.

  IF p_kunnr IS NOT INITIAL. "Caso o radiobutton Cliente estiver marcado
    lv_caminho = c_path_txt_clientes.
  ELSEIF p_lifnr IS NOT INITIAL. "ou se o radiobutton Fornecedor estiver marcado
    lv_caminho = c_path_txt_fornecedores.
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
    MESSAGE text-e02 TYPE c_s DISPLAY LIKE c_e. "Erro ao salvar o arquivo!
  ENDIF.

ENDFORM.
