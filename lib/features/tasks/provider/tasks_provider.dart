import 'dart:async';

import 'package:exercies3/common/model/task_entity.dart';
import 'package:exercies3/features/tasks/repo/task_repos.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksAsyncNotifier extends AsyncNotifier<List<TaskEntity>> {
  TasksAsyncNotifier() : super();

  @override
  FutureOr<List<TaskEntity>> build() async {
    return await _loadAll();
  }

  Future<List<TaskEntity>> _loadAll() async {
    return await TaskRepos.getAll();
  }

  Future<void> addTask(TaskEntity task) async {
    state = await AsyncValue.guard(() async {
      await TaskRepos.addTask(task);
      return await _loadAll();
    });
  }

  Future<void> deleteTask(String id) async {
    state = await AsyncValue.guard(() async {
      await TaskRepos.deleteTask(id);
      return await _loadAll();
    });
  }

  Future<void> updateTask(TaskEntity task) async {
    state = await AsyncValue.guard(() async {
      await TaskRepos.updateTask(task);
      return await _loadAll();
    });
  }
}

final tasksAsyncProvider = AsyncNotifierProvider<TasksAsyncNotifier, List<TaskEntity>>(() => TasksAsyncNotifier());
