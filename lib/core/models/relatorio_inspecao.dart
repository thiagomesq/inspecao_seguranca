import 'package:inspecao_seguranca/core/models/resposta.dart';

class RelatorioInspecao {
  final String inspecao;
  final String data;
  final String latitude;
  final String longitude;
  final String inspetor;
  final String veiculo;
  final List<String> questoes;
  final List<Resposta> respostas;

  RelatorioInspecao({
    required this.inspecao,
    required this.data,
    required this.latitude,
    required this.longitude,
    required this.inspetor,
    required this.veiculo,
    required this.questoes,
    required this.respostas,
  });
}
