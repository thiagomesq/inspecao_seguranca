import 'package:inspecao_seguranca/core/enums/user_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'is_usuario.g.dart';

@JsonSerializable()
class ISUsuario {
  String? id;
  String? username;
  UserType? type;
  String? empresa;

  ISUsuario({
    this.id,
    this.username,
    this.type,
    this.empresa,
  });

  factory ISUsuario.fromJson(Map<String, dynamic> json) =>
      _$ISUsuarioFromJson(json);

  Map<String, dynamic> toJson() => _$ISUsuarioToJson(this);
}
