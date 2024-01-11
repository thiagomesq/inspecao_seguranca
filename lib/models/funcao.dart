class Funcao {
  final String nome;

  Funcao({required this.nome});

  factory Funcao.fromMap(Map data) {
    return Funcao(
      nome: data['nome'] ?? '',
    );
  }
}
