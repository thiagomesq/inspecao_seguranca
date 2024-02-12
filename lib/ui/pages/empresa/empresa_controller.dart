import 'package:inspecao_seguranca/core/models/empresa.dart';
import 'package:inspecao_seguranca/infra/http/services/empresa_service.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:inspecao_seguranca/ui/stores/empresa_store.dart';
import 'package:mobx/mobx.dart';

part 'empresa_controller.g.dart';

class EmpresaController = EmpresaControllerBase with _$EmpresaController;

abstract class EmpresaControllerBase extends ControllerBase with Store {
  final EmpresaService _empresaService;
  final EmpresaStore _empresaStore;

  EmpresaControllerBase(
    this._empresaService,
    this._empresaStore,
  );

  @observable
  String? cnpj;

  @observable
  String? nomeFantasia;

  @observable
  String? email;

  @computed
  bool get isFormValid => cnpj != null && nomeFantasia != null && email != null;

  @action
  Future<void> save() async {
    final empresa = Empresa(
      cnpj: cnpj!,
      nomeFantasia: nomeFantasia!,
      email: email!,
    );
    await _empresaService.saveEmpresa(empresa);
    _empresaStore.setEmpresa(empresa);
  }
}
