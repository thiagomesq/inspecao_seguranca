// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'is_usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ISUsuario _$ISUsuarioFromJson(Map<String, dynamic> json) => ISUsuario(
      id: json['id'] as String?,
      username: json['username'] as String?,
      type: $enumDecodeNullable(_$UserTypeEnumMap, json['type']),
      empresa: json['empresa'] as String?,
    );

Map<String, dynamic> _$ISUsuarioToJson(ISUsuario instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'type': _$UserTypeEnumMap[instance.type],
      'empresa': instance.empresa,
    };

const _$UserTypeEnumMap = {
  UserType.master: 'master',
  UserType.admin: 'admin',
  UserType.user: 'user',
};
