import 'package:inspecao_seguranca/core/models/info_inspecao.dart';
import 'package:inspecao_seguranca/core/models/inspecao.dart';
import 'package:inspecao_seguranca/core/models/inspecao_questao.dart';
import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:inspecao_seguranca/core/models/questao.dart';
import 'package:inspecao_seguranca/core/models/resposta.dart';
import 'package:inspecao_seguranca/core/models/veiculo.dart';
import 'package:inspecao_seguranca/infra/http/services/inspecao_service.dart';
import 'package:inspecao_seguranca/infra/http/services/questao_service.dart';
import 'package:inspecao_seguranca/infra/http/services/resposta_service.dart';
import 'package:inspecao_seguranca/infra/http/services/veiculo_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/inspecao_store.dart';
import 'package:inspecao_seguranca/ui/stores/usuario_store.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mobx/mobx.dart';

part 'resposta_controller.g.dart';

class RespostaController = _RespostaControllerBase with _$RespostaController;

abstract class _RespostaControllerBase extends ControllerBase with Store {
  final RespostaService _respostaService;
  final InspecaoService _inspecaoService;
  final VeiculoService _veiculoService;
  final QuestaoService _questaoService;
  final InspecaoStore _inspecaoStore;
  final UsuarioStore _usuarioStore;

  _RespostaControllerBase(
    this._respostaService,
    this._inspecaoService,
    this._veiculoService,
    this._questaoService,
    this._inspecaoStore,
    this._usuarioStore,
  ) {
    fetch();
  }

  @observable
  ObservableList<Resposta> respostas = ObservableList<Resposta>();

  @observable
  ObservableFuture<ObservableList<InspecaoQuestao>?> inspecaoQuestoesLoading =
      ObservableFuture.value(null);

  @observable
  ObservableList<InspecaoQuestao>? inspecaoQuestoes;

  @observable
  ObservableList<Questao> questoes = <Questao>[].asObservable();

  @observable
  ObservableList<Veiculo> veiculos = <Veiculo>[].asObservable();

  @observable
  InfoInspecao? infoInspecao;

  @observable
  String? placa;

  @observable
  String? data;

  @observable
  ObservableList<bool> isOks = <bool>[].asObservable();

  @observable
  ObservableList<String> dscNCs = <String>[].asObservable();

  @computed
  Inspecao get inspecao => _inspecaoStore.inspecao!;

  @computed
  ISUsuario get usuario => _usuarioStore.usuario!;

  @computed
  bool get isFormValid {
    if (placa == null) {
      return false;
    } else if (isOks.any((e) => e == false)) {
      for (var isOk in isOks) {
        if (!isOk) {
          return dscNCs[isOks.indexOf(isOk)].isNotEmpty;
        }
      }
      return false;
    }
    return true;
  }

  @action
  Future<void> fetch() async {
    data = DateFormat('dd/MM/yyyy').format(DateTime.now());
    inspecaoQuestoesLoading =
        _inspecaoService.getInspecaoQuestoes(inspecao.id!).asObservable();
    inspecaoQuestoes = await inspecaoQuestoesLoading;
    inspecaoQuestoes!.sort((a, b) => a.ordem!.compareTo(b.ordem!));
    for (var inspecaoQuestao in inspecaoQuestoes!) {
      final questao =
          await _questaoService.getQuestao(inspecaoQuestao.questao!);
      questoes.add(questao);
      final reposta = Resposta(
        isOk: true,
        inspecaoQuestao: inspecaoQuestao.id!,
      );
      respostas.add(reposta);
      isOks.add(reposta.isOk);
      dscNCs.add(reposta.dscNC ?? '');
      veiculos = await _veiculoService.getVeiculosByTipo(inspecao.tipoVeiculo!);
    }
  }

  @action
  void updateResposta(Resposta resposta, int index) {
    respostas[index] = resposta;
  }

  @action
  Future<void> save() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData locationData = await location.getLocation();
    for (var resposta in respostas) {
      await _respostaService.saveResposta(resposta);
    }
    infoInspecao = InfoInspecao(
      inspecao: inspecao.id!,
      veiculo: placa!,
      inspetor: usuario.id!,
      respostas: respostas.map((e) => e.id!).toList(),
      data: DateTime.now(),
      latitude: locationData.latitude,
      longitude: locationData.longitude,
    );
    await _inspecaoService.saveInfoInspecao(infoInspecao!);
  }
}
