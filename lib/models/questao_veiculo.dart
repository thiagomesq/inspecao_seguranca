class QuestaoVeiculo {
  final int id;
  final String nome;
  final List<String> para;

  QuestaoVeiculo({required this.id, required this.nome, required this.para});

  factory QuestaoVeiculo.fromMap(Map data) {
    return QuestaoVeiculo(
      id: data['id'],
      nome: data['nome'],
      para: List.from(data['para']),
    );
  }
}
