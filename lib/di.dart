import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/infra/http/services/auth_service.dart';
import 'package:inspecao_seguranca/infra/http/services/empresa_service.dart';
import 'package:inspecao_seguranca/infra/http/services/firebase_service.dart';
import 'package:inspecao_seguranca/infra/http/services/firestore_service.dart';
import 'package:inspecao_seguranca/infra/http/services/funcionario_service.dart';
import 'package:inspecao_seguranca/infra/http/services/inspecao_service.dart';
import 'package:inspecao_seguranca/infra/http/services/pdf_service.dart';
import 'package:inspecao_seguranca/infra/http/services/questao_service.dart';
import 'package:inspecao_seguranca/infra/http/services/resposta_service.dart';
import 'package:inspecao_seguranca/infra/http/services/tipo_veiculo_service.dart';
import 'package:inspecao_seguranca/infra/http/services/user_service.dart';
import 'package:inspecao_seguranca/infra/http/services/veiculo_service.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_funcionario_store.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_inspecao_store.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_questao_store.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_tipo_veiculo_store.dart';
import 'package:inspecao_seguranca/ui/stores/cadastro_veiculo_store.dart';
import 'package:inspecao_seguranca/ui/stores/empresa_store.dart';
import 'package:inspecao_seguranca/ui/stores/inspecao_store.dart';
import 'package:inspecao_seguranca/ui/stores/usuario_store.dart';

final i = GetIt.I;

Future<void> configureDI() async {
  i.registerSingletonAsync<FirebaseService>(() => FirebaseService.init());

  i.registerLazySingleton(() => FirestoreService());
  //i.registerSingletonAsync<Env>(() => Env.init());
  i.registerLazySingleton(() => AuthService());
  i.registerLazySingleton(() => PdfService());

  i.registerLazySingleton<UsuarioStore>(() => UsuarioStore());
  i.registerLazySingleton<EmpresaStore>(() => EmpresaStore());
  i.registerLazySingleton<InspecaoStore>(() => InspecaoStore());
  i.registerLazySingleton<CadastroInspecaoStore>(() => CadastroInspecaoStore());
  i.registerLazySingleton<CadastroTipoVeiculoStore>(
    () => CadastroTipoVeiculoStore(),
  );
  i.registerLazySingleton<CadastroQuestaoStore>(() => CadastroQuestaoStore());
  i.registerLazySingleton<CadastroVeiculoStore>(() => CadastroVeiculoStore());
  i.registerLazySingleton<CadastroFuncionarioStore>(
      () => CadastroFuncionarioStore());

  configureFirestoreServices();

  return await i.allReady();
}

void configureFirestoreServices() {
  i.registerLazySingleton(() => UserService(i()));
  i.registerLazySingleton(() => EmpresaService(i()));
  i.registerLazySingleton(() => QuestaoService(i()));
  i.registerLazySingleton(() => InspecaoService(i()));
  i.registerLazySingleton(() => TipoVeiculoService(i()));
  i.registerLazySingleton(() => VeiculoService(i()));
  i.registerLazySingleton(() => FuncionarioService(i()));
  i.registerLazySingleton(() => RespostaService(i()));
}
