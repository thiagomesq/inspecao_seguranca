import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'inspecao.g.dart';

@JsonSerializable()
class Inspecao {
  String? id;
  String? nome;
  String? descricao;
  String? tipoVeiculo;
  String? empresa;

  Inspecao({
    this.nome,
    this.descricao,
    this.tipoVeiculo,
    this.empresa,
  }) : id = const Uuid().v4();

  factory Inspecao.fromJson(Map<String, dynamic> json) =>
      _$InspecaoFromJson(json);

  Map<String, dynamic> toJson() => _$InspecaoToJson(this);
}
