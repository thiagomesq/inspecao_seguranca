import 'package:inspecao_seguranca/core/models/info_inspecao.dart';
import 'package:inspecao_seguranca/core/models/inspecao.dart';
import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:inspecao_seguranca/core/models/questao.dart';
import 'package:inspecao_seguranca/core/models/relatorio_inspecao.dart';
import 'package:inspecao_seguranca/core/models/resposta.dart';
import 'package:inspecao_seguranca/core/models/veiculo.dart';
import 'package:inspecao_seguranca/infra/http/services/inspecao_service.dart';
import 'package:inspecao_seguranca/infra/http/services/pdf_service.dart';
import 'package:inspecao_seguranca/infra/http/services/questao_service.dart';
import 'package:inspecao_seguranca/infra/http/services/resposta_service.dart';
import 'package:inspecao_seguranca/infra/http/services/user_service.dart';
import 'package:inspecao_seguranca/infra/http/services/veiculo_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/usuario_store.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

part 'inspecao_controller.g.dart';

class InspecaoController = _InspecaoControllerBase with _$InspecaoController;

abstract class _InspecaoControllerBase extends ControllerBase with Store {
  final InspecaoService _inspecaoService;
  final QuestaoService _questaoService;
  final RespostaService _respostaService;
  final UserService _userService;
  final VeiculoService _veiculoService;
  final PdfService _pdfService;
  final UsuarioStore _usuarioStore;

  _InspecaoControllerBase(
    this._inspecaoService,
    this._questaoService,
    this._respostaService,
    this._userService,
    this._veiculoService,
    this._pdfService,
    this._usuarioStore,
  ) {
    fetch();
  }

  @observable
  ObservableFuture<ObservableList<Inspecao>> inspecoesLoading =
      ObservableFuture.value(<Inspecao>[].asObservable());

  @observable
  ObservableList<Inspecao> inspecoes = <Inspecao>[].asObservable();

  @observable
  ObservableList<InfoInspecao> infoInspecoes = <InfoInspecao>[].asObservable();

  @observable
  List<Questao> questoes = [];

  @observable
  List<Resposta> respostas = [];

  @observable
  ObservableList<ISUsuario> usuarios = <ISUsuario>[].asObservable();

  @observable
  ObservableList<Veiculo> veiculos = <Veiculo>[].asObservable();

  @observable
  String inspecao = '';

  @observable
  String usuario = '';

  @observable
  String data = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @observable
  String veiculo = '';

  @computed
  ISUsuario get usuarioLogado => _usuarioStore.usuario!;

  @computed
  bool get isFormValid =>
      inspecao.isNotEmpty &&
      usuario.isNotEmpty &&
      veiculo.isNotEmpty &&
      data.isNotEmpty;

  @action
  Future<void> fetch() async {
    usuarios = await _userService
        .getUsersByEmpresa(usuarioLogado.empresa!)
        .asObservable();
    inspecoesLoading = _inspecaoService.getInspecaos().asObservable();
    inspecoes = await inspecoesLoading;
  }

  @action
  Future<void> getVeiculos() async {
    infoInspecoes = await _inspecaoService.getInfoInspecoesByInspetor(
      inspecao,
      usuario,
      DateFormat('dd/MM/yyyy').parse(data),
    );
    for (var info in infoInspecoes) {
      final veiculo = await _veiculoService.getVeiculo(info.veiculo!);
      veiculos.add(veiculo);
    }
    if (veiculos.isNotEmpty) {
      veiculo = veiculos.first.placa!;
    }
  }

  @action
  Future<List<int>> gerarRelatorio() async {
    final i = await _inspecaoService.getInspecao(inspecao);

    final infoInspecao = infoInspecoes.firstWhere(
      (element) =>
          element.veiculo == veiculo &&
          element.inspecao == inspecao &&
          element.inspetor == usuario,
    );

    final inspecaoQuestoes =
        await _inspecaoService.getInspecaoQuestoes(inspecao);
    inspecaoQuestoes.sort((a, b) => a.ordem!.compareTo(b.ordem!));

    for (final r in infoInspecao.respostas!) {
      final resposta = await _respostaService.getResposta(r);
      respostas.add(resposta);
    }

    for (final inspecaoQuestao in inspecaoQuestoes) {
      final questao =
          await _questaoService.getQuestao(inspecaoQuestao.questao!);
      questoes.add(questao);
    }

    final relatorio = RelatorioInspecao(
      inspecao: i.nome!,
      data: DateFormat('dd/MM/yyyy HH:mm:ss').format(infoInspecao.data!),
      latitude: infoInspecao.latitude!.toString(),
      longitude: infoInspecao.longitude!.toString(),
      inspetor: usuarios
          .firstWhere((element) => element.id == infoInspecao.inspetor!)
          .username!,
      veiculo: veiculo,
      questoes: questoes.map((e) => e.titulo!).toList(),
      respostas: respostas,
    );
    final bytes = await _pdfService.relatorioInspecao(relatorio);
    return bytes;
  }
}
