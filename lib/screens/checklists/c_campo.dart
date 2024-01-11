import 'package:inspecao_seguranca/models/empresa.dart';
import 'package:inspecao_seguranca/models/localidade.dart';
import 'package:inspecao_seguranca/models/questao_campo.dart';
import 'package:inspecao_seguranca/models/resposta_campo.dart';
import 'package:inspecao_seguranca/widgets/carregador.dart';
import 'package:inspecao_seguranca/widgets/resposta_campo_list.dart';
import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/services.Dart';

import '../../constants.dart';

class CCampoScreen extends StatefulWidget {
  const CCampoScreen({Key? key}) : super(key: key);

  @override
  _CCampoScreenState createState() => _CCampoScreenState();
}

class _CCampoScreenState extends State<CCampoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _empresaTextFieldController = TextEditingController();
  final _localidadeTextFieldController = TextEditingController();
  late FocusNode _empresaFocusNode;
  late FocusNode _localidadeFocusNode;

  @override
  void initState() {
    super.initState();
    _empresaFocusNode = FocusNode();
    _localidadeFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final TSLData checklistData = TSLData();
    return Consumer<List<QuestaoCampo>>(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _localidadeTextFieldController.clear();
                      _empresaTextFieldController.clear();
                      _localidadeFocusNode.unfocus();
                      _empresaFocusNode.unfocus();
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
                  child: const Text(
                    'Novo registro',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: emflorGreen,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 18.0, left: 10.0),
                  child: Text(
                    'Inspeção do día: $data',
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: emflorGreen,
                    ),
                  ),
                ),
                TypeAheadField<Localidade>(
                  autoFlipDirection: true,
                  controller: _localidadeTextFieldController,
                  focusNode: _localidadeFocusNode,
                  builder: (context, controller, focusNode) {
                    return TextFormField(
                      focusNode: focusNode,
                      controller: controller,
                      enabled: controller.text == '' ||
                          _empresaTextFieldController.text == '',
                      decoration: const InputDecoration(
                        labelText: 'Localidade',
                        focusColor: emflorGreen,
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        return value!.isEmpty ? 'Preencha a localidade' : null;
                      },
                    );
                  },
                  suggestionsCallback: (pattern) {
                    return checklistData.getLocalidadesFiltrada(pattern);
                  },
                  itemBuilder: (context, item) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
                      _localidadeTextFieldController.text = item.nome;
                    });
                  },
                ),
                TypeAheadField<Empresa>(
                  autoFlipDirection: true,
                  controller: _empresaTextFieldController,
                  focusNode: _empresaFocusNode,
                  builder: (context, controller, focusNode) {
                    return TextField(
                      focusNode: focusNode,
                      controller: controller,
                      enabled: _localidadeTextFieldController.text == '' ||
                          controller.text == '',
                      decoration: const InputDecoration(
                        labelText: 'Empresa',
                      ),
                      textCapitalization: TextCapitalization.characters,
                    );
                  },
                  suggestionsCallback: (pattern) {
                    return checklistData.getEmpresasFiltradas(pattern);
                  },
                  itemBuilder: (context, item) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (item) {
                    if (_localidadeTextFieldController.text != '') {
                      showDialog(
                        context: context,
                        builder: (BuildContext bContext) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text(
                                'Seleção da localidade e da empresa'),
                            content: Text(
                              'Tem certeza que deseja selecionar a localidade - ${_localidadeTextFieldController.text} - e a empresa ${item.nome}?',
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
                                  _empresaTextFieldController.clear();
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
                                      _empresaTextFieldController.text =
                                          item.nome;
                                      checklistData.gerarRespostasCampo(
                                        questaoList,
                                        data,
                                        _localidadeTextFieldController.text,
                                        item.nome,
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
                    } else {
                      _empresaFocusNode.unfocus();
                      _localidadeFocusNode.requestFocus();
                    }
                  },
                ),
                if (_localidadeTextFieldController.text != '' &&
                    _empresaTextFieldController.text != '')
                  Expanded(
                    child: StreamBuilder<List<RespostaCampo>>(
                      stream: checklistData.getRespostasCampo(
                          data: data,
                          empresa: _empresaTextFieldController.text,
                          localidade: _localidadeTextFieldController.text),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Carregador();
                        }
                        return RespostaCampoList(
                          respostas: snapshot.data!,
                          formKey: _formKey,
                        );
                      },
                    ),
                  )
                else
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Selecione uma localidade e uma empresa',
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
