import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/constants.dart';
import 'package:inspecao_seguranca/models/resposta_campo.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';

class InserirDscNCCampo extends StatelessWidget {
  final RespostaCampo resposta;

  const InserirDscNCCampo(this.resposta, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TSLData tslData = TSLData();
    TextEditingController controller =
        TextEditingController(text: resposta.dscNC ?? '');
    FocusNode focusNode = FocusNode();
    focusNode.requestFocus();
    return Container(
      color: const Color(0xff757575),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Inserir a não conformidade',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: emflorGreen,
                fontSize: 20.0,
              ),
            ),
            TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {},
            ),
            const SizedBox(
              height: 12.0,
            ),
            TextButton(
              onPressed: () {
                if (controller.text != '') {
                  resposta.dscNC = controller.text;
                  tslData.updateRespostaCampo(resposta);
                  Navigator.of(context).pop();
                  showGeneralDialog(
                    barrierColor: Colors.white.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      final curvedValue =
                          Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: AlertDialog(
                            backgroundColor: emflorGreen,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            content:
                                const Text('Informação salva com sucesso!'),
                            titleTextStyle:
                                const TextStyle(color: Colors.white),
                            contentTextStyle:
                                const TextStyle(color: Colors.white),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
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
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: AlertDialog(
                            backgroundColor: emflorGreen,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            content:
                                const Text('Informação salva com sucesso!'),
                            titleTextStyle:
                                const TextStyle(color: Colors.white),
                            contentTextStyle:
                                const TextStyle(color: Colors.white),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.white,
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
              },
              child: const Text(
                'Salvar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: emflorGreen,
              ),
            )
          ],
        ),
        padding: const EdgeInsets.all(30.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
