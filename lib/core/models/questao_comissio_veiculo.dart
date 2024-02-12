import 'package:json_annotation/json_annotation.dart';

part 'questao_comissio_veiculo.g.dart';

@JsonSerializable()
class QuestaoComissioVeiculo {
  final int id;
  final String nome;
  final List<String> para;

  QuestaoComissioVeiculo(
      {required this.id, required this.nome, required this.para});

  factory QuestaoComissioVeiculo.fromJson(Map<String, dynamic> json) =>
      _$QuestaoComissioVeiculoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestaoComissioVeiculoToJson(this);
}
