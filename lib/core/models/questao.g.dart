// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Questao _$QuestaoFromJson(Map<String, dynamic> json) => Questao(
      id: json['id'] as String?,
      ordem: json['ordem'] as int?,
      nome: json['nome'] as String?,
      questaoGrupo: json['questaoGrupo'] as String?,
    );

Map<String, dynamic> _$QuestaoToJson(Questao instance) => <String, dynamic>{
      'id': instance.id,
      'ordem': instance.ordem,
      'nome': instance.nome,
      'questaoGrupo': instance.questaoGrupo,
    };
