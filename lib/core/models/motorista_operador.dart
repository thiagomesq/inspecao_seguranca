import 'package:json_annotation/json_annotation.dart';

part 'motorista_operador.g.dart';

@JsonSerializable()
class MotoristaOperador {
  final String? nome;
  final String? funcao;
  final String? cnh;
  final String? categoria;
  final String? validade;

  MotoristaOperador({
    this.nome,
    this.funcao,
    this.cnh,
    this.categoria,
    this.validade,
  });

  factory MotoristaOperador.fromJson(Map<String, dynamic> json) =>
      _$MotoristaOperadorFromJson(json);

  Map<String, dynamic> toJson() => _$MotoristaOperadorToJson(this);
}
