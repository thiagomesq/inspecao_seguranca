// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resposta_campo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RespostaCampo _$RespostaCampoFromJson(Map<String, dynamic> json) =>
    RespostaCampo(
      idQuestao: json['idQuestao'] as int,
      questao: json['questao'] as String,
      opcao: json['opcao'] as String?,
      empresa: json['empresa'] as String,
      data: json['data'] as String,
      localidade: json['localidade'] as String,
      dscNC: json['dscNC'] as String?,
    );

Map<String, dynamic> _$RespostaCampoToJson(RespostaCampo instance) =>
    <String, dynamic>{
      'idQuestao': instance.idQuestao,
      'questao': instance.questao,
      'opcao': instance.opcao,
      'data': instance.data,
      'empresa': instance.empresa,
      'localidade': instance.localidade,
      'dscNC': instance.dscNC,
    };
