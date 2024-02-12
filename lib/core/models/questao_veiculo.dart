import 'package:json_annotation/json_annotation.dart';

part 'questao_veiculo.g.dart';

@JsonSerializable()
class QuestaoVeiculo {
  final int id;
  final String nome;
  final List<String> para;

  QuestaoVeiculo({required this.id, required this.nome, required this.para});

  factory QuestaoVeiculo.fromJson(Map<String, dynamic> json) =>
      _$QuestaoVeiculoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestaoVeiculoToJson(this);
}
