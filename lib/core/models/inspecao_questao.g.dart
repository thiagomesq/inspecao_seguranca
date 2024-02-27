// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspecao_questao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspecaoQuestao _$InspecaoQuestaoFromJson(Map<String, dynamic> json) =>
    InspecaoQuestao(
      inspecao: json['inspecao'] as String?,
      questao: json['questao'] as String?,
      ordem: json['ordem'] as int?,
    )..id = json['id'] as String?;

Map<String, dynamic> _$InspecaoQuestaoToJson(InspecaoQuestao instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inspecao': instance.inspecao,
      'questao': instance.questao,
      'ordem': instance.ordem,
    };
