class FinalidadeVeiculo {
  final String nome;

  FinalidadeVeiculo({required this.nome});

  factory FinalidadeVeiculo.fromMap(Map data) {
    return FinalidadeVeiculo(
      nome: data['nome'] ?? '',
    );
  }
}
