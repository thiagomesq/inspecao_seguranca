import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:inspecao_seguranca/constants.dart';
import 'package:inspecao_seguranca/models/empresa.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:inspecao_seguranca/widgets/empresa_form.dart';
import 'package:provider/provider.dart';

class EmpresasScreen extends StatefulWidget {
  const EmpresasScreen({Key? key}) : super(key: key);

  @override
  State<EmpresasScreen> createState() => _EmpresasScreenState();
}

class _EmpresasScreenState extends State<EmpresasScreen> {
  int _rowsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Consumer<List<Empresa>>(builder: (context, empresaList, child) {
      return ListView(
        children: [
          const EmpresaForm(),
          SingleChildScrollView(
            controller: ScrollController(),
            child: PaginatedDataTable(
              header: const Center(
                child: Text(
                  'Lista de funções cadastrados',
                  style: TextStyle(
                    color: emflorGreen,
                    fontSize: 17.0,
                  ),
                ),
              ),
              source: EmpresaDataTableSource(
                empresaList: empresaList,
                context: context,
              ),
              columns: headerFuncaoTable,
              availableRowsPerPage: paginationSelectableRowCount,
              onRowsPerPageChanged: (r) {
                setState(() {
                  _rowsPerPage = r!;
                });
              },
              horizontalMargin: 1.0,
              rowsPerPage: _rowsPerPage,
            ),
          ),
        ],
      );
    },);
  }
}

class EmpresaDataTableSource extends DataTableSource {
  List<Empresa> empresaList;
  BuildContext context;

  EmpresaDataTableSource(
      {required this.empresaList, required this.context});

  @override
  DataRow? getRow(int index) {
    final TSLData tslData = TSLData();
    Empresa empresa = empresaList[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(empresa.nome)),
        DataCell(
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext bContext) {
                  return AlertDialog(
                    title: const Text('Apagar Empresa'),
                    content: Text(
                      'Tem certeza de que quer apagar a empresa ${empresa.nome}?',
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          primary: emflorGreen,
                        ),
                      ),
                      TextButton(
                        child: const Text('Sim'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          tslData.deleteEmpresa(empresa);
                        },
                        style: TextButton.styleFrom(
                          primary: emflorGreen,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 2.5,
              primary: Colors.red,
            ),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => empresaList.length;

  @override
  int get selectedRowCount => 0;
}