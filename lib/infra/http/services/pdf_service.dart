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
      PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
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
          titleTotalHeight + 35,
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
          titleTotalHeight + 35,
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
          titleTotalHeight + 35,
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
          titleTotalHeight + 35,
        ),
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
