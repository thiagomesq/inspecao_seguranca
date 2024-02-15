import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'tipo_veiculo.g.dart';

@JsonSerializable()
class TipoVeiculo {
  String? id;
  String? nome;

  TipoVeiculo({this.nome}) : id = const Uuid().v4();

  factory TipoVeiculo.fromJson(Map<String, dynamic> json) =>
      _$TipoVeiculoFromJson(json);

  Map<String, dynamic> toJson() => _$TipoVeiculoToJson(this);
}
