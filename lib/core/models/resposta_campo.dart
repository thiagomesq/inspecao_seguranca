import 'package:json_annotation/json_annotation.dart';

part 'resposta_campo.g.dart';

@JsonSerializable()
class RespostaCampo {
  final int idQuestao;
  final String questao;
  String? opcao;
  final String data;
  final String empresa;
  final String localidade;
  String? dscNC;

  RespostaCampo({
    required this.idQuestao,
    required this.questao,
    this.opcao,
    required this.empresa,
    required this.data,
    required this.localidade,
    this.dscNC,
  });

  factory RespostaCampo.fromJson(Map<String, dynamic> json) =>
      _$RespostaCampoFromJson(json);

  Map<String, dynamic> toJson() => _$RespostaCampoToJson(this);

  void changeOpcao(String opcao) {
    this.opcao = opcao;
  }
}
