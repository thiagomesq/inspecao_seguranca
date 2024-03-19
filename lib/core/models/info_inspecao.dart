import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'info_inspecao.g.dart';

@JsonSerializable()
class InfoInspecao {
  String? id;
  DateTime? data;
  double? latitude;
  double? longitude;
  String? inspecao;
  String? veiculo;
  String? inspetor;
  List<String>? respostas;

  InfoInspecao({
    this.data,
    this.latitude,
    this.longitude,
    this.inspecao,
    this.veiculo,
    this.inspetor,
    this.respostas,
  }) {
    id = const Uuid().v4();
  }

  factory InfoInspecao.fromJson(Map<String, dynamic> json) =>
      _$InfoInspecaoFromJson(json);

  Map<String, dynamic> toJson() => _$InfoInspecaoToJson(this);
}
