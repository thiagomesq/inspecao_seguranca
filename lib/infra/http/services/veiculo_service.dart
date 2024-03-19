import 'package:inspecao_seguranca/core/models/veiculo.dart';
import 'package:inspecao_seguranca/infra/http/services/firestore_service.dart';
import 'package:mobx/mobx.dart';

class VeiculoService {
  final FirestoreService _firestoreService;
  final collection = 'veiculo';

  VeiculoService(this._firestoreService);

  Future<Veiculo> getVeiculo(String placa) async {
    final doc = await _firestoreService.getDataById(collection, placa);
    return Veiculo.fromJson(doc);
  }

  Future<ObservableList<Veiculo>> getVeiculos() async {
    final list = await _firestoreService.getData(collection);
    return list.map((doc) => Veiculo.fromJson(doc)).toList().asObservable();
  }

  Future<ObservableList<Veiculo>> getVeiculosByTipoVeiculo(
      String tipoVeiculo) async {
    final list = await _firestoreService.getDataByField(
      collection,
      'tipo',
      tipoVeiculo,
    );
    return list.map((doc) => Veiculo.fromJson(doc)).toList().asObservable();
  }

  Future<String> saveVeiculo(Veiculo veiculo) async {
    return await _firestoreService.saveData(
      collection,
      veiculo.toJson(),
      veiculo.placa!,
    );
  }

  Future<String> deleteVeiculo(String placa) async {
    return await _firestoreService.deleteData(collection, placa);
  }
}
