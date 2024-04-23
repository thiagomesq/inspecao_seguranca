import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:inspecao_seguranca/infra/http/services/firestore_service.dart';
import 'package:mobx/mobx.dart';

class UserService {
  final FirestoreService _firestoreService;
  final collection = 'usuarios';

  UserService(this._firestoreService);

  Future<ISUsuario> getUser(String id) async {
    final doc = await _firestoreService.getDataById(collection, id);
    return ISUsuario.fromJson(doc);
  }

  Future<ObservableList<ISUsuario>> getUsers() async {
    final list = await _firestoreService.getData(collection);
    return list.map((doc) => ISUsuario.fromJson(doc)).toList().asObservable();
  }

  Future<ObservableList<ISUsuario>> getUsersByEmpresa(String empresa) async {
    final list =
        await _firestoreService.getDataByField(collection, 'empresa', empresa);
    return list.map((doc) => ISUsuario.fromJson(doc)).toList().asObservable();
  }

  Future<String> saveUser(ISUsuario user) async {
    return await _firestoreService.saveData(
      collection,
      user.toJson(),
      user.id!,
    );
  }

  Future<String> deleteUser(String id) async {
    return await _firestoreService.deleteData(collection, id);
  }
}
