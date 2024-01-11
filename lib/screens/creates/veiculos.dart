import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:inspecao_seguranca/models/veiculo.dart';
import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/widgets/veiculo_form.dart';
import 'package:inspecao_seguranca/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.Dart';

class VeiculosScreen extends StatefulWidget {
  const VeiculosScreen({Key? key}) : super(key: key);

  @override
  _VeiculosScreenState createState() => _VeiculosScreenState();
}

class _VeiculosScreenState extends State<VeiculosScreen> {
  int _rowsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Consumer<List<Veiculo>>(
      builder: (context, veiculoList, child) {
        return ListView(
          children: <Widget>[
            const VeiculoForm(),
            SingleChildScrollView(
              controller: ScrollController(),
              child: PaginatedDataTable(
                header: const Center(
                  child: Text(
                    'Lista de veículos cadastrados',
                    style: TextStyle(
                      color: emflorGreen,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                source: VeiculoDataTableSource(
                  veiculoList: veiculoList,
                  context: context,
                ),
                columns: headerVeiculoTable,
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

class VeiculoDataTableSource extends DataTableSource {
  List<Veiculo> veiculoList;
  BuildContext context;

  VeiculoDataTableSource({required this.veiculoList, required this.context});

  @override
  DataRow getRow(int index) {
    final TSLData tslData = TSLData();
    Veiculo veiculo = veiculoList[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(veiculo.empresa!)),
        DataCell(Text(veiculo.placa!)),
        DataCell(Text(veiculo.ano!.toString())),
        DataCell(Text(veiculo.tipo!)),
        DataCell(Text(veiculo.registro!)),
        DataCell(Text(veiculo.finalidade!)),
        DataCell(Text(!veiculo.laudo! ? 'Não evidênciado' : 'Evidênciado')),
        DataCell(
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext bContext) {
                  return AlertDialog(
                    title: const Text('Apagar veículo'),
                    content: Text(
                      'Tem a certeza de que quer apagar o veículo com a placa ${veiculo.placa}?',
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
                          tslData.deleteVeiculo(veiculo);
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
  int get rowCount => veiculoList.length;

  @override
  int get selectedRowCount => 0;
}
