class RespostaVeiculo {
  final int idQuestao;
  final String questao;
  String? opcao;
  final String data;
  final String veiculo;
  final String localidade;
  final String condutor;
  final String validadeHabilitacao;
  String? dscNC;

  RespostaVeiculo({
    required this.idQuestao,
    required this.questao,
    this.opcao,
    required this.veiculo,
    required this.data,
    required this.localidade,
    required this.condutor,
    required this.validadeHabilitacao,
    this.dscNC,
  });

  factory RespostaVeiculo.fromMap(Map data) {
    return RespostaVeiculo(
      idQuestao: data['idQuestao'],
      data: data['data'] ?? '',
      opcao: data['opcao'] ?? '1',
      questao: data['questao'] ?? '',
      veiculo: data['veiculo'] ?? '',
      localidade: data['localidade'] ?? '',
      condutor: data['condutor'] ?? '',
      validadeHabilitacao: data['validadeHabilitacao'] ?? '',
      dscNC: data['dscNC'] ?? '',
    );
  }

  void changeOpcao(String opcao) {
    this.opcao = opcao;
  }
}
