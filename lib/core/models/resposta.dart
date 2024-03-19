import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'resposta.g.dart';

@JsonSerializable()
class Resposta {
  String? id;
  bool isOk;
  String? dscNC;
  String? inspecaoQuestao;

  Resposta({
    this.isOk = true,
    this.dscNC,
    this.inspecaoQuestao,
  }) {
    id = const Uuid().v4();
  }

  factory Resposta.fromJson(Map<String, dynamic> json) =>
      _$RespostaFromJson(json);

  Map<String, dynamic> toJson() => _$RespostaToJson(this);
}
