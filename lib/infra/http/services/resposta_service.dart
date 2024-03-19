import 'package:inspecao_seguranca/core/models/resposta.dart';
import 'package:inspecao_seguranca/infra/http/services/firestore_service.dart';
import 'package:mobx/mobx.dart';

class RespostaService {
  final FirestoreService _firestoreService;
  final collection = 'resposta';

  RespostaService(this._firestoreService);

  Future<ObservableList<Resposta>> getRespostas() async {
    final list = await _firestoreService.getData(collection);
    return list.map((doc) => Resposta.fromJson(doc)).toList().asObservable();
  }

  Future<Resposta> getResposta(String id) async {
    final doc = await _firestoreService.getDataById(collection, id);
    return Resposta.fromJson(doc);
  }

  Future<void> saveResposta(Resposta resposta) async {
    await _firestoreService.saveData(
      collection,
      resposta.toJson(),
      resposta.id!,
    );
  }

  Future<void> deleteResposta(String id) async {
    await _firestoreService.deleteData(collection, id);
  }
}
