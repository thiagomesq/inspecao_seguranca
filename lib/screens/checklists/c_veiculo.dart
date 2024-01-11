import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:inspecao_seguranca/constants.dart';
import 'package:inspecao_seguranca/models/localidade.dart';
import 'package:inspecao_seguranca/models/motorista_operador.dart';
import 'package:inspecao_seguranca/models/questao_veiculo.dart';
import 'package:inspecao_seguranca/models/resposta_veiculo.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:inspecao_seguranca/models/veiculo.dart';
import 'package:inspecao_seguranca/widgets/carregador.dart';
import 'package:inspecao_seguranca/widgets/resposta_veiculo_list.dart';
import 'package:provider/provider.dart';

class CVeiculoScreen extends StatefulWidget {
  const CVeiculoScreen({Key? key}) : super(key: key);

  @override
  _CVeiculoScreenState createState() => _CVeiculoScreenState();
}

class _CVeiculoScreenState extends State<CVeiculoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _veiculoTextFieldController = TextEditingController();
  final _localidadeTextFieldController = TextEditingController();
  final _motoristaOperadorTextFieldController = TextEditingController();
  final _cnhTextFieldController = TextEditingController();
  final _validadeTextFieldController = TextEditingController();
  MotoristaOperador _motoristaOperador = MotoristaOperador();
  Veiculo _selectedVeiculo = Veiculo();
  String _selectedLocalidade = '';
  late List<RespostaVeiculo> respostas;
  late FocusNode _veiculoFocusNode;
  late FocusNode _condutorFocusNode;
  late FocusNode _localidadeFocusNode;

  @override
  void initState() {
    super.initState();
    _veiculoFocusNode = FocusNode();
    _condutorFocusNode = FocusNode();
    _localidadeFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final TSLData tslData = TSLData();
    return Consumer<List<QuestaoVeiculo>>(
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
        dia >= 10 ? diaString = dia.toString() : diaString = '0$dia';
        mes >= 10 ? mesString = mes.toString() : mesString = '0$mes';
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
                      _motoristaOperador = MotoristaOperador();
                      _selectedVeiculo = Veiculo();
                      _selectedLocalidade = '';
                      _localidadeTextFieldController.clear();
                      _motoristaOperadorTextFieldController.clear();
                      _cnhTextFieldController.clear();
                      _validadeTextFieldController.clear();
                      _veiculoTextFieldController.clear();
                      _localidadeFocusNode.unfocus();
                      _veiculoFocusNode.unfocus();
                      _condutorFocusNode.unfocus();
                      agora = DateTime.now();
                      dia = agora.day;
                      mes = agora.month;
                      ano = agora.year;
                      dia >= 10
                          ? diaString = dia.toString()
                          : diaString = '0$dia';
                      mes >= 10
                          ? mesString = mes.toString()
                          : mesString = '0$mes';
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
                TypeAheadField<Localidade>(
                  controller: _localidadeTextFieldController,
                  focusNode: _localidadeFocusNode,
                  builder: (context, controller, focusNode) {
                    return TextFormField(
                      focusNode: focusNode,
                      controller: controller,
                      enabled: _selectedVeiculo.placa == null,
                      decoration: const InputDecoration(
                        labelText: 'Localidade',
                        focusColor: Colors.white,
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        return value!.isEmpty ? 'Preencha a localidade!' : null;
                      },
                    );
                  },
                  suggestionsCallback: (pattern) {
                    return tslData.getLocalidadesFiltrada(pattern);
                  },
                  itemBuilder: (context, item) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(item.nome),
                    );
                  },
                  emptyBuilder: (context) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Não há registros!',
                          style: TextStyle(
                            color: emflorGreen,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (item) {
                    setState(() {
                      _selectedLocalidade = item.nome;
                      _localidadeTextFieldController.text = item.nome;
                    });
                  },
                ),
                TypeAheadField<MotoristaOperador>(
                  controller: _motoristaOperadorTextFieldController,
                  focusNode: _condutorFocusNode,
                  builder: (context, controller, focusNode) {
                    return TextFormField(
                      focusNode: focusNode,
                      controller: controller,
                      enabled: _selectedVeiculo.placa == null,
                      decoration: const InputDecoration(
                        labelText: 'Condutor / Operador',
                        focusColor: Colors.white,
                      ),
                      textCapitalization: TextCapitalization.words,
                      maxLength: 50,
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Introduza o nome do condutor / operador!'
                            : null;
                      },
                    );
                  },
                  suggestionsCallback: (pattern) {
                    return tslData.getMotoristasOperadoresFiltrados(pattern);
                  },
                  itemBuilder: (context, item) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(item.nome!),
                    );
                  },
                  emptyBuilder: (context) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Não há registros!',
                          style: TextStyle(
                            color: emflorGreen,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (item) {
                    setState(() {
                      _motoristaOperador = item;
                      _motoristaOperadorTextFieldController.text = item.nome!;
                      _cnhTextFieldController.text = item.cnh!;
                      String validade = item.validade!;
                      DateTime dValidade = DateTime(
                        int.parse(validade.substring(6)),
                        int.parse(validade.substring(3, 5)),
                        int.parse(validade.substring(0, 2)),
                      );
                      DateTime agora = DateTime.now();
                      _validadeTextFieldController.text =
                          dValidade.isBefore(agora) ? 'Vencida' : 'Valida';
                    });
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        enabled: false,
                        controller: _cnhTextFieldController,
                        decoration: const InputDecoration(label: Text('CNH')),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: TextField(
                        enabled: false,
                        controller: _validadeTextFieldController,
                        decoration:
                            const InputDecoration(label: Text('Validade')),
                      ),
                    ),
                  ],
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
                            focusNode: focusNode,
                            controller: controller,
                            enabled: _selectedLocalidade != '' &&
                                _motoristaOperador.nome != null,
                            decoration: const InputDecoration(
                              labelText: 'Veículo',
                              focusColor: Colors.white,
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
                                'Não há registros!',
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
                                title: const Text('Seleção de veículo'),
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
                                          List<QuestaoVeiculo>
                                              questaoValidaList =
                                              questaoList.where((element) {
                                            return element.para.any((e) {
                                              return item.tipo!.contains(e);
                                            });
                                          }).toList();
                                          tslData.gerarRespostasVeiculo(
                                            questaoValidaList,
                                            data,
                                            _selectedLocalidade,
                                            item.placa!,
                                            _motoristaOperador,
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
                    child: StreamBuilder<List<RespostaVeiculo>>(
                        stream: tslData.getRespostasVeiculo(
                          data: data,
                          veiculo: _selectedVeiculo.placa!,
                          localidade: _selectedLocalidade,
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Carregador();
                          }
                          respostas = snapshot.data!;
                          return RespostaVeiculoList(
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
