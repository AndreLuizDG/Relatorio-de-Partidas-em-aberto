# SAP ABAP - Relatório de Partidas em Aberto

## Descrição
Este repositório contém um código em ABAP para um relatório SAP que exibe e processa partidas em aberto com base nos dados de documentos contábeis. O relatório oferece funcionalidades como seleção por empresa, número de documento, ano e distinção entre cliente ou fornecedor. Os resultados são apresentados em uma ALV (Advanced List Viewer) com a capacidade de exportar os dados para arquivos CSV ou TXT.

## Estrutura do Código
O código está organizado em módulos para facilitar a manutenção e compreensão:

- **zf_seleciona_dados:** Responsável por selecionar os dados com base nos critérios de seleção.
- **zf_processa_dados:** Realiza o processamento dos dados selecionados.
- **zf_monta_alv:** Monta a ALV para a exibição dos resultados.
- **zf_sort_subtotal:** Ordena e exibe subtotais na ALV.
- **zf_exibe_alv:** Exibe a ALV com os dados processados.
- **zf_top_of_page:** Configuração da parte superior da página na ALV.
- **z_user_command:** Trata os comandos do usuário na ALV.
- **zf_status:** Configuração do PF-STATUS para a ALV.
- **zf_montar_csv:** Gera um arquivo CSV a partir dos dados da ALV.
- **zf_montar_txt:** Gera um arquivo TXT a partir dos dados da ALV.

## Utilização
1. Execute o relatório no ambiente SAP.
2. Selecione os critérios desejados na tela de seleção.
3. Os resultados serão exibidos na ALV.
4. Opções de exportação estão disponíveis no menu da ALV (CSV, TXT).
5. O código é modular e pode ser adaptado conforme necessário.

## Exportação de Dados
- **CSV:** Os resultados podem ser exportados para um arquivo CSV, útil para análises externas.
- **TXT:** Os resultados também podem ser exportados para um arquivo TXT, seguindo um formato de texto.

## Autor
André Luiz G.J
andreluizguilhermini@gmail.com

## Contribuições

Contribuições são bem-vindas!

---

**Nota:** Este projeto é um exemplo fictício de um programa ABAP para fins educacionais.