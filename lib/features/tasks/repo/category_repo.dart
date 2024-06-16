import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercies3/common/model/category_entity.dart';
import 'package:exercies3/common/utils/app_constants.dart';

class CategoryRepos {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static Future<List<CategoryEntity>> getAll() async {
    final response = await _instance.collection(AppConstants.cCategory).get();
    return response.docs.map((doc) => CategoryEntity.fromJson(doc.data())).toList();
    
  }

  static Future<void> add(CategoryEntity category) async {
    await _instance.collection(AppConstants.cCategory).doc(category.id).set(category.toJson());
  }

  static Future<void> update(CategoryEntity category) async {
    await _instance.collection(AppConstants.cCategory).doc(category.id).update(category.toJson());
  }

  static Future<void> delete(String id) async {
    await _instance.collection(AppConstants.cCategory).doc(id).delete();
  }
}