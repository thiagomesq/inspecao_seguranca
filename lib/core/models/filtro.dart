import 'package:inspecao_seguranca/core/enums/operator.dart';

class Filtro {
  final String key;
  final Object? value;
  final Iterable<Object>? values;
  final Operator operator;

  Filtro({
    required this.key,
    this.value,
    this.values,
    required this.operator,
  });
}
