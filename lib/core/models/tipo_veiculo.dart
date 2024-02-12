import 'package:json_annotation/json_annotation.dart';

part 'tipo_veiculo.g.dart';

@JsonSerializable()
class TipoVeiculo {
  String? id;
  String? nome;

  TipoVeiculo({this.id, this.nome});

  factory TipoVeiculo.fromJson(Map<String, dynamic> json) =>
      _$TipoVeiculoFromJson(json);

  Map<String, dynamic> toJson() => _$TipoVeiculoToJson(this);
}
