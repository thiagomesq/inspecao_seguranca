import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/models/resposta_comissio_veiculo.dart';

import '../constants.dart';

class RespostaComissioVeiculoListTile extends StatelessWidget {
  final RespostaComissioVeiculo? resposta;
  final int? numeracao;
  final void Function(String? a)? onChangedRadioButton;
  final void Function()? onPressedButtonNC;

  const RespostaComissioVeiculoListTile({
    Key? key,
    this.resposta,
    this.numeracao,
    required this.onChangedRadioButton,
    this.onPressedButtonNC,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        resposta!.questao,
        style: TextStyle(
          color: resposta!.opcao! == '1' ? emflorGreen : Colors.red,
          fontSize: 12.0,
        ),
      ),
      leading: Text(
        '$numeracao',
        style: const TextStyle(color: emflorGreen),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Radio<String>(
              value: '1',
              groupValue: resposta!.opcao,
              onChanged: onChangedRadioButton,
              activeColor: emflorGreen,
            ),
          ),
          const Expanded(child: Text('1')),
          Expanded(
            child: Radio<String>(
              value: '2',
              groupValue: resposta!.opcao,
              onChanged: onChangedRadioButton,
              activeColor: emflorGreen,
            ),
          ),
          const Expanded(child: Text('2')),
          Expanded(
            child: Radio<String>(
              value: '3',
              groupValue: resposta!.opcao,
              onChanged: onChangedRadioButton,
              activeColor: emflorGreen,
            ),
          ),
          const Expanded(child: Text('3')),
          Expanded(
            child: Radio<String>(
              value: '4',
              groupValue: resposta!.opcao,
              onChanged: onChangedRadioButton,
              activeColor: emflorGreen,
            ),
          ),
          const Expanded(child: Text('4')),
        ],
      ),
      trailing: resposta!.opcao! != '1'
          ? TextButton(
              onPressed: onPressedButtonNC,
              child: const Text('DscNC'),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: emflorGreen,
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 8.0,
                ),
              ),
            )
          : null,
    );
  }
}
