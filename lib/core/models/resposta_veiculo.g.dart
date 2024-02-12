// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resposta_veiculo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RespostaVeiculo _$RespostaVeiculoFromJson(Map<String, dynamic> json) =>
    RespostaVeiculo(
      idQuestao: json['idQuestao'] as int,
      questao: json['questao'] as String,
      opcao: json['opcao'] as String?,
      veiculo: json['veiculo'] as String,
      data: json['data'] as String,
      localidade: json['localidade'] as String,
      condutor: json['condutor'] as String,
      validadeHabilitacao: json['validadeHabilitacao'] as String,
      dscNC: json['dscNC'] as String?,
    );

Map<String, dynamic> _$RespostaVeiculoToJson(RespostaVeiculo instance) =>
    <String, dynamic>{
      'idQuestao': instance.idQuestao,
      'questao': instance.questao,
      'opcao': instance.opcao,
      'data': instance.data,
      'veiculo': instance.veiculo,
      'localidade': instance.localidade,
      'condutor': instance.condutor,
      'validadeHabilitacao': instance.validadeHabilitacao,
      'dscNC': instance.dscNC,
    };
