// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veiculo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Veiculo _$VeiculoFromJson(Map<String, dynamic> json) => Veiculo(
      placa: json['placa'] as String?,
      ano: json['ano'] as int?,
      tipo: json['tipo'] as String?,
      empresa: json['empresa'] as String?,
      finalidade: json['finalidade'] as String?,
    );

Map<String, dynamic> _$VeiculoToJson(Veiculo instance) => <String, dynamic>{
      'placa': instance.placa,
      'ano': instance.ano,
      'tipo': instance.tipo,
      'empresa': instance.empresa,
      'finalidade': instance.finalidade,
    };
