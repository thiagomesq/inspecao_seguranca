import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/constants.dart';
import 'package:inspecao_seguranca/models/funcao.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:provider/provider.dart';

class MotoristaOperadorForm extends StatefulWidget {
  const MotoristaOperadorForm({Key? key}) : super(key: key);

  @override
  State<MotoristaOperadorForm> createState() => _MotoristaOperadorFormState();
}

class _MotoristaOperadorFormState extends State<MotoristaOperadorForm> {
  final _formKey = GlobalKey<FormState>();
  static const String _categoriaDefault = 'Selecione uma categoria';
  String selectedCategoria = _categoriaDefault;
  final categoriaList = <String>[_categoriaDefault, 'A', 'B', 'C', 'D', 'E'];
  static const String _funcaoDefault = 'Selecione uma função';
  String selectedFuncao = _funcaoDefault;
  late String newNome;
  late String newCNH;
  final _validadeTextFieldController = TextEditingController();
  late FocusNode _nomeFocusNode;
  late FocusNode _cnhFocusNode;
  late FocusNode _validadeFocusNode;

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            DateTime.now().subtract(const Duration(days: 365 * 11)).year),
        lastDate:
            DateTime(DateTime.now().add(const Duration(days: 365 * 11)).year));
    if (picked != null) {
      int dia = picked.day;
      int mes = picked.month;
      int ano = picked.year;
      String diaString;
      String mesString;
      dia >= 10 ? diaString = dia.toString() : diaString = '0' + dia.toString();
      mes >= 10 ? mesString = mes.toString() : mesString = '0' + mes.toString();
      String data = '$diaString/$mesString/$ano';
      setState(() => _validadeTextFieldController.text = data);
    }
  }

  @override
  void initState() {
    super.initState();
    _nomeFocusNode = FocusNode();
    _cnhFocusNode = FocusNode();
    _validadeFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final TSLData tslData = TSLData();
    List<DropdownMenuItem<String>> categoriaItems =
        List<DropdownMenuItem<String>>.empty(growable: true);
    for (String c in categoriaList) {
      categoriaItems.add(
        DropdownMenuItem<String>(
          child: Text(c),
          value: c,
        ),
      );
    }
    return Consumer<List<Funcao>>(
      builder: (context, funcaoList, child) {
        List<DropdownMenuItem<String>> funcaoItems =
        List<DropdownMenuItem<String>>.empty(growable: true);
        funcaoItems.add(
          const DropdownMenuItem<String>(
            child: Text(_funcaoDefault),
            value: _funcaoDefault,
          ),
        );
        for (Funcao f in funcaoList) {
          funcaoItems.add(
            DropdownMenuItem<String>(
              child: Text(f.nome),
              value: f.nome,
            ),
          );
        }
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
              children: [
                TextFormField(
                  focusNode: _nomeFocusNode,
                  onChanged: (value) {
                    setState(() {
                      newNome = value;
                    });
                  },
                  maxLength: 50,
                  validator: (value) {
                    return value!.isEmpty ? 'Nome é obrigatório.' : null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedFuncao,
                        items: funcaoItems,
                        isDense: false,
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            selectedFuncao = value!;
                          });
                        },
                        onSaved: (value) {
                          setState(() {
                            selectedFuncao = _funcaoDefault;
                          });
                        },
                        validator: (value) {
                          return value == _funcaoDefault
                              ? 'Selecione uma função válida.'
                              : null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Função',
                          focusColor: emflorGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextFormField(
                        focusNode: _cnhFocusNode,
                        onChanged: (value) {
                          setState(() {
                            newCNH = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          return value!.isEmpty ||
                                  value.length < 11 ||
                                  value.length > 11
                              ? 'Introduza uma CNH válida.'
                              : null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'CNH',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedCategoria,
                        items: categoriaItems,
                        isDense: false,
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            selectedCategoria = value!;
                          });
                        },
                        onSaved: (value) {
                          setState(() {
                            selectedCategoria = _categoriaDefault;
                          });
                        },
                        validator: (value) {
                          return value == _categoriaDefault
                              ? 'Selecione uma categoria válida.'
                              : null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                          focusColor: emflorGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextFormField(
                        focusNode: _validadeFocusNode,
                        controller: _validadeTextFieldController,
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _selectDate();
                        },
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Introduza uma validade válida.'
                              : null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Validade',
                        ),
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                  ],
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
                                title: const Text(
                                    'Cadastro de motoristas/operadores'),
                                content: Text(
                                  '$newNome foi cadastrado(a) com éxito!',
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
                                title: const Text(
                                    'Cadastro de motoristas/operadores'),
                                content: Text(
                                  '$newNome foi cadastrado(a) com éxito!',
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
                      tslData.addMotoristaOperador(
                        newNome,
                        selectedFuncao,
                        newCNH,
                        selectedCategoria,
                        _validadeTextFieldController.text,
                      );
                      _formKey.currentState!.save();
                      _formKey.currentState!.reset();
                      _nomeFocusNode.unfocus();
                      _cnhFocusNode.unfocus();
                      _validadeFocusNode.unfocus();
                      _validadeTextFieldController.clear();
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
