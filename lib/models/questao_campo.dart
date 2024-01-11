class QuestaoCampo {
  final int id;
  final String nome;

  QuestaoCampo({required this.id, required this.nome});

  factory QuestaoCampo.fromMap(Map data) {
    return QuestaoCampo(
      id: data['id'],
      nome: data['nome'],
    );
  }
}
