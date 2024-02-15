import 'package:inspecao_seguranca/core/models/tipo_veiculo.dart';
import 'package:inspecao_seguranca/infra/http/services/firestore_service.dart';
import 'package:mobx/mobx.dart';

class TipoVeiculoService {
  final FirestoreService _firestoreService;
  final collection = 'tipoVeiculo';

  TipoVeiculoService(this._firestoreService);

  Future<TipoVeiculo> getTipoVeiculo(String id) async {
    final doc = await _firestoreService.getDataById(collection, id);
    return TipoVeiculo.fromJson(doc);
  }

  Future<ObservableList<TipoVeiculo>> getTipoVeiculos() async {
    final list = await _firestoreService.getData(collection);
    return list.map((doc) => TipoVeiculo.fromJson(doc)).toList().asObservable();
  }

  Future<String> saveTipoVeiculo(TipoVeiculo tipoVeiculo) async {
    return await _firestoreService.saveData(
      collection,
      tipoVeiculo.toJson(),
      tipoVeiculo.id!,
    );
  }

  Future<String> deleteTipoVeiculo(String id) async {
    return await _firestoreService.deleteData(collection, id);
  }
}
