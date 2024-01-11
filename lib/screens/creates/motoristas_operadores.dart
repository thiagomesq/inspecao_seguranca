import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:inspecao_seguranca/constants.dart';
import 'package:inspecao_seguranca/models/motorista_operador.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:inspecao_seguranca/widgets/motorista_operador_form.dart';
import 'package:provider/provider.dart';

class MotoristasOperadoresScreen extends StatefulWidget {
  const MotoristasOperadoresScreen({Key? key}) : super(key: key);

  @override
  State<MotoristasOperadoresScreen> createState() =>
      _MotoristasOperadoresScreenState();
}

class _MotoristasOperadoresScreenState
    extends State<MotoristasOperadoresScreen> {
  int _rowsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Consumer<List<MotoristaOperador>>(
      builder: (context, motoristaOperadorList, child) {
        return ListView(
          children: [
            const MotoristaOperadorForm(),
            SingleChildScrollView(
              controller: ScrollController(),
              child: PaginatedDataTable(
                header: const Center(
                  child: Text(
                    'Lista de motoristas/operadores cadastrados',
                    style: TextStyle(
                      color: emflorGreen,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                source: MotoristaOperadorDataTableSource(
                  motoristaOperadorList: motoristaOperadorList,
                  context: context,
                ),
                columns: headerMotoristaOperadorTable,
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

class MotoristaOperadorDataTableSource extends DataTableSource {
  List<MotoristaOperador> motoristaOperadorList;
  BuildContext context;

  MotoristaOperadorDataTableSource(
      {required this.motoristaOperadorList, required this.context});

  @override
  DataRow? getRow(int index) {
    final TSLData tslData = TSLData();
    MotoristaOperador motoristaOperador = motoristaOperadorList[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(motoristaOperador.nome!)),
        DataCell(Text(motoristaOperador.funcao!)),
        DataCell(Text(motoristaOperador.cnh!)),
        DataCell(Text(motoristaOperador.categoria!)),
        DataCell(Text(motoristaOperador.validade!)),
        DataCell(
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext bContext) {
                  return AlertDialog(
                    title: const Text('Apagar Motorista/Operador'),
                    content: Text(
                      'Tem a certeza de que quer apagar o motorista/operador ${motoristaOperador.nome}?',
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
                          tslData.deleteMotoristaOperador(motoristaOperador);
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
  int get rowCount => motoristaOperadorList.length;

  @override
  int get selectedRowCount => 0;
}
