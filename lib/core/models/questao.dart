import 'package:json_annotation/json_annotation.dart';

part 'questao.g.dart';

@JsonSerializable()
class Questao {
  String? id;
  int? ordem;
  String? nome;
  String? questaoGrupo;

  Questao({this.id, this.ordem, this.nome, this.questaoGrupo});

  factory Questao.fromJson(Map<String, dynamic> json) =>
      _$QuestaoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestaoToJson(this);
}
