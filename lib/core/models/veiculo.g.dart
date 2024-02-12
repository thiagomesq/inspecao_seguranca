// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veiculo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Veiculo _$VeiculoFromJson(Map<String, dynamic> json) => Veiculo(
      ano: json['ano'] as int?,
      empresa: json['empresa'] as String?,
      registro: json['registro'] as String?,
      placa: json['placa'] as String?,
      tipo: json['tipo'] as String?,
      laudo: json['laudo'] as bool?,
      finalidade: json['finalidade'] as String?,
    );

Map<String, dynamic> _$VeiculoToJson(Veiculo instance) => <String, dynamic>{
      'placa': instance.placa,
      'ano': instance.ano,
      'tipo': instance.tipo,
      'empresa': instance.empresa,
      'registro': instance.registro,
      'laudo': instance.laudo,
      'finalidade': instance.finalidade,
    };
