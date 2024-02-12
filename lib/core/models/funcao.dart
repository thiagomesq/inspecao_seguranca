import 'package:json_annotation/json_annotation.dart';

part 'funcao.g.dart';

@JsonSerializable()
class Funcao {
  final String nome;

  Funcao({required this.nome});

  factory Funcao.fromJson(Map<String, dynamic> json) => _$FuncaoFromJson(json);

  Map<String, dynamic> toJson() => _$FuncaoToJson(this);
}
