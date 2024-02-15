import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'questao.g.dart';

@JsonSerializable()
class Questao {
  String? id;
  int? ordem;
  String? nome;
  List<String>? inspecoes;
  List<String>? tipoVeiculos;

  Questao({this.ordem, this.nome, this.inspecoes, this.tipoVeiculos})
      : id = const Uuid().v4();

  factory Questao.fromJson(Map<String, dynamic> json) =>
      _$QuestaoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestaoToJson(this);
}
