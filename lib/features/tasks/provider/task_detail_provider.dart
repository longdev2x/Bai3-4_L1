import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercies3/common/model/task_entity.dart';
import 'package:exercies3/features/tasks/repo/task_detail_repos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskAsyncNotifier extends FamilyAsyncNotifier<TaskEntity?, String> {
  TaskAsyncNotifier() : super();

  @override
  FutureOr<TaskEntity?> build(String arg) async {
    return await _getTask(arg);
  }

  Future<TaskEntity?> _getTask(String id) async {
    return await TaskDetailRepos.getTask(id);
  }

  Future<void> updateTask(
      {String? mainTask,
      List<String>? additionalTasks,
      DateTime? selectedDate,
      Duration? selectedTime,
      DateTime? reminderTime,
      String? categoryId,
      bool? isDone,
      bool? isFlag,
      String? repeat}) async {
    state = state.whenData((task) {
      task = task!.copyWith(
          mainTask: mainTask,
          additionalTasks: additionalTasks,
          date: task.date.copyWith(
              year: selectedDate?.year,
              month: selectedDate?.month,
              day: selectedDate?.day,
              hour: selectedTime?.inHours,
              minute: selectedTime != null ? selectedTime.inMinutes % 60 : null),
          reminderDate: reminderTime,
          categoryId: categoryId,
          isDone: isDone,
          isFlag: isFlag,
          repeat: repeat);
      return task;
    });

    //talk to sever
    try {
      await TaskDetailRepos.updateTask(state.value!);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    } finally {
      state = await AsyncValue.guard(() async => await _getTask(arg));
    }
  }
}

final taskDetailAsyncProvider =
    AsyncNotifierProviderFamily<TaskAsyncNotifier, TaskEntity?, String>(
        () => TaskAsyncNotifier());
