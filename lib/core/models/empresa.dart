import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'empresa.g.dart';

@JsonSerializable()
class Empresa {
  String? id;
  String? cnpj;
  String? nomeFantasia;
  String? email;

  Empresa({
    this.nomeFantasia,
    this.cnpj,
    this.email,
  }) : id = const Uuid().v4();

  factory Empresa.fromJson(Map<String, dynamic> json) =>
      _$EmpresaFromJson(json);

  Map<String, dynamic> toJson() => _$EmpresaToJson(this);
}
