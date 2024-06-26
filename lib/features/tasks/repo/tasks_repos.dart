import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercies3/common/model/task_entity.dart';
import 'package:exercies3/common/utils/app_constants.dart';

class TasksRepos {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static Future<List<TaskEntity>> getAll() async {
    final snapshot = await _instance.collection(AppConstants.cTask).get();
    return snapshot.docs.map((doc) => TaskEntity.fromJson(doc.data())).toList();
  }

  static Future<void> addTask(TaskEntity task) async {
    await _instance.collection(AppConstants.cTask).doc(task.id).set(task.toJson());
  }

  static Future<void> deleteTask(String id) async {
    await _instance.collection(AppConstants.cTask).doc(id).delete();
  }

  static Future<void> updateTask(TaskEntity task) async {
    await _instance.collection(AppConstants.cTask).doc(task.id).update(task.toJson());
  }
}