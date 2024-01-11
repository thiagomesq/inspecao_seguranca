import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:inspecao_seguranca/constants.dart';
import 'package:inspecao_seguranca/models/funcao.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:inspecao_seguranca/widgets/funcao_form.dart';
import 'package:provider/provider.dart';

class FuncoesScreen extends StatefulWidget {
  const FuncoesScreen({Key? key}) : super(key: key);

  @override
  State<FuncoesScreen> createState() => _FuncoesScreenState();
}

class _FuncoesScreenState extends State<FuncoesScreen> {
  int _rowsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Consumer<List<Funcao>>(
      builder: (context, funcaoList, child) {
        return ListView(
          children: [
            const FuncaoForm(),
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
                source: FuncaoDataTableSource(
                  funcaoList: funcaoList,
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
      },
    );
  }
}

class FuncaoDataTableSource extends DataTableSource {
  List<Funcao> funcaoList;
  BuildContext context;

  FuncaoDataTableSource(
      {required this.funcaoList, required this.context});

  @override
  DataRow? getRow(int index) {
    final TSLData tslData = TSLData();
    Funcao funcao = funcaoList[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(funcao.nome)),
        DataCell(
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext bContext) {
                  return AlertDialog(
                    title: const Text('Apagar Função'),
                    content: Text(
                      'Tem certeza de que quer apagar a função ${funcao.nome}?',
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
                          tslData.deleteFuncao(funcao);
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
  int get rowCount => funcaoList.length;

  @override
  int get selectedRowCount => 0;
}