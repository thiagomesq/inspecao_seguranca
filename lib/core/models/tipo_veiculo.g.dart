// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipo_veiculo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TipoVeiculo _$TipoVeiculoFromJson(Map<String, dynamic> json) => TipoVeiculo(
      nome: json['nome'] as String?,
    )..id = json['id'] as String?;

Map<String, dynamic> _$TipoVeiculoToJson(TipoVeiculo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
    };
