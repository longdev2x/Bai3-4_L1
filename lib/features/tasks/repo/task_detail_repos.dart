import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercies3/common/model/task_entity.dart';
import 'package:exercies3/common/utils/app_constants.dart';

class TaskDetailRepos {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static Future<TaskEntity?> getTask(String id) async {
    final response = await  _instance.collection(AppConstants.cTask).doc(id).get();
    return response.data() != null ? TaskEntity.fromJson(response.data()!) : null;
  }
  
  static Future<void> updateTask(TaskEntity task) async {
    _instance.collection(AppConstants.cTask).doc(task.id).update(task.toJson());
  }
}