class RespostaCampo {
  final int idQuestao;
  final String questao;
  String? opcao;
  final String data;
  final String empresa;
  final String localidade;
  String? dscNC;

  RespostaCampo({
    required this.idQuestao,
    required this.questao,
    this.opcao,
    required this.empresa,
    required this.data,
    required this.localidade,
    this.dscNC,
  });

  factory RespostaCampo.fromMap(Map data) {
    return RespostaCampo(
      idQuestao: data['idQuestao'],
      data: data['data'] ?? '',
      opcao: data['opcao'] ?? '1',
      questao: data['questao'] ?? '',
      empresa: data['empresa'] ?? '',
      localidade: data['localidade'] ?? '',
      dscNC: data['dscNC'] ?? '',
    );
  }

  void changeOpcao(String opcao) {
    this.opcao = opcao;
  }
}
