import 'package:inspecao_seguranca/core/models/inspecao.dart';
import 'package:inspecao_seguranca/core/models/inspecao_questao.dart';
import 'package:inspecao_seguranca/infra/http/services/firestore_service.dart';
import 'package:mobx/mobx.dart';

class InspecaoService {
  final FirestoreService _firestoreService;
  final collection = 'inspecao';
  final collection2 = 'inspecao_questao';

  InspecaoService(this._firestoreService);

  Future<Inspecao> getInspecao(String id) async {
    final doc = await _firestoreService.getDataById(collection, id);
    return Inspecao.fromJson(doc);
  }

  Future<ObservableList<Inspecao>> getInspecaos() async {
    final list = await _firestoreService.getData(collection);
    return list.map((doc) => Inspecao.fromJson(doc)).toList().asObservable();
  }

  Future<ObservableList<InspecaoQuestao>> getInspecaoQuestoes(
      String inspecaoId) async {
    final list = await _firestoreService.getDataByField(
      collection2,
      'inspecao',
      inspecaoId,
    );
    return list
        .map((doc) => InspecaoQuestao.fromJson(doc))
        .toList()
        .asObservable();
  }

  Future<void> saveInspecao(Inspecao inspecao) async {
    await _firestoreService.saveData(
      collection,
      inspecao.toJson(),
      inspecao.id!,
    );
  }

  Future<void> saveInspecaoQuestao(InspecaoQuestao inspecaoQuestao) async {
    await _firestoreService.saveData(
      collection2,
      inspecaoQuestao.toJson(),
      inspecaoQuestao.id!,
    );
  }

  Future<void> deleteInspecao(String id) async {
    await _firestoreService.deleteData(collection, id);
    await _firestoreService.deleteDataByField(collection2, 'inspecao', id);
  }
}
