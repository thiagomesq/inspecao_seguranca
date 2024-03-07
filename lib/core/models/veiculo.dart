import 'package:json_annotation/json_annotation.dart';

part 'veiculo.g.dart';

@JsonSerializable()
class Veiculo {
  String? placa;
  int? ano;
  String? tipo;
  String? empresa;
  String? finalidade;

  Veiculo({
    this.placa,
    this.ano,
    this.tipo,
    this.empresa,
    this.finalidade,
  });

  factory Veiculo.fromJson(Map<String, dynamic> json) =>
      _$VeiculoFromJson(json);

  Map<String, dynamic> toJson() => _$VeiculoToJson(this);
}
