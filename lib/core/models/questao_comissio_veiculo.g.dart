// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao_comissio_veiculo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestaoComissioVeiculo _$QuestaoComissioVeiculoFromJson(
        Map<String, dynamic> json) =>
    QuestaoComissioVeiculo(
      id: json['id'] as int,
      nome: json['nome'] as String,
      para: (json['para'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$QuestaoComissioVeiculoToJson(
        QuestaoComissioVeiculo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'para': instance.para,
    };
