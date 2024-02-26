// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Questao _$QuestaoFromJson(Map<String, dynamic> json) => Questao(
      titulo: json['titulo'] as String?,
      tiposVeiculo: (json['tiposVeiculo'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )..id = json['id'] as String?;

Map<String, dynamic> _$QuestaoToJson(Questao instance) => <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'tiposVeiculo': instance.tiposVeiculo,
    };
