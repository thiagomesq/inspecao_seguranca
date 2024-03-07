import 'dart:io';
import 'package:inspecao_seguranca/core/models/questao_campo.dart';
import 'package:inspecao_seguranca/core/models/questao_veiculo.dart';
import 'package:inspecao_seguranca/core/models/resposta_campo.dart';
import 'package:inspecao_seguranca/core/models/resposta_veiculo.dart';
import 'package:external_path/external_path.dart';
import 'package:inspecao_seguranca/core/models/veiculo.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:open_file/open_file.dart';

class Excel {
  Future<void> relatorioDiarioInspecoes(
    List<RespostaCampo> respostas,
    List<String> veiculos,
    List<QuestaoCampo> questoes,
  ) async {
    final Workbook workbook = Workbook(2);

    final Worksheet dados = workbook.worksheets[0];
    dados.name = 'Dados';
    Range range = dados.getRangeByIndex(1, 1);
    range.setText('Placas/Itens');
    int y = 2;
    for (String veiculo in veiculos) {
      Range range = dados.getRangeByIndex(y, 1);
      range.setText(veiculo);
      y++;
    }
    range.autoFit();
    int x = 2;
    for (QuestaoCampo questao in questoes) {
      y = 2;
      Hyperlink hyperlink = dados.hyperlinks.add(
        dados.getRangeByIndex(1, x),
        HyperlinkType.workbook,
        'Itens!A${questao.id}',
      );
      hyperlink.textToDisplay = '${questao.id}';
      for (String veiculo in veiculos) {
        RespostaCampo resposta = respostas.firstWhere(
          (e) => e.idQuestao == questao.id && e.empresa == veiculo,
          orElse: () => RespostaCampo(
            data: '',
            idQuestao: 0,
            localidade: '',
            questao: '',
            empresa: '',
          ),
        );
        Range range = dados.getRangeByIndex(y, x);
        ConditionalFormats conditions = range.conditionalFormats;
        ConditionalFormat condition = conditions.addCondition();
        condition.formatType = ExcelCFType.specificText;
        condition.operator = ExcelComparisonOperator.equal;
        condition.text = 'NC';
        condition.backColor = '#ff0000';
        condition.fontColor = '#ffffff';
        if (resposta.idQuestao == 0) {
          range.setText('NA');
        } else {
          range.setText(resposta.opcao! == '1' ? 'X' : 'NC');
        }
        range.autoFit();
        y++;
      }
      x++;
    }

    final Worksheet itens = workbook.worksheets[1];
    itens.name = 'Itens';
    for (QuestaoCampo questao in questoes) {
      Range range = itens.getRangeByIndex(questao.id, 1);
      range.setText('${questao.id} - ${questao.nome}');
      range.autoFit();
    }

    String dataRealizacao = respostas.first.data.replaceAll('/', '-');
    String name = 'relatorio_diario_de_inspecoes_$dataRealizacao.xlsx';
    String path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    File file = File('$path/$name');
    await file.writeAsBytes(workbook.saveAsStream());
    workbook.dispose();
    OpenFile.open('$path/$name');
  }

  Future<void> relatorioVeiculoNaoConformidade(
    List<QuestaoVeiculo> questoes,
    List<RespostaVeiculo> respostas,
    List<Veiculo> veiculos,
  ) async {
    final Workbook workbook = Workbook(veiculos.length);
    int i = 0;
    for (Veiculo v in veiculos) {
      Worksheet dados = workbook.worksheets[i];
      dados.name = v.placa!;
      dados.showGridlines = false;
      Range range = dados.getRangeByIndex(1, 1, 1, 2);
      range.columnWidth = 2;
      /* Título */
      range = dados.getRangeByIndex(2, 3, 2, 18);
      range.merge();
      Style rangeStyle = range.cellStyle;
      rangeStyle.bold = true;
      rangeStyle.fontName = 'Arial';
      rangeStyle.fontSize = 11;
      rangeStyle.hAlign = HAlignType.center;
      rangeStyle.vAlign = VAlignType.center;
      colocarbordarCompleta(rangeStyle);
      range.setText('INSPEÇÃO DE SEGURANÇA EM VEÍCULOS / EQUIPAMENTOS - TST');
      range.autoFit();
      range = dados.getRangeByIndex(3, 3, 3, 18);
      range.merge();
      range.autoFit();
      /* PONTOS VERIFICADOS */
      range = dados.getRangeByIndex(4, 3, 5, 6);
      range.merge();
      rangeStyle = range.cellStyle;
      rangeStyle.bold = true;
      rangeStyle.fontName = 'Arial';
      rangeStyle.fontSize = 11;
      rangeStyle.hAlign = HAlignType.center;
      rangeStyle.vAlign = VAlignType.center;
      colocarbordarCompleta(rangeStyle);
      range.setText('IDENTIFICAÇÃO DO VEÍCULO / EQUIPAMENTO');
      range.autoFit();
      //Ano de fabricação
      pontosVerificados(
        dados.getRangeByIndex(6, 3, 6, 5),
        dados.getRangeByIndex(6, 6),
        'ANO DE FABRICAÇÃO - VEÍCULO',
        '${v.ano}',
      );
      //Modelo
      pontosVerificados(
        dados.getRangeByIndex(7, 3, 7, 5),
        dados.getRangeByIndex(7, 6),
        'TIPO',
        v.tipo!,
      );
      //Placa
      pontosVerificados(
        dados.getRangeByIndex(8, 3, 8, 5),
        dados.getRangeByIndex(8, 6),
        'PLACA / OUTRA IDENTIFICAÇÃO',
        v.placa!,
      );
      //Motorista/Operador
      pontosVerificados(
        dados.getRangeByIndex(9, 3, 9, 5),
        dados.getRangeByIndex(9, 6),
        'NOME - MOTORISTA / OPERADOR',
        respostas.first.condutor,
      );
      //Validade da habilitação
      pontosVerificados(
        dados.getRangeByIndex(10, 3, 10, 5),
        dados.getRangeByIndex(10, 6),
        'VALIDADE DA HABILITAÇÃO',
        respostas.first.validadeHabilitacao,
      );
      //Propósito de uso
      pontosVerificados(
        dados.getRangeByIndex(11, 3, 11, 5),
        dados.getRangeByIndex(11, 6),
        'FINALIDADE DA UTILIZAÇÃO',
        v.finalidade!,
      );
      //IPVA
      pontosVerificados(
        dados.getRangeByIndex(12, 3, 12, 5),
        dados.getRangeByIndex(12, 6),
        'IPVA',
        v.finalidade!,
      );
      /* DATA E CONTRATANTE */
      range = dados.getRangeByIndex(4, 7, 4, 18);
      range.merge();
      rangeStyle = range.cellStyle;
      rangeStyle.bold = true;
      rangeStyle.hAlign = HAlignType.left;
      rangeStyle.vAlign = VAlignType.center;
      colocarbordarCompleta(rangeStyle);
      range.setText('DATA: ${respostas[0].data} EMPRESA: ${v.empresa}');
      range.autoFitColumns();
      /* LEGENDA */
      range = dados.getRangeByIndex(5, 7, 6, 16);
      range.merge();
      rangeStyle = range.cellStyle;
      rangeStyle.bold = true;
      rangeStyle.fontName = 'Arial';
      rangeStyle.fontSize = 11;
      rangeStyle.hAlign = HAlignType.center;
      rangeStyle.vAlign = VAlignType.center;
      colocarbordarCompleta(rangeStyle);
      range.setText('LEGENDA');
      range.autoFit();
      //Cumpre com
      legenda(
        dados.getRangeByIndex(7, 7),
        dados.getRangeByIndex(7, 8, 7, 16),
        '1',
        'Atende',
      );
      //Leve disconformidade
      legenda(
        dados.getRangeByIndex(8, 7),
        dados.getRangeByIndex(8, 8, 8, 16),
        '2',
        'Não Conformidade Leve',
      );
      //Não comprimento médio
      legenda(
        dados.getRangeByIndex(9, 7),
        dados.getRangeByIndex(9, 8, 9, 16),
        '3',
        'Não Conformidade Média',
      );
      //Não comprimento grave
      legenda(
        dados.getRangeByIndex(10, 7),
        dados.getRangeByIndex(10, 8, 10, 16),
        '4',
        'Não Conformidade Grave',
      );
      //Não se aplica
      legenda(
        dados.getRangeByIndex(11, 7),
        dados.getRangeByIndex(11, 8, 11, 16),
        '5',
        'Não se aplica ',
      );
      //Identificador de marcação
      range = dados.getRangeByIndex(12, 8, 12, 16);
      legenda(
        dados.getRangeByIndex(12, 7),
        range,
        'X',
        'X = identifica a condição do item',
      );
      rangeStyle = range.cellStyle;
      rangeStyle.borders.bottom.lineStyle = LineStyle.thin;
      rangeStyle.borders.bottom.color = '#000000';
      /* CRITÉRIO */
      range = dados.getRangeByIndex(5, 17, 7, 18);
      range.columnWidth = 20;
      range.merge();
      rangeStyle = range.cellStyle;
      rangeStyle.bold = true;
      rangeStyle.fontName = 'Arial';
      rangeStyle.fontSize = 11;
      rangeStyle.hAlign = HAlignType.center;
      rangeStyle.vAlign = VAlignType.center;
      rangeStyle.borders.right.lineStyle = LineStyle.thin;
      rangeStyle.borders.right.color = '#000000';
      range.setText('CRITÉRIOS');
      //NC leve
      criterio(
        dados.getRangeByIndex(8, 17, 8, 18),
        'NC Leve - programar solução para a NC. Não impede a continuidade do trabalho.',
      );
      //NC médio
      criterio(
        dados.getRangeByIndex(9, 17, 9, 18),
        'NC Média - Exige uma solução rápida porém,  pode-se continuar o trabalho com atenção.',
      );
      //NC médio
      criterio(
        dados.getRangeByIndex(10, 17, 10, 18),
        'NC Grave - A atividade deve ser paralizada imediatamente.',
      );
      range = dados.getRangeByIndex(11, 17, 11, 18);
      range.merge();
      rangeStyle = range.cellStyle;
      rangeStyle.borders.right.lineStyle = LineStyle.thin;
      rangeStyle.borders.right.color = '#000000';
      range = dados.getRangeByIndex(12, 17, 12, 18);
      range.merge();
      rangeStyle = range.cellStyle;
      rangeStyle.bold = true;
      rangeStyle.fontName = 'Arial';
      rangeStyle.fontSize = 11;
      rangeStyle.hAlign = HAlignType.center;
      rangeStyle.vAlign = VAlignType.center;
      rangeStyle.borders.right.lineStyle = LineStyle.thin;
      rangeStyle.borders.right.color = '#000000';
      rangeStyle.borders.bottom.lineStyle = LineStyle.thin;
      rangeStyle.borders.bottom.color = '#000000';
      range.setText('NC = Não Conformidade');
      range = dados.getRangeByIndex(13, 3, 13, 18);
      range.merge();
      /* Cabeçalho tabela */
      //Descrição perguntas
      range = dados.getRangeByIndex(14, 3, 14, 7);
      range.merge();
      rangeStyle = range.cellStyle;
      rangeStyle.bold = true;
      rangeStyle.fontName = 'Arial';
      rangeStyle.fontSize = 9;
      rangeStyle.hAlign = HAlignType.center;
      rangeStyle.vAlign = VAlignType.center;
      colocarbordarCompleta(rangeStyle);
      range.setText('DESCRIÇÃO DO ITEM AVALIADO');
      //Respostas
      range = dados.getRangeByIndex(14, 8);
      range.merge();
      rangeStyle = range.cellStyle;
      rangeStyle.bold = true;
      rangeStyle.hAlign = HAlignType.center;
      rangeStyle.vAlign = VAlignType.center;
      colocarbordarCompleta(rangeStyle);
      range.setText('1');
      range = dados.getRangeByIndex(14, 9);
      range.merge();
      rangeStyle = range.cellStyle;
      rangeStyle.bold = true;
      rangeStyle.hAlign = HAlignType.center;
      rangeStyle.vAlign = VAlignType.center;
      colocarbordarCompleta(rangeStyle);
      range.setText('2');
      range = dados.getRangeByIndex(14, 10);
      range.merge();
      rangeStyle = range.cellStyle;
      rangeStyle.bold = true;
      rangeStyle.hAlign = HAlignType.center;
      rangeStyle.vAlign = VAlignType.center;
      colocarbordarCompleta(rangeStyle);
      range.setText('3');
      range = dados.getRangeByIndex(14, 11);
      range.merge();
      rangeStyle = range.cellStyle;
      rangeStyle.bold = true;
      rangeStyle.hAlign = HAlignType.center;
      rangeStyle.vAlign = VAlignType.center;
      colocarbordarCompleta(rangeStyle);
      range.setText('4');
      range = dados.getRangeByIndex(14, 12);
      range.merge();
      rangeStyle = range.cellStyle;
      rangeStyle.bold = true;
      rangeStyle.hAlign = HAlignType.center;
      rangeStyle.vAlign = VAlignType.center;
      colocarbordarCompleta(rangeStyle);
      range.setText('5');
      //Descrição da resposta
      range = dados.getRangeByIndex(14, 13, 14, 18);
      range.merge();
      rangeStyle = range.cellStyle;
      rangeStyle.bold = true;
      rangeStyle.fontName = 'Arial';
      rangeStyle.fontSize = 9;
      rangeStyle.hAlign = HAlignType.center;
      rangeStyle.vAlign = VAlignType.center;
      colocarbordarCompleta(rangeStyle);
      range.setText('DESCRIÇÃO DA NÃO CONFORMIDADE');
      range = dados.getRangeByIndex(15, 3, 15, 18);
      range.merge();
      int y = 16;
      for (QuestaoVeiculo q in questoes) {
        resposta(
          dados,
          y,
          q,
          respostas,
          q.para.any((e) => v.tipo == e),
        );
        y++;
      }
      range = dados.getRangeByIndex(6, 6, 12, 6);
      range.autoFit();
      i++;
    }

    String dataRealizacao = respostas.first.data.replaceAll('/', '-');
    String name = 'relatorio_veiculo_nao_conformidade_$dataRealizacao.xlsx';
    String path = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS,
    );
    File file = File('$path/$name');
    await file.writeAsBytes(workbook.saveAsStream());
    workbook.dispose();
    OpenFile.open('$path/$name');
  }

  void colocarbordarCompleta(Style rangeStyle) {
    rangeStyle.borders.all.lineStyle = LineStyle.thin;
    rangeStyle.borders.all.color = '#000000';
  }

  void pontosVerificados(
    Range rangeTitulo,
    Range rangeValor,
    String txtTitulo,
    String txtValor,
  ) {
    rangeTitulo.merge();
    Style rangeStyle = rangeTitulo.cellStyle;
    rangeStyle.fontName = 'Arial';
    rangeStyle.fontSize = 11;
    rangeStyle.hAlign = HAlignType.left;
    rangeStyle.vAlign = VAlignType.center;
    colocarbordarCompleta(rangeStyle);
    rangeTitulo.setText(txtTitulo);
    rangeTitulo.autoFit();
    rangeStyle = rangeValor.cellStyle;
    rangeStyle.fontName = 'Arial';
    rangeStyle.fontSize = 11;
    rangeStyle.hAlign = HAlignType.left;
    rangeStyle.vAlign = VAlignType.center;
    colocarbordarCompleta(rangeStyle);
    rangeValor.setText(txtValor);
    rangeValor.autoFit();
  }

  void legenda(
    Range rangeTitulo,
    Range rangeValor,
    String txtTitulo,
    String txtValor,
  ) {
    rangeTitulo.columnWidth = 5.67;
    Style rangeStyle = rangeTitulo.cellStyle;
    rangeStyle.bold = true;
    rangeStyle.fontName = 'Arial';
    rangeStyle.fontSize = 11;
    rangeStyle.hAlign = HAlignType.center;
    rangeStyle.vAlign = VAlignType.center;
    colocarbordarCompleta(rangeStyle);
    rangeTitulo.setText(txtTitulo);
    rangeValor.columnWidth = 3.5;
    rangeValor.merge();
    rangeStyle = rangeValor.cellStyle;
    rangeStyle.fontName = 'Arial';
    rangeStyle.fontSize = 11;
    rangeStyle.hAlign = HAlignType.left;
    rangeStyle.vAlign = VAlignType.center;
    rangeStyle.borders.right.lineStyle = LineStyle.thin;
    rangeStyle.borders.right.color = '#000000';
    rangeValor.setText(txtValor);
  }

  void criterio(Range range, String txt) {
    range.merge();
    Style rangeStyle = range.cellStyle;
    rangeStyle.fontName = 'Arial';
    rangeStyle.fontSize = 11;
    rangeStyle.hAlign = HAlignType.center;
    rangeStyle.vAlign = VAlignType.center;
    rangeStyle.borders.right.lineStyle = LineStyle.thin;
    rangeStyle.borders.right.color = '#000000';
    range.setText(txt);
  }

  void resposta(Worksheet dados, int linha, QuestaoVeiculo questao,
      List<RespostaVeiculo> respostas, bool isValida) {
    Range range = dados.getRangeByIndex(linha, 3);
    Style rangeStyle = range.cellStyle;
    rangeStyle.fontSize = 9;
    rangeStyle.hAlign = HAlignType.center;
    rangeStyle.vAlign = VAlignType.center;
    rangeStyle.borders.all.lineStyle = LineStyle.thin;
    rangeStyle.borders.all.color = '#000000';
    range.setText('${questao.id}');
    range.autoFit();
    range = dados.getRangeByIndex(linha, 4, linha, 7);
    range.merge();
    rangeStyle = range.cellStyle;
    rangeStyle.fontName = 'Arial';
    rangeStyle.fontSize = 11;
    rangeStyle.hAlign = HAlignType.left;
    rangeStyle.vAlign = VAlignType.center;
    rangeStyle.borders.all.lineStyle = LineStyle.thin;
    rangeStyle.borders.all.color = '#000000';
    range.setText(questao.nome);
    String dscNC = '';
    if (respostas.any((e) => e.idQuestao == questao.id)) {
      RespostaVeiculo r =
          respostas.firstWhere((e) => e.idQuestao == questao.id);
      dscNC = r.dscNC ?? '';
      switch (r.opcao!) {
        case '2':
          range = dados.getRangeByIndex(linha, 8);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('');
          range = dados.getRangeByIndex(linha, 9);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('X');
          range = dados.getRangeByIndex(linha, 10);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('');
          range = dados.getRangeByIndex(linha, 11);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('');
          range = dados.getRangeByIndex(linha, 12);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('');
          break;
        case '3':
          range = dados.getRangeByIndex(linha, 8);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('');
          range = dados.getRangeByIndex(linha, 9);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('');
          range = dados.getRangeByIndex(linha, 10);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('X');
          range = dados.getRangeByIndex(linha, 11);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('');
          range = dados.getRangeByIndex(linha, 12);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('');
          break;
        case '4':
          range = dados.getRangeByIndex(linha, 8);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('');
          range = dados.getRangeByIndex(linha, 9);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('');
          range = dados.getRangeByIndex(linha, 10);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('');
          range = dados.getRangeByIndex(linha, 11);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('X');
          range = dados.getRangeByIndex(linha, 12);
          rangeStyle = range.cellStyle;
          rangeStyle.hAlign = HAlignType.center;
          rangeStyle.vAlign = VAlignType.center;
          rangeStyle.borders.all.lineStyle = LineStyle.thin;
          rangeStyle.borders.all.color = '#000000';
          range.setText('');
          break;
      }
    } else {
      if (isValida) {
        range = dados.getRangeByIndex(linha, 8);
        rangeStyle = range.cellStyle;
        rangeStyle.hAlign = HAlignType.center;
        rangeStyle.vAlign = VAlignType.center;
        rangeStyle.borders.all.lineStyle = LineStyle.thin;
        rangeStyle.borders.all.color = '#000000';
        range.setText('X');
        range = dados.getRangeByIndex(linha, 9);
        rangeStyle = range.cellStyle;
        rangeStyle.hAlign = HAlignType.center;
        rangeStyle.vAlign = VAlignType.center;
        rangeStyle.borders.all.lineStyle = LineStyle.thin;
        rangeStyle.borders.all.color = '#000000';
        range.setText('');
        range = dados.getRangeByIndex(linha, 10);
        rangeStyle = range.cellStyle;
        rangeStyle.hAlign = HAlignType.center;
        rangeStyle.vAlign = VAlignType.center;
        rangeStyle.borders.all.lineStyle = LineStyle.thin;
        rangeStyle.borders.all.color = '#000000';
        range.setText('');
        range = dados.getRangeByIndex(linha, 11);
        rangeStyle = range.cellStyle;
        rangeStyle.hAlign = HAlignType.center;
        rangeStyle.vAlign = VAlignType.center;
        rangeStyle.borders.all.lineStyle = LineStyle.thin;
        rangeStyle.borders.all.color = '#000000';
        range.setText('');
        range = dados.getRangeByIndex(linha, 12);
        rangeStyle = range.cellStyle;
        rangeStyle.hAlign = HAlignType.center;
        rangeStyle.vAlign = VAlignType.center;
        rangeStyle.borders.all.lineStyle = LineStyle.thin;
        rangeStyle.borders.all.color = '#000000';
        range.setText('');
      } else {
        range = dados.getRangeByIndex(linha, 8);
        rangeStyle = range.cellStyle;
        rangeStyle.hAlign = HAlignType.center;
        rangeStyle.vAlign = VAlignType.center;
        rangeStyle.borders.all.lineStyle = LineStyle.thin;
        rangeStyle.borders.all.color = '#000000';
        range.setText('');
        range = dados.getRangeByIndex(linha, 9);
        rangeStyle = range.cellStyle;
        rangeStyle.hAlign = HAlignType.center;
        rangeStyle.vAlign = VAlignType.center;
        rangeStyle.borders.all.lineStyle = LineStyle.thin;
        rangeStyle.borders.all.color = '#000000';
        range.setText('');
        range = dados.getRangeByIndex(linha, 10);
        rangeStyle = range.cellStyle;
        rangeStyle.hAlign = HAlignType.center;
        rangeStyle.vAlign = VAlignType.center;
        rangeStyle.borders.all.lineStyle = LineStyle.thin;
        rangeStyle.borders.all.color = '#000000';
        range.setText('');
        range = dados.getRangeByIndex(linha, 11);
        rangeStyle = range.cellStyle;
        rangeStyle.hAlign = HAlignType.center;
        rangeStyle.vAlign = VAlignType.center;
        rangeStyle.borders.all.lineStyle = LineStyle.thin;
        rangeStyle.borders.all.color = '#000000';
        range.setText('');
        range = dados.getRangeByIndex(linha, 12);
        rangeStyle = range.cellStyle;
        rangeStyle.hAlign = HAlignType.center;
        rangeStyle.vAlign = VAlignType.center;
        rangeStyle.borders.all.lineStyle = LineStyle.thin;
        rangeStyle.borders.all.color = '#000000';
        range.setText('X');
      }
    }
    range = dados.getRangeByIndex(linha, 13, linha, 18);
    range.merge();
    rangeStyle = range.cellStyle;
    rangeStyle.hAlign = HAlignType.left;
    rangeStyle.vAlign = VAlignType.center;
    rangeStyle.borders.all.lineStyle = LineStyle.thin;
    rangeStyle.borders.all.color = '#000000';
    range.setText(dscNC);
  }
}
