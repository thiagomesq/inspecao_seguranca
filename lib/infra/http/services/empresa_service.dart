import 'package:inspecao_seguranca/core/models/empresa.dart';
import 'package:inspecao_seguranca/infra/http/services/firestore_service.dart';

class EmpresaService {
  final FirestoreService _firestoreService;
  final collection = 'empresa';

  EmpresaService(this._firestoreService);

  Future<Empresa> getEmpresa(String id) async {
    final doc = await _firestoreService.getDataById(collection, id);
    return Empresa.fromJson(doc);
  }

  Future<List<Empresa>> getEmpresas() async {
    final list = await _firestoreService.getData(collection);
    return list.map((doc) => Empresa.fromJson(doc)).toList();
  }

  Future<void> saveEmpresa(Empresa empresa) async {
    await _firestoreService.saveData(
      collection,
      empresa.toJson(),
      empresa.id!,
    );
  }

  Future<void> deleteEmpresa(String id) async {
    await _firestoreService.deleteData(collection, id);
  }
}
