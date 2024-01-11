class TipoVeiculo {
  final String nome;

  TipoVeiculo({required this.nome});

  factory TipoVeiculo.fromMap(Map data) {
    return TipoVeiculo(
      nome: data['nome'] ?? '',
    );
  }
}
