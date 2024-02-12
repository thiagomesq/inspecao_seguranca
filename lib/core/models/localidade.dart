import 'package:json_annotation/json_annotation.dart';

part 'localidade.g.dart';

@JsonSerializable()
class Localidade {
  final String nome;

  Localidade({required this.nome});

  factory Localidade.fromJson(Map<String, dynamic> json) =>
      _$LocalidadeFromJson(json);

  Map<String, dynamic> toJson() => _$LocalidadeToJson(this);
}
