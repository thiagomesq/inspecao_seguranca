import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:inspecao_seguranca/models/questao_comissio_veiculo.dart';
import 'package:inspecao_seguranca/models/resposta_comissio_veiculo.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:inspecao_seguranca/models/veiculo.dart';
import 'package:inspecao_seguranca/widgets/carregador.dart';
import 'package:inspecao_seguranca/widgets/resposta_comissio_veiculo_list.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class CComissioVeiculoScreen extends StatefulWidget {
  const CComissioVeiculoScreen({Key? key}) : super(key: key);

  @override
  _CComissioVeiculoScreenState createState() => _CComissioVeiculoScreenState();
}

class _CComissioVeiculoScreenState extends State<CComissioVeiculoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _veiculoTextFieldController = TextEditingController();
  Veiculo _selectedVeiculo = Veiculo();
  late List<RespostaComissioVeiculo> respostas;
  late FocusNode _veiculoFocusNode;

  @override
  void initState() {
    super.initState();
    _veiculoFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final TSLData tslData = TSLData();
    return Consumer<List<QuestaoComissioVeiculo>>(
      builder: (
        context,
        questaoList,
        child,
      ) {
        DateTime agora = DateTime.now();
        int dia = agora.day;
        int mes = agora.month;
        int ano = agora.year;
        String diaString;
        String mesString;
        dia >= 10
            ? diaString = dia.toString()
            : diaString = '0' + dia.toString();
        mes >= 10
            ? mesString = mes.toString()
            : mesString = '0' + mes.toString();
        String data = '$diaString/$mesString/$ano';
        return Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.only(
              right: 15.0,
              left: 15.0,
              top: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedVeiculo = Veiculo();
                      _veiculoTextFieldController.clear();
                      _veiculoFocusNode.unfocus();
                      agora = DateTime.now();
                      dia = agora.day;
                      mes = agora.month;
                      ano = agora.year;
                      dia >= 10
                          ? diaString = dia.toString()
                          : diaString = '0' + dia.toString();
                      mes >= 10
                          ? mesString = mes.toString()
                          : mesString = '0' + mes.toString();
                      data = '$diaString/$mesString/$ano';
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: emflorGreen,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  child: const Text(
                    'Novo registro',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    'Inspeção do día: $data',
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: emflorGreen,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TypeAheadField<Veiculo>(
                        autoFlipDirection: true,
                        controller: _veiculoTextFieldController,
                        focusNode: _veiculoFocusNode,
                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              labelText: 'Veículo',
                              focusColor: emflorGreen,
                            ),
                            textCapitalization: TextCapitalization.characters,
                          );
                        },
                        suggestionsCallback: (pattern) {
                          return tslData.getVeiculosFiltrados(pattern);
                        },
                        itemBuilder: (context, item) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(item.placa!),
                          );
                        },
                        emptyBuilder: (context) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'Não há artigos!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          );
                        },
                        onSelected: (item) {
                          showDialog(
                            context: context,
                            builder: (BuildContext bContext) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text('Seleção do veículo'),
                                content: Text(
                                  'Tem certeza que deseja selecionar ${item.placa}?',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(
                                        color: emflorGreen,
                                      ),
                                    ),
                                    onPressed: () {
                                      _veiculoTextFieldController.clear();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      'Sim',
                                      style: TextStyle(
                                        color: emflorGreen,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (_formKey.currentState!.validate()) {
                                          _veiculoTextFieldController.text =
                                              item.placa!;
                                          _selectedVeiculo = item;
                                          List<QuestaoComissioVeiculo>
                                              questaoValidaList =
                                              questaoList.where((element) {
                                            return element.para.any((e) {
                                              return item.tipo!.contains(e);
                                            });
                                          }).toList();
                                          tslData.gerarRespostasComissioVeiculo(
                                            questaoValidaList,
                                            data,
                                            item.placa!,
                                          );
                                        }
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        _selectedVeiculo.empresa ?? 'Empresa',
                        style: const TextStyle(
                          color: emflorGreen,
                          fontSize: 20.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_selectedVeiculo.tipo != null)
                  Expanded(
                    child: StreamBuilder<List<RespostaComissioVeiculo>>(
                        stream: tslData.getRespostasComissioVeiculo(
                            data: data, veiculo: _selectedVeiculo.placa!),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Carregador();
                          }
                          respostas = snapshot.data!;
                          return RespostaComissioVeiculoList(
                            respostas: respostas,
                            formKey: _formKey,
                          );
                        }),
                  )
                else
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Selecione um veículo',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
