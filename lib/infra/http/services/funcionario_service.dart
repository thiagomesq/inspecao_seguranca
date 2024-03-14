import 'package:inspecao_seguranca/core/models/funcionario.dart';
import 'package:inspecao_seguranca/infra/http/services/firestore_service.dart';
import 'package:mobx/mobx.dart';

class FuncionarioService {
  final FirestoreService _firestoreService;
  final collection = 'funcionario';

  FuncionarioService(this._firestoreService);

  Future<Funcionario> getFuncionario(String id) async {
    final doc = await _firestoreService.getDataById(collection, id);
    return Funcionario.fromJson(doc);
  }

  Future<Funcionario> getFuncionarioByPhone(String phone) async {
    final doc =
        await _firestoreService.getDataByField(collection, 'telefone', phone);
    return Funcionario.fromJson(doc.first);
  }

  Future<ObservableList<Funcionario>> getFuncionarios(String empresa) async {
    final list =
        await _firestoreService.getDataByField(collection, 'empresa', empresa);
    return list.map((doc) => Funcionario.fromJson(doc)).toList().asObservable();
  }

  Future<void> saveFuncionario(Funcionario funcionario) async {
    await _firestoreService.saveData(
      collection,
      funcionario.toJson(),
      funcionario.id!,
    );
  }

  Future<void> deleteFuncionario(String id) async {
    await _firestoreService.deleteData(collection, id);
  }
}
