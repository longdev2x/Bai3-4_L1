import 'package:exercies3/common/model/task_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTaskLocalNotifier extends StateNotifier<TaskEntity> {
  AddTaskLocalNotifier() : super(TaskEntity(mainTask: "", date: DateTime.now()));

  void updateTaskLocal({
    String? mainTask,
    List<String>? additionalTasks,
    DateTime? date,
    DateTime? reminderDate,
    bool? isFlag,
    bool? repeat,
    String? categoryId,
  }) {
    state = state.copyWith(
      mainTask: mainTask,
      additionalTasks: additionalTasks,
      date: date,
      reminderDate: reminderDate,
      isFlag: isFlag,
      repeat: repeat,
      categoryId: categoryId,
    );
  }

}

final addTaskLocalProvider = StateNotifierProvider<AddTaskLocalNotifier, TaskEntity>((ref) => AddTaskLocalNotifier());