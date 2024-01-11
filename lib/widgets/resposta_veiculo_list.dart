import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/models/resposta_veiculo.dart';
import 'package:inspecao_seguranca/screens/checklists/inserir_dsc_nc_veiculo.dart';
import 'package:inspecao_seguranca/widgets/resposta_veiculo_list_tile.dart';

class RespostaVeiculoList extends StatelessWidget {
  final List<RespostaVeiculo>? respostas;
  final GlobalKey<FormState>? formKey;

  const RespostaVeiculoList({
    Key? key,
    this.respostas,
    this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TSLData tslData = TSLData();
    return ListView.builder(
      itemBuilder: (context, index) {
        RespostaVeiculo resposta = respostas![index];
        TextEditingController dscNCTextFieldController =
            TextEditingController();
        dscNCTextFieldController.text = resposta.dscNC!;
        return RespostaVeiculoListTile(
          resposta: resposta,
          numeracao: resposta.idQuestao,
          onChangedRadioButton: (value) {
            resposta.changeOpcao(value!);
            tslData.updateRespostaVeiculo(resposta);
          },
          onPressedButtonNC: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: InserirDscNCVeiculo(resposta),
                ),
              ),
            );
          },
        );
      },
      itemCount: respostas!.length,
    );
  }
}
