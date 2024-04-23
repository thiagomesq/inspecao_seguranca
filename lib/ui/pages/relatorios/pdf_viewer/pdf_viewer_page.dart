import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspecao_seguranca/core/models/report_data.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatelessWidget {
  static const routeName = '/reports/pdf-viewer';
  const PdfViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    RelatorioData reportData =
        ModalRoute.of(context)?.settings.arguments as RelatorioData;
    switch (reportData.orietacao) {
      case 'paisagem':
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
        break;
      default:
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    return Scaffold(
      appBar: const ISAppBar(),
      body: SfPdfViewer.memory(
        Uint8List.fromList(reportData.bytes),
      ),
    );
  }
}
