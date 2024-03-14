import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'funcionario.g.dart';

@JsonSerializable()
class Funcionario {
  String? id;
  String? nome;
  String? telefone;
  String? empresa;
  String? usuario;

  Funcionario({
    this.id,
    this.nome,
    this.telefone,
    this.empresa,
    this.usuario,
  }) {
    id ??= const Uuid().v4();
  }

  factory Funcionario.fromJson(Map<String, dynamic> json) =>
      _$FuncionarioFromJson(json);

  Map<String, dynamic> toJson() => _$FuncionarioToJson(this);
}
