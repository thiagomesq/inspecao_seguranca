import 'package:inspecao_seguranca/constants.dart';
import 'package:inspecao_seguranca/models/finalidade_veiculo.dart';
import 'package:inspecao_seguranca/models/tipo_veiculo.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:inspecao_seguranca/models/empresa.dart';
import 'package:inspecao_seguranca/models/veiculo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VeiculoForm extends StatefulWidget {
  const VeiculoForm({Key? key}) : super(key: key);

  @override
  _VeiculoFormState createState() => _VeiculoFormState();
}

class _VeiculoFormState extends State<VeiculoForm> {
  final _formKey = GlobalKey<FormState>();
  static const String _empresaDefault = 'Seleciona a empresa';
  String selectedEmpresa = _empresaDefault;
  static const String _tipoDefault = 'Selecione um tipo';
  String selectedTipo = _tipoDefault;
  static const String _finalidadeDefault = 'Selecione um objetivo';
  String selectedFinalidade = _finalidadeDefault;
  bool isLaudo = false;
  late List<String> _tipos;
  late List<String> _finalidades;
  int? newAno;
  late String newPlaca;
  late String? newRegistro;
  late FocusNode _anoFocusNode;
  late FocusNode _placaFocusNode;
  late FocusNode _registroFocusNode;

  List<DropdownMenuItem<String>> getTipos() {
    List<DropdownMenuItem<String>> tipoItems =
        List<DropdownMenuItem<String>>.generate(
      _tipos.length,
      (index) => DropdownMenuItem<String>(
        child: Text(_tipos[index]),
        value: _tipos[index],
      ),
      growable: false,
    );
    return tipoItems;
  }

  List<DropdownMenuItem<String>> getFinalidades() {
    List<DropdownMenuItem<String>> finalidadeItems =
        List<DropdownMenuItem<String>>.generate(
      _finalidades.length,
      (index) => DropdownMenuItem<String>(
        child: Text(_finalidades[index]),
        value: _finalidades[index],
      ),
      growable: false,
    );
    return finalidadeItems;
  }

  @override
  void initState() {
    super.initState();
    _anoFocusNode = FocusNode();
    _placaFocusNode = FocusNode();
    _registroFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final TSLData tslData = TSLData();
    return Consumer4<List<Veiculo>, List<Empresa>, List<TipoVeiculo>,
        List<FinalidadeVeiculo>>(
      builder: (context, veiculoList, empresaList, tipoVeiculoList,
          finalidadeVeiculoList, child) {
        List<DropdownMenuItem<String>> empresaItems =
            List<DropdownMenuItem<String>>.empty(growable: true);
        empresaItems.add(
          const DropdownMenuItem<String>(
            child: Text(_empresaDefault),
            value: _empresaDefault,
          ),
        );
        for (Empresa empresa in empresaList) {
          empresaItems.add(
            DropdownMenuItem<String>(
              child: Text(empresa.nome),
              value: empresa.nome,
            ),
          );
        }
        _tipos = List<String>.empty(growable: true);
        _tipos.add(_tipoDefault);
        for (TipoVeiculo tipoVeiculo in tipoVeiculoList) {
          _tipos.add(tipoVeiculo.nome);
        }
        _finalidades = List<String>.empty(growable: true);
        _finalidades.add(_finalidadeDefault);
        for (FinalidadeVeiculo finalidadeVeiculo in finalidadeVeiculoList) {
          _finalidades.add(finalidadeVeiculo.nome);
        }
        DateTime hoje = DateTime.now();
        int ano = hoje.year;
        return Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.only(
              top: 10.0,
              right: 5.0,
              left: 5.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: selectedEmpresa,
                  items: empresaItems,
                  isDense: false,
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      selectedEmpresa = value!;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      selectedEmpresa = _empresaDefault;
                    });
                  },
                  validator: (value) {
                    return value == _empresaDefault
                        ? 'Selecione uma empresa válida.'
                        : null;
                  },
                  iconEnabledColor: emflorGreen,
                  decoration: const InputDecoration(
                    labelText: 'Empresa',
                    focusColor: emflorGreen,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        focusNode: _anoFocusNode,
                        onChanged: (value) {
                          setState(() {
                            newAno = int.parse(value);
                          });
                        },
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          return (value!.isEmpty ||
                                  value.length < 4 ||
                                  value.length > 4) &&
                                selectedTipo != 'Equipamentos'
                              ? 'Introduza um ano válido.'
                              : null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Ano',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: TextFormField(
                        focusNode: _placaFocusNode,
                        onChanged: (value) {
                          setState(() {
                            newPlaca = value;
                          });
                        },
                        validator: (value) {
                          return veiculoList.any((e) => value == e.placa)
                              ? 'Placa já cadastrada!'
                              : (value!.isEmpty || value.length < 7)
                                  ? 'Introduza uma placa válida.'
                                  : null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Placa',
                        ),
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  focusNode: _registroFocusNode,
                  onChanged: (value) {
                    setState(() {
                      newRegistro = value;
                    });
                  },
                  /*validator: (value) {
                    return value!.isEmpty
                        ? 'Introduza o número de registro.'
                        : null;
                  },*/
                  decoration: const InputDecoration(
                    labelText: 'Identificação',
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Theme(
                        data: ThemeData(unselectedWidgetColor: emflorGreen),
                        child: CheckboxListTile(
                          title: const Text('LT/ART'),
                          value: isLaudo,
                          onChanged: (value) {
                            setState(() {
                              isLaudo = value!;
                            });
                          },
                          checkColor: emflorGreen,
                          activeColor: Colors.white,
                          subtitle: (selectedTipo ==
                                          'Veículos Leves e Utlitários' &&
                                      newAno != null &&
                                      ano - newAno! >= 4) ||
                                  (selectedTipo == 'Ônibus/Vans' &&
                                      newAno != null &&
                                      ano - newAno! >= 6) ||
                                  (selectedTipo ==
                                          'Veículos de Transporte de cargas' &&
                                      newAno != null &&
                                      ano - newAno! >= 9)
                              ? const Text(
                                  'Requer LT!',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedTipo,
                        items: getTipos(),
                        isDense: false,
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            selectedTipo = value!;
                          });
                        },
                        onSaved: (value) {
                          setState(() {
                            selectedTipo = _tipoDefault;
                          });
                        },
                        validator: (value) {
                          return value == _tipoDefault
                              ? 'Selecione um tipo válido.'
                              : null;
                        },
                        iconEnabledColor: emflorGreen,
                        decoration: const InputDecoration(
                          labelText: 'Tipo',
                          focusColor: emflorGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: selectedFinalidade,
                  items: getFinalidades(),
                  isDense: false,
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      selectedFinalidade = value!;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      selectedFinalidade = _finalidadeDefault;
                    });
                  },
                  validator: (value) {
                    return value == _finalidadeDefault
                        ? 'Selecione uma finalidade de uso válido.'
                        : null;
                  },
                  iconEnabledColor: emflorGreen,
                  decoration: const InputDecoration(
                    labelText: 'Finalidade de uso',
                    focusColor: emflorGreen,
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showGeneralDialog(
                        barrierColor: Colors.white.withOpacity(0.5),
                        transitionBuilder: (context, a1, a2, widget) {
                          final curvedValue =
                              Curves.easeInOutBack.transform(a1.value) - 1.0;
                          return Transform(
                            transform: Matrix4.translationValues(
                              0.0,
                              curvedValue * 200,
                              0.0,
                            ),
                            child: Opacity(
                              opacity: a1.value,
                              child: AlertDialog(
                                backgroundColor: emflorGreen,
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                title: const Text('Registro de veículos'),
                                content: Text(
                                  '$newPlaca foi cadastrada com éxito!',
                                ),
                                titleTextStyle:
                                    const TextStyle(color: Colors.white),
                                contentTextStyle:
                                    const TextStyle(color: Colors.white),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        transitionDuration: const Duration(
                          seconds: 1,
                        ),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, a1, a2) {
                          final curvedValue =
                              Curves.easeInOutBack.transform(a1.value) - 1.0;
                          return Transform(
                            transform: Matrix4.translationValues(
                              0.0,
                              curvedValue * 200,
                              0.0,
                            ),
                            child: Opacity(
                              opacity: a1.value,
                              child: AlertDialog(
                                backgroundColor: emflorGreen,
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                title: const Text('Registro de veículos'),
                                content: Text(
                                  '$newPlaca foi cadastrada com éxito!',
                                ),
                                titleTextStyle:
                                    const TextStyle(color: Colors.white),
                                contentTextStyle:
                                    const TextStyle(color: Colors.white),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      tslData.addVeiculo(
                        newPlaca,
                        newAno,
                        selectedTipo,
                        selectedEmpresa,
                        newRegistro,
                        isLaudo,
                        selectedFinalidade,
                      );
                      _formKey.currentState!.save();
                      _formKey.currentState!.reset();
                      _anoFocusNode.unfocus();
                      _placaFocusNode.unfocus();
                      _registroFocusNode.unfocus();
                      setState(() {
                        isLaudo = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    primary: emflorGreen,
                    padding: const EdgeInsets.symmetric(vertical: 13.0),
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(color: Colors.white),
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
