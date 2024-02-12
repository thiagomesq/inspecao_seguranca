import 'package:json_annotation/json_annotation.dart';

part 'unidade.g.dart';

@JsonSerializable()
class Unidade {
  final String nome;

  Unidade({required this.nome});

  factory Unidade.fromJson(Map<String, dynamic> json) =>
      _$UnidadeFromJson(json);

  Map<String, dynamic> toJson() => _$UnidadeToJson(this);
}
