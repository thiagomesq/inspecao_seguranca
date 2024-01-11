import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inspecao_seguranca/models/excel.dart';
import 'package:inspecao_seguranca/models/questao_veiculo.dart';
import 'package:inspecao_seguranca/models/resposta_veiculo.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:inspecao_seguranca/models/veiculo.dart';
import 'package:inspecao_seguranca/widgets/carregador.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class RVeiculosNaoConformidadeScreen extends StatefulWidget {
  final String data;

  const RVeiculosNaoConformidadeScreen({Key? key, this.data = ''})
      : super(key: key);

  @override
  _RVeiculosNaoConformidadeScreenState createState() =>
      _RVeiculosNaoConformidadeScreenState();
}

class _RVeiculosNaoConformidadeScreenState
    extends State<RVeiculosNaoConformidadeScreen> {
  int _rowsPerPage = 5;
  late String data;
  late String veiculo;
  DateTime diaEscolhido = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.data.isEmpty) {
      int dia = diaEscolhido.day;
      int mes = diaEscolhido.month;
      int ano = diaEscolhido.year;
      String diaString;
      String mesString;
      dia >= 10 ? diaString = dia.toString() : diaString = '0' + dia.toString();
      mes >= 10 ? mesString = mes.toString() : mesString = '0' + mes.toString();
      data = '$diaString/$mesString/$ano';
    } else {
      data = widget.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    TSLData tslData = TSLData();
    return Consumer<List<QuestaoVeiculo>>(
      builder: (
        context,
        questaoList,
        child,
      ) {
        return data.isEmpty
            ? CalendarDatePicker(
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now(),
                initialDate: diaEscolhido,
                onDateChanged: (date) {
                  setState(() {
                    int dia = date.day;
                    int mes = date.month;
                    int ano = date.year;
                    String diaString;
                    String mesString;
                    dia >= 10
                        ? diaString = dia.toString()
                        : diaString = '0' + dia.toString();
                    mes >= 10
                        ? mesString = mes.toString()
                        : mesString = '0' + mes.toString();
                    data = '$diaString/$mesString/$ano';
                    veiculo = '';
                  });
                },
              )
            : StreamBuilder<List<RespostaVeiculo>>(
                stream: tslData.getRespostasVeiculoNaoConformidade(
                  data: data,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Carregador();
                  }
                  List<RespostaVeiculo> respostas = snapshot.data!;
                  return StreamBuilder<List<Veiculo>>(
                    stream: tslData.getVeiculosPorRespostas(respostas),
                    builder: (context, snp) {
                      if (!snp.hasData) {
                        return const Carregador();
                      }
                      List<Veiculo> veiculos = snp.data!;
                      double width = MediaQuery.of(context).size.width;
                      if (respostas.isEmpty || veiculos.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.87,
                                right: width * 0.03,
                                top: 10,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    diaEscolhido = DateTime.utc(
                                      int.parse(data.substring(6)),
                                      int.parse(data.substring(3, 5)),
                                      int.parse(data.substring(0, 2)),
                                    );
                                    data = '';
                                    respostas = <RespostaVeiculo>[];
                                  });
                                },
                                child: const Text(
                                  'Fechar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 100.0),
                                child: const Center(
                                  child: Text(
                                    'Não há desconformidades na data!',
                                    style: TextStyle(
                                      color: emflorSilver,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        respostas = respostas
                            .where((e) => veiculos
                                .any((element) => element.placa == e.veiculo))
                            .toList();
                        List<List<DataCell>> naoConformidadeList =
                            List<List<DataCell>>.empty(growable: true);
                        List<Widget> naoConformidadeTable =
                            List<Widget>.empty(growable: true);
                        naoConformidadeTable.add(Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.76,
                            right: width * 0.01,
                            top: 10,
                          ),
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    Excel excel = Excel();
                                    excel.relatorioVeiculoNaoConformidade(
                                      questaoList,
                                      respostas,
                                      veiculos,
                                    );
                                  });
                                },
                                child: const Text(
                                  'Excel',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.01,
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    diaEscolhido = DateTime.utc(
                                      int.parse(data.substring(6)),
                                      int.parse(data.substring(3, 5)),
                                      int.parse(data.substring(0, 2)),
                                    );
                                    data = '';
                                    respostas = <RespostaVeiculo>[];
                                  });
                                },
                                child: const Text(
                                  'Fechar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                ),
                              ),
                            ],
                          ),
                        ));
                        veiculo = respostas.first.veiculo;
                        int i = 0;
                        String empresa = veiculos[i].empresa!;
                        String localidade = respostas.first.localidade;
                        for (RespostaVeiculo resposta in respostas) {
                          if (veiculo == resposta.veiculo) {
                            String questao =
                                '${resposta.idQuestao.toString()} - ${resposta.questao}';
                            int numLinhas = 1;
                            if (questao.length >= 50 && questao.length < 100) {
                              questao =
                                  '${questao.substring(0, 50)}\n${questao.substring(50)}';
                              numLinhas = 2;
                            } else if (questao.length >= 100 &&
                                questao.length < 150) {
                              questao =
                                  '${questao.substring(0, 50)}\n${questao.substring(50, 100)}\n${questao.substring(100)}';
                              numLinhas = 3;
                            } else if (questao.length >= 150 &&
                                questao.length < 200) {
                              questao =
                                  '${questao.substring(0, 50)}\n${questao.substring(50, 100)}\n${questao.substring(100, 150)}\n${questao.substring(150)}';
                              numLinhas = 4;
                            }
                            String dscNC = resposta.dscNC!;
                            int numLinhasDscNC = 1;
                            if (dscNC.length >= 40 && dscNC.length < 80) {
                              dscNC =
                                  '${dscNC.substring(0, 40)}\n${dscNC.substring(40)}';
                              numLinhasDscNC = 2;
                            } else if (dscNC.length >= 80 &&
                                dscNC.length < 120) {
                              dscNC =
                                  '${dscNC.substring(0, 40)}\n${dscNC.substring(40, 80)}\n${dscNC.substring(80)}';
                              numLinhasDscNC = 3;
                            }
                            Color ncTextColor = resposta.opcao! == '2'
                                ? ncLeve
                                : resposta.opcao! == '3'
                                    ? ncMedia
                                    : ncGrave;
                            naoConformidadeList.add(<DataCell>[
                              DataCell(
                                Text(
                                  questao,
                                  maxLines: numLinhas,
                                ),
                              ),
                              DataCell(
                                Text(
                                  dscNC,
                                  maxLines: numLinhasDscNC,
                                ),
                              ),
                              DataCell(
                                Text(
                                  resposta.opcao!,
                                  style: TextStyle(color: ncTextColor),
                                ),
                              ),
                            ]);
                          } else {
                            naoConformidadeTable.add(
                              PaginatedDataTable(
                                header: Center(
                                  child: Text(
                                    'Lista de não conformidades - $veiculo - $empresa - $localidade - $data',
                                    style: const TextStyle(
                                      color: emflorGreen,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ),
                                /*actions: [
                                  TextButton(
                                    child: const Icon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        tslData.deleteRespostasVeiculo(veiculo,data,localidade);
                                      });
                                    },
                                  ),
                                ],*/
                                source: NaoConformidadeDataTableSource(
                                  naoConformidadeList: naoConformidadeList,
                                  context: context,
                                ),
                                columns: headerNaoConformidadeTable,
                                availableRowsPerPage:
                                    paginationSelectableRowCount,
                                onRowsPerPageChanged: (r) {
                                  setState(() {
                                    _rowsPerPage = r!;
                                  });
                                },
                                rowsPerPage: _rowsPerPage,
                              ),
                            );
                            veiculo = resposta.veiculo;
                            i++;
                            empresa = veiculos[i].empresa!;
                            localidade = resposta.localidade;
                            naoConformidadeList =
                                List<List<DataCell>>.empty(growable: true);
                            String questao =
                                '${resposta.idQuestao.toString()} - ${resposta.questao}';
                            int numLinhas = 1;
                            if (questao.length >= 50 && questao.length < 100) {
                              questao =
                                  '${questao.substring(0, 50)}\n${questao.substring(50)}';
                              numLinhas = 2;
                            } else if (questao.length >= 100 &&
                                questao.length < 150) {
                              questao =
                                  '${questao.substring(0, 50)}\n${questao.substring(50, 100)}\n${questao.substring(100)}';
                              numLinhas = 3;
                            } else if (questao.length >= 150 &&
                                questao.length < 200) {
                              questao =
                                  '${questao.substring(0, 50)}\n${questao.substring(50, 100)}\n${questao.substring(100, 150)}\n${questao.substring(150)}';
                              numLinhas = 4;
                            }
                            String dscNC = resposta.dscNC!;
                            int numLinhasDscNC = 1;
                            if (dscNC.length >= 40 && dscNC.length < 80) {
                              dscNC =
                                  '${dscNC.substring(0, 40)}\n${dscNC.substring(40)}';
                              numLinhasDscNC = 2;
                            } else if (dscNC.length >= 80 &&
                                dscNC.length < 120) {
                              dscNC =
                                  '${dscNC.substring(0, 40)}\n${dscNC.substring(40, 80)}\n${dscNC.substring(80)}';
                              numLinhasDscNC = 3;
                            }
                            Color ncTextColor = resposta.opcao! == '2'
                                ? ncLeve
                                : resposta.opcao! == '3'
                                    ? ncMedia
                                    : ncGrave;
                            naoConformidadeList.add(<DataCell>[
                              DataCell(
                                Text(
                                  questao,
                                  maxLines: numLinhas,
                                ),
                              ),
                              DataCell(
                                Text(
                                  dscNC,
                                  maxLines: numLinhasDscNC,
                                ),
                              ),
                              DataCell(
                                Text(
                                  resposta.opcao!,
                                  style: TextStyle(color: ncTextColor),
                                ),
                              ),
                            ]);
                          }
                        }
                        naoConformidadeTable.add(
                          PaginatedDataTable(
                            header: Center(
                              child: Text(
                                'Lista de não conformidades - $veiculo - $empresa - $localidade - $data',
                                style: const TextStyle(
                                  color: emflorGreen,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            /*actions: [
                              TextButton(
                                child: const Icon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    tslData.deleteRespostasVeiculo(veiculo,data,localidade);
                                  });
                                },
                              ),
                            ],*/
                            source: NaoConformidadeDataTableSource(
                              naoConformidadeList: naoConformidadeList,
                              context: context,
                            ),
                            columns: headerNaoConformidadeTable,
                            availableRowsPerPage: paginationSelectableRowCount,
                            onRowsPerPageChanged: (r) {
                              setState(() {
                                _rowsPerPage = r!;
                              });
                            },
                            rowsPerPage: _rowsPerPage,
                          ),
                        );
                        return ListView(
                          controller: ScrollController(),
                          children: naoConformidadeTable,
                        );
                      }
                    },
                  );
                },
              );
      },
    );
  }
}

class NaoConformidadeDataTableSource extends DataTableSource {
  List<List<DataCell>> naoConformidadeList;
  BuildContext context;

  NaoConformidadeDataTableSource({
    required this.naoConformidadeList,
    required this.context,
  });

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: naoConformidadeList[index],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => naoConformidadeList.length;

  @override
  int get selectedRowCount => 0;
}
