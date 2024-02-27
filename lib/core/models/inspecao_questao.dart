import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'inspecao_questao.g.dart';

@JsonSerializable()
class InspecaoQuestao {
  String? id;
  String? inspecao;
  String? questao;
  int? ordem;

  InspecaoQuestao({
    this.inspecao,
    this.questao,
    this.ordem,
  }) : id = const Uuid().v4();

  factory InspecaoQuestao.fromJson(Map<String, dynamic> json) =>
      _$InspecaoQuestaoFromJson(json);

  Map<String, dynamic> toJson() => _$InspecaoQuestaoToJson(this);
}
