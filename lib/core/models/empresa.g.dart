// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empresa.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Empresa _$EmpresaFromJson(Map<String, dynamic> json) => Empresa(
      nomeFantasia: json['nomeFantasia'] as String?,
      cnpj: json['cnpj'] as String?,
      email: json['email'] as String?,
    )..id = json['id'] as String?;

Map<String, dynamic> _$EmpresaToJson(Empresa instance) => <String, dynamic>{
      'id': instance.id,
      'cnpj': instance.cnpj,
      'nomeFantasia': instance.nomeFantasia,
      'email': instance.email,
    };
