class MotoristaOperador {
  final String? nome;
  final String? funcao;
  final String? cnh;
  final String? categoria;
  final String? validade;

  MotoristaOperador({
    this.nome,
    this.funcao,
    this.cnh,
    this.categoria,
    this.validade,
  });

  factory MotoristaOperador.fromMap(Map data) {
    return MotoristaOperador(
      nome: data['nome'] ?? '',
      funcao: data['funcao'] ?? '',
      cnh: data['cnh'] ?? '',
      categoria: data['categoria'] ?? '',
      validade: data['validade'] ?? '',
    );
  }
}
