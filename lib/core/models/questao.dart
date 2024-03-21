import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'questao.g.dart';

@JsonSerializable()
class Questao {
  String? id;
  String? titulo;

  Questao({this.titulo}) : id = const Uuid().v4();

  factory Questao.fromJson(Map<String, dynamic> json) =>
      _$QuestaoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestaoToJson(this);
}
