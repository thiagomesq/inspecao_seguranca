import 'package:json_annotation/json_annotation.dart';

part 'questao_campo.g.dart';

@JsonSerializable()
class QuestaoCampo {
  final int id;
  final String nome;

  QuestaoCampo({required this.id, required this.nome});

  factory QuestaoCampo.fromJson(Map<String, dynamic> json) =>
      _$QuestaoCampoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestaoCampoToJson(this);
}
