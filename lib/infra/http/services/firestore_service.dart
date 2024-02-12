import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inspecao_seguranca/core/enums/operator.dart';
import 'package:inspecao_seguranca/core/models/filtro.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> saveData(
      String collection, Map<String, dynamic> data, String id) async {
    return _db
        .collection(collection)
        .doc(id)
        .set(data)
        .then((value) => 'Success')
        .catchError((error) => error.toString());
  }

  Future<String> saveDataInCollection(
    String collectionOrigin,
    String collectionDestiny,
    String id,
    Map<String, dynamic> data,
    String idDestiny,
  ) async {
    return _db
        .collection(collectionOrigin)
        .doc(id)
        .collection(collectionDestiny)
        .doc(idDestiny)
        .set(data)
        .then((value) => 'Success')
        .catchError((error) => error.toString());
  }

  Future<String> deleteData(
    String collection,
    String id,
  ) async {
    return _db
        .collection(collection)
        .doc(id)
        .delete()
        .then((value) => 'Success')
        .catchError((error) => error.toString());
  }

  Future<String> deleteDataInCollection(
    String collectionOrigin,
    String collectionDestiny,
    String idOrigin,
    String idDestiny,
  ) async {
    return _db
        .collection(collectionOrigin)
        .doc(idOrigin)
        .collection(collectionDestiny)
        .doc(idDestiny)
        .delete()
        .then((value) => 'Success')
        .catchError((error) => error.toString());
  }

  Future<List<Map<String, dynamic>>> getData(
    String collection, {
    List<String>? orderBy,
  }) async {
    List<Map<String, dynamic>> data = [];
    Query<Map<String, dynamic>> query = _db.collection(collection);
    if (orderBy != null) {
      for (var order in orderBy) {
        query = query.orderBy(order);
      }
    }
    await query.get().then((value) {
      for (var element in value.docs) {
        data.add(element.data());
      }
    });
    return data;
  }

  Future<List<Map<String, dynamic>>> getDataInCollection(
    String collectionOrigin,
    String collectionDestiny,
    String id,
  ) async {
    List<Map<String, dynamic>> data = [];
    await _db
        .collection(collectionOrigin)
        .doc(id)
        .collection(collectionDestiny)
        .get()
        .then((value) {
      for (var element in value.docs) {
        data.add(element.data());
      }
    });
    return data;
  }

  Future<Map<String, dynamic>> getDataById(
    String collection,
    String id,
  ) async {
    Map<String, dynamic> data = {};
    await _db.collection(collection).doc(id).get().then((value) {
      data = value.data() ?? {};
    });
    return data;
  }

  Future<Map<String, dynamic>> getDataByIdInCollection(
    String collectionOrigin,
    String collectionDestiny,
    String idOrigin,
    String idDestiny,
  ) async {
    Map<String, dynamic> data = {};
    await _db
        .collection(collectionOrigin)
        .doc(idOrigin)
        .collection(collectionDestiny)
        .doc(idDestiny)
        .get()
        .then((value) {
      data = value.data() ?? {};
    });
    return data;
  }

  Future<List<Map<String, dynamic>>> getDataByFilters(
    String collection,
    List<Filtro> filters, {
    List<String>? orderBy,
  }) async {
    List<Map<String, dynamic>> data = [];
    Query<Map<String, dynamic>> query = _db.collection(collection);
    for (var filter in filters) {
      switch (filter.operator) {
        case Operator.isEqualTo:
          query = query.where(filter.key, isEqualTo: filter.value);
          break;
        case Operator.isNotEqualTo:
          query = query.where(filter.key, isNotEqualTo: filter.value);
          break;
        case Operator.isLessThan:
          query = query.where(filter.key, isLessThan: filter.value);
          break;
        case Operator.isLessThanOrEqualTo:
          query = query.where(filter.key, isLessThanOrEqualTo: filter.value);
          break;
        case Operator.isGreaterThan:
          query = query.where(filter.key, isGreaterThan: filter.value);
          break;
        case Operator.isGreaterThanOrEqualTo:
          query = query.where(filter.key, isGreaterThanOrEqualTo: filter.value);
          break;
        case Operator.arrayContains:
          query = query.where(filter.key, arrayContains: filter.value);
          break;
        case Operator.whereIn:
          query = query.where(filter.key, whereIn: filter.values);
          break;
        case Operator.whereNotIn:
          query = query.where(filter.key, whereNotIn: filter.values);
          break;
        case Operator.arrayContainsAny:
          query = query.where(filter.key, arrayContainsAny: filter.values);
          break;
        case Operator.isNull:
          query = query.where(filter.key, isNull: filter.value == null);
          break;
      }
    }
    if (orderBy != null) {
      for (var order in orderBy) {
        query = query.orderBy(order);
      }
    }
    final result = await query.get();
    for (var element in result.docs) {
      if (element.exists) {
        data.add(element.data());
      }
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> getDataByFiltersInCollection(
    String collectionOrigin,
    String collectionDestiny,
    String id,
    List<Filtro> filters, {
    List<String>? orderBy,
  }) async {
    List<Map<String, dynamic>> data = [];
    Query<Map<String, dynamic>> query =
        _db.collection(collectionOrigin).doc(id).collection(collectionDestiny);
    for (var filter in filters) {
      switch (filter.operator) {
        case Operator.isEqualTo:
          query = query.where(filter.key, isEqualTo: filter.value);
          break;
        case Operator.isNotEqualTo:
          query = query.where(filter.key, isNotEqualTo: filter.value);
          break;
        case Operator.isLessThan:
          query = query.where(filter.key, isLessThan: filter.value);
          break;
        case Operator.isLessThanOrEqualTo:
          query = query.where(filter.key, isLessThanOrEqualTo: filter.value);
          break;
        case Operator.isGreaterThan:
          query = query.where(filter.key, isGreaterThan: filter.value);
          break;
        case Operator.isGreaterThanOrEqualTo:
          query = query.where(filter.key, isGreaterThanOrEqualTo: filter.value);
          break;
        case Operator.arrayContains:
          query = query.where(filter.key, arrayContains: filter.value);
          break;
        case Operator.whereIn:
          query = query.where(filter.key, whereIn: filter.values);
          break;
        case Operator.whereNotIn:
          query = query.where(filter.key, whereNotIn: filter.values);
          break;
        case Operator.arrayContainsAny:
          query = query.where(filter.key, arrayContainsAny: filter.values);
          break;
        case Operator.isNull:
          query = query.where(filter.key, isNull: filter.value == null);
          break;
      }
    }
    if (orderBy != null) {
      for (var order in orderBy) {
        query = query.orderBy(order);
      }
    }
    await query.get().then((value) {
      for (var element in value.docs) {
        if (element.exists) {
          data.add(element.data());
        }
      }
    });
    return data;
  }

  Future<List<Map<String, dynamic>>> getDataByField(
    String collection,
    String field,
    Object value,
  ) {
    return _db
        .collection(collection)
        .where(field, isEqualTo: value)
        .get()
        .then((value) {
      List<Map<String, dynamic>> data = [];
      for (var element in value.docs) {
        data.add(element.data());
      }
      return data;
    });
  }

  Future<List<Map<String, dynamic>>> getDataByFieldInCollection(
    String collectionOrigin,
    String collectionDestiny,
    String id,
    String field,
    Object value,
  ) {
    return _db
        .collection(collectionOrigin)
        .doc(id)
        .collection(collectionDestiny)
        .where(field, isEqualTo: value)
        .get()
        .then((value) {
      List<Map<String, dynamic>> data = [];
      for (var element in value.docs) {
        data.add(element.data());
      }
      return data;
    });
  }
}
