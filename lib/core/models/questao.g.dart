// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Questao _$QuestaoFromJson(Map<String, dynamic> json) => Questao(
      ordem: json['ordem'] as int?,
      nome: json['nome'] as String?,
      inspecoes: (json['inspecoes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tipoVeiculos: (json['tipoVeiculos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )..id = json['id'] as String?;

Map<String, dynamic> _$QuestaoToJson(Questao instance) => <String, dynamic>{
      'id': instance.id,
      'ordem': instance.ordem,
      'nome': instance.nome,
      'inspecoes': instance.inspecoes,
      'tipoVeiculos': instance.tipoVeiculos,
    };
