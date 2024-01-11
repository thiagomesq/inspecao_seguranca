import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/constants.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';

class EmpresaForm extends StatefulWidget {
  const EmpresaForm({Key? key}) : super(key: key);

  @override
  State<EmpresaForm> createState() => _EmpresaFormState();
}

class _EmpresaFormState extends State<EmpresaForm> {
  final _formKey = GlobalKey<FormState>();
  late String newNome;
  late FocusNode _nomeFocusNode;

  @override
  void initState() {
    super.initState();
    _nomeFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final TSLData tslData = TSLData();
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
                            title: const Text('Cadastro de empresas'),
                            content: Text(
                              '$newNome foi cadastrada com éxito!',
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
                            title: const Text('Cadastro de empresas'),
                            content: Text(
                              '$newNome foi cadastrada com éxito!',
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
                  tslData.addEmpresa(newNome);
                  _formKey.currentState!.save();
                  _formKey.currentState!.reset();
                  _nomeFocusNode.unfocus();
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
  }
}
