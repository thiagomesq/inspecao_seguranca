import 'package:json_annotation/json_annotation.dart';

part 'finalidade_veiculo.g.dart';

@JsonSerializable()
class FinalidadeVeiculo {
  final String nome;

  FinalidadeVeiculo({required this.nome});

  factory FinalidadeVeiculo.fromJson(Map<String, dynamic> json) =>
      _$FinalidadeVeiculoFromJson(json);

  Map<String, dynamic> toJson() => _$FinalidadeVeiculoToJson(this);
}
