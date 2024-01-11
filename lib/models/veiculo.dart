class Veiculo {
  final String? placa;
  final int? ano;
  final String? tipo;
  final String? empresa;
  final String? registro;
  final bool? laudo;
  final String? finalidade;

  Veiculo({
    this.ano,
    this.empresa,
    this.registro,
    this.placa,
    this.tipo,
    this.laudo,
    this.finalidade,
  });

  factory Veiculo.fromMap(Map data) {
    return Veiculo(
      ano: data['ano'] ?? 0,
      empresa: data['empresa'] ?? '',
      registro: data['registro'] ?? '',
      placa: data['placa'] ?? '',
      tipo: data['tipo'] ?? '',
      laudo: data['laudo'] ?? false,
      finalidade: data['finalidade'] ?? '',
    );
  }
}
