import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:inspecao_seguranca/models/resposta_campo.dart';
import 'package:inspecao_seguranca/screens/checklists/inserir_dsc_nc_campo.dart';
import 'package:inspecao_seguranca/widgets/resposta_campo_list_tile.dart';
import 'package:flutter/material.dart';

class RespostaCampoList extends StatefulWidget {
  final List<RespostaCampo>? respostas;
  final GlobalKey<FormState>? formKey;

  const RespostaCampoList({
    Key? key,
    this.respostas,
    this.formKey,
  }) : super(key: key);

  @override
  State<RespostaCampoList> createState() => _RespostaCampoListState();
}

class _RespostaCampoListState extends State<RespostaCampoList> {
  @override
  Widget build(BuildContext context) {
    final TSLData checklistData = TSLData();
    return ListView.builder(
      itemBuilder: (context, index) {
        RespostaCampo resposta = widget.respostas![index];
        return RespostaCampoListTile(
          resposta: resposta,
          numeracao: resposta.idQuestao,
          onChangedRadioButton: (value) {
            resposta.changeOpcao(value!);
            checklistData.updateRespostaCampo(resposta);
          },
          onPressedButtonNC: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: InserirDscNCCampo(resposta),
                ),
              ),
            );
          },
        );
      },
      itemCount: widget.respostas!.length,
    );
  }
}
