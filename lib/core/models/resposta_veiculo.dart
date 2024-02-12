import 'package:json_annotation/json_annotation.dart';

part 'resposta_veiculo.g.dart';

@JsonSerializable()
class RespostaVeiculo {
  final int idQuestao;
  final String questao;
  String? opcao;
  final String data;
  final String veiculo;
  final String localidade;
  final String condutor;
  final String validadeHabilitacao;
  String? dscNC;

  RespostaVeiculo({
    required this.idQuestao,
    required this.questao,
    this.opcao,
    required this.veiculo,
    required this.data,
    required this.localidade,
    required this.condutor,
    required this.validadeHabilitacao,
    this.dscNC,
  });

  factory RespostaVeiculo.fromJson(Map<String, dynamic> json) =>
      _$RespostaVeiculoFromJson(json);

  Map<String, dynamic> toJson() => _$RespostaVeiculoToJson(this);

  void changeOpcao(String opcao) {
    this.opcao = opcao;
  }
}
