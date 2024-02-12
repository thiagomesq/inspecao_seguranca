// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resposta_comissio_veiculo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RespostaComissioVeiculo _$RespostaComissioVeiculoFromJson(
        Map<String, dynamic> json) =>
    RespostaComissioVeiculo(
      idQuestao: json['idQuestao'] as int,
      questao: json['questao'] as String,
      opcao: json['opcao'] as String?,
      veiculo: json['veiculo'] as String,
      data: json['data'] as String,
      dscNC: json['dscNC'] as String?,
    );

Map<String, dynamic> _$RespostaComissioVeiculoToJson(
        RespostaComissioVeiculo instance) =>
    <String, dynamic>{
      'idQuestao': instance.idQuestao,
      'questao': instance.questao,
      'opcao': instance.opcao,
      'data': instance.data,
      'veiculo': instance.veiculo,
      'dscNC': instance.dscNC,
    };
