import 'package:json_annotation/json_annotation.dart';

part 'veiculo.g.dart';

@JsonSerializable()
class Veiculo {
  final String? placa;
  final int? ano;
  final String? tipo;
  final String? empresa;
  final String? registro;
  final bool? laudo;
  final String? finalidade;

  Veiculo({
    this.ano,
    this.empresa,
    this.registro,
    this.placa,
    this.tipo,
    this.laudo,
    this.finalidade,
  });

  factory Veiculo.fromJson(Map<String, dynamic> json) =>
      _$VeiculoFromJson(json);

  Map<String, dynamic> toJson() => _$VeiculoToJson(this);
}
