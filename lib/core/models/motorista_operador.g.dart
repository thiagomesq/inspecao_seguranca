// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motorista_operador.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MotoristaOperador _$MotoristaOperadorFromJson(Map<String, dynamic> json) =>
    MotoristaOperador(
      nome: json['nome'] as String?,
      funcao: json['funcao'] as String?,
      cnh: json['cnh'] as String?,
      categoria: json['categoria'] as String?,
      validade: json['validade'] as String?,
    );

Map<String, dynamic> _$MotoristaOperadorToJson(MotoristaOperador instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'funcao': instance.funcao,
      'cnh': instance.cnh,
      'categoria': instance.categoria,
      'validade': instance.validade,
    };
