import 'package:inspecao_seguranca/core/models/questao.dart';
import 'package:inspecao_seguranca/infra/http/services/firestore_service.dart';
import 'package:mobx/mobx.dart';

class QuestaoService {
  final FirestoreService _firestoreService;
  final collection = 'questao';

  QuestaoService(this._firestoreService);

  Future<Questao> getQuestao(String id) async {
    final data = await _firestoreService.getDataById(collection, id);
    return Questao.fromJson(data);
  }

  Future<ObservableList<Questao>> getQuestoes() async {
    final list = await _firestoreService.getData(collection);
    return list.map((doc) => Questao.fromJson(doc)).toList().asObservable();
  }

  Future<void> saveQuestao(Questao questao) async {
    await _firestoreService.saveData(
      collection,
      questao.toJson(),
      questao.id!,
    );
  }

  Future<void> deleteQuestao(String id) async {
    await _firestoreService.deleteData(collection, id);
  }
}
