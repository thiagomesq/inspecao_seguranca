import 'package:json_annotation/json_annotation.dart';

part 'resposta_comissio_veiculo.g.dart';

@JsonSerializable()
class RespostaComissioVeiculo {
  final int idQuestao;
  final String questao;
  String? opcao;
  final String data;
  final String veiculo;
  String? dscNC;

  RespostaComissioVeiculo({
    required this.idQuestao,
    required this.questao,
    this.opcao,
    required this.veiculo,
    required this.data,
    this.dscNC,
  });

  factory RespostaComissioVeiculo.fromJson(Map<String, dynamic> json) =>
      _$RespostaComissioVeiculoFromJson(json);

  Map<String, dynamic> toJson() => _$RespostaComissioVeiculoToJson(this);

  void changeOpcao(String opcao) {
    this.opcao = opcao;
  }
}
