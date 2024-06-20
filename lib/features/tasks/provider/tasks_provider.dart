import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercies3/common/model/task_entity.dart';
import 'package:exercies3/features/tasks/repo/task_repos.dart';
import 'package:flutter/foundation.dart';
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
    //local, gán chứ không add vào value cũ vì như vậy
    //sẽ không thay đổi địa chỉ ô nhớ. không update
    // state = AsyncData([...state.value!, task]); (Cách này cần dùng !)
    state = state.whenData((value) {
      return [...value, task];
    });
    //talk to sever
    try {
      await TaskRepos.addTask(task);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Add error - ${e.message}");
      }
    } finally {
      state = await AsyncValue.guard(() async => await _loadAll());
      // ref.invalidateSelf() dùng để dispose chính provider hiện tại rồi init provider mới.
      //Dùng cách này chỉ dùng khi reload list, còn update thì không nên
    }
  }

  Future<void> deleteTask(String id) async {
    state = state.whenData((value) {
      value.removeWhere((task) => task.id == id);
      return value;
    });
    try {
      await TaskRepos.deleteTask(id);
    } on FirebaseException catch (e) {
      print("error when delete - ${e.message}");
    } finally {
      state = await AsyncValue.guard(() async => await _loadAll());
    }
  }

  //optimistic update (update local - send to sever(error, back local) - get from sever)
  Future<void> updateTask(
    String id, {
    String? mainTask,
    List<String>? additionalTasks,
    DateTime? date,
    DateTime? reminderDate,
    bool? isDone,
    bool? isFlag,
    bool? repeat,
  }) async {
    state = state.whenData((tasks) {
      return tasks.map((task) {
        if (task.id == id) {
          //copyWith cơ bản chỉ là tạo bản sao. phải gán lại thì mới làm thay 
          //đổi ở nhớ của list
          task = task.copyWith(
            mainTask: mainTask,
            additionalTasks: additionalTasks,
            date: date,
            reminderDate: reminderDate,
            isDone: isDone,
            isFlag: isFlag,
            repeat: repeat,
          );
        }
        return task;
      }).toList();
    });
    //send to sever
    TaskEntity? updateTask = state.value?.firstWhere((element) => element.id == id);
    if (updateTask == null) return;
    try {
      await TaskRepos.updateTask(updateTask);
    } on FirebaseException catch (e) {
      print("error update - ${e.message}");
    } finally {
      state = await AsyncValue.guard(() async => await _loadAll());
    }
  }
}

final tasksAsyncProvider =
    AsyncNotifierProvider<TasksAsyncNotifier, List<TaskEntity>>(
        () => TasksAsyncNotifier());
