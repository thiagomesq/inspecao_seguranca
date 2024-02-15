// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspecao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inspecao _$InspecaoFromJson(Map<String, dynamic> json) => Inspecao(
      nome: json['nome'] as String?,
      descricao: json['descricao'] as String?,
    )..id = json['id'] as String?;

Map<String, dynamic> _$InspecaoToJson(Inspecao instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'descricao': instance.descricao,
    };
