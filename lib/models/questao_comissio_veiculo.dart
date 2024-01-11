class QuestaoComissioVeiculo {
  final int id;
  final String nome;
  final List<String> para;

  QuestaoComissioVeiculo({required this.id, required this.nome, required this.para});

  factory QuestaoComissioVeiculo.fromMap(Map data) {
    return QuestaoComissioVeiculo(
      id: data['id'],
      nome: data['nome'],
      para: List.from(data['para']),
    );
  }
}
