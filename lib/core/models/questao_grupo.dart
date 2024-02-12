import 'package:json_annotation/json_annotation.dart';

part 'questao_grupo.g.dart';

@JsonSerializable()
class QuestaoGrupo {
  String? id;
  String? nome;

  QuestaoGrupo({this.id, this.nome});

  factory QuestaoGrupo.fromJson(Map<String, dynamic> json) =>
      _$QuestaoGrupoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestaoGrupoToJson(this);
}
