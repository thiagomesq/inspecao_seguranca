import 'package:inspecao_seguranca/models/resposta_comissio_veiculo.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/screens/checklists/inserir_dsc_nc_comissio_veiculo.dart';
import 'package:inspecao_seguranca/widgets/resposta_comissio_veiculo_list_tile.dart';

class RespostaComissioVeiculoList extends StatelessWidget {
  final List<RespostaComissioVeiculo>? respostas;
  final GlobalKey<FormState>? formKey;

  const RespostaComissioVeiculoList({
    Key? key,
    this.respostas,
    this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TSLData tslData = TSLData();
    return ListView.builder(
      itemBuilder: (context, index) {
        RespostaComissioVeiculo resposta = respostas![index];
        TextEditingController dscNCTextFieldController =
            TextEditingController();
        dscNCTextFieldController.text = resposta.dscNC!;
        return RespostaComissioVeiculoListTile(
          resposta: resposta,
          numeracao: resposta.idQuestao,
          onChangedRadioButton: (value) {
            resposta.changeOpcao(value!);
            tslData.updateRespostaComissioVeiculo(resposta);
          },
          onPressedButtonNC: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: InserirDscNCComissioVeiculo(resposta),
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
