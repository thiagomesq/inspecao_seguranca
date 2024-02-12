// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao_veiculo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestaoVeiculo _$QuestaoVeiculoFromJson(Map<String, dynamic> json) =>
    QuestaoVeiculo(
      id: json['id'] as int,
      nome: json['nome'] as String,
      para: (json['para'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$QuestaoVeiculoToJson(QuestaoVeiculo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'para': instance.para,
    };
