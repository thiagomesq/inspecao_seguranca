import 'package:flutter/services.dart';
import 'package:inspecao_seguranca/core/models/relatorio_inspecao.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  Future<List<int>> relatorioInspecao(
    RelatorioInspecao relatorioInspecao,
  ) async {
    final PdfDocument document = PdfDocument();

    document.pageSettings.orientation = PdfPageOrientation.portrait;

    document.template.top = await header();

    final titlePosition = Rect.fromLTWH(0, 20, document.pageSettings.width, 35);
    final titleTotalHeight = titlePosition.height + titlePosition.top;

    PdfPage page = document.pages.add();

    page.graphics.drawString(
      relatorioInspecao.inspecao,
      PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
      bounds: titlePosition,
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    );

    if (relatorioInspecao.respostas.isNotEmpty) {
      PdfFont font = PdfStandardFont(
        PdfFontFamily.helvetica,
        12,
        style: PdfFontStyle.bold,
      );

      Size tamanhoData = font.measureString('Data: ${relatorioInspecao.data}');

      page.graphics.drawString(
        'Data: ${relatorioInspecao.data}',
        font,
        bounds: Rect.fromLTWH(
          0,
          titleTotalHeight + 15,
          tamanhoData.width,
          tamanhoData.height,
        ),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      );

      Size tamanhoVeiculo =
          font.measureString('Veículo: ${relatorioInspecao.veiculo}');

      page.graphics.drawString(
        'Veículo: ${relatorioInspecao.veiculo}',
        font,
        bounds: Rect.fromLTWH(
          tamanhoData.width + 10,
          titleTotalHeight + 15,
          tamanhoVeiculo.width,
          tamanhoVeiculo.height,
        ),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      );

      Size tamanhoInspetor =
          font.measureString('Inspetor: ${relatorioInspecao.inspetor}');

      page.graphics.drawString(
        'Inspetor: ${relatorioInspecao.inspetor}',
        font,
        bounds: Rect.fromLTWH(
          tamanhoData.width + tamanhoVeiculo.width + 20,
          titleTotalHeight + 15,
          tamanhoInspetor.width,
          tamanhoInspetor.height,
        ),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      );

      PdfTextWebLink(
        url:
            'https://www.google.com/maps/@${relatorioInspecao.latitude},${relatorioInspecao.longitude},15z',
        text: 'Localização',
        font: font,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        pen: PdfPens.aliceBlue,
      ).draw(
        page,
        Offset(
          tamanhoData.width + tamanhoVeiculo.width + tamanhoInspetor.width + 30,
          titleTotalHeight + 15,
        ),
      );

      PdfGrid grid = PdfGrid();

      grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 10),
        cellPadding: PdfPaddings(left: 5, right: 5, top: 5, bottom: 5),
      );

      grid.columns.add(count: 3);

      grid.headers.add(1);

      final headerFontStyle = PdfStandardFont(
        PdfFontFamily.helvetica,
        10,
        style: PdfFontStyle.bold,
      );

      PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Questão';
      header.cells[0].style.font = headerFontStyle;
      header.cells[1].value = 'OK';
      header.cells[1].style.font = headerFontStyle;
      header.cells[2].value = 'Desc NC';
      header.cells[2].style.font = headerFontStyle;

      PdfFont rowFont = grid.style.font!;

      double maiorLargura = 0;

      for (int i = 0; i < relatorioInspecao.respostas.length; i++) {
        final isOK = relatorioInspecao.respostas[i].isOk;
        PdfGridRow row = grid.rows.add();
        final questao = relatorioInspecao.questoes[i];
        row.cells[0].value = questao;
        maiorLargura = rowFont.measureString(questao).width + 10 > maiorLargura
            ? rowFont.measureString(questao).width + 10
            : maiorLargura;
        row.cells[0].style.font = rowFont;
        row.cells[1].value = isOK ? 'Sim' : 'Não';
        row.cells[1].style.font = rowFont;
        row.cells[2].value = !isOK ? relatorioInspecao.respostas[i].dscNC : '';
        row.cells[1].style.font = rowFont;
      }

      grid.columns[0].width = maiorLargura;
      grid.columns[1].width = rowFont.measureString('Sim').width + 10;

      grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, titleTotalHeight + 30, 0, 0),
      );
    } else {
      page.graphics.drawString(
        'Nenhum dado encontrado.',
        PdfStandardFont(PdfFontFamily.helvetica, 22, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
          0,
          titleTotalHeight + 30,
          document.pageSettings.width,
          30,
        ),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );
    }

    List<int> bytes = await document.save();
    document.dispose();
    return bytes;
  }

  //header
  Future<PdfPageTemplateElement> header() async {
    final PdfPageTemplateElement headerTemplate =
        PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 56.70));

    final byteData = await rootBundle.load('assets/images/logo_ei.png');

    PdfBitmap image = PdfBitmap(byteData.buffer.asUint8List().toList());

    headerTemplate.graphics.drawImage(
      image,
      const Rect.fromLTWH(0, 0, 57.86, 56.70),
    );

    return headerTemplate;
  }
}
