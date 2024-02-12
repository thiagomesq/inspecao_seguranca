import 'package:inspecao_seguranca/infra/http/services/firestore_service.dart';

class QuestoesService {
  final FirestoreService _firestoreService;
  final collection = 'questoes';

  QuestoesService(this._firestoreService);
}
