import 'package:exercies3/common/model/task_entity.dart';
import 'package:exercies3/common/widgets/app_title_bottom_sheet.dart';
import 'package:exercies3/features/tasks/provider/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderDatePicker extends ConsumerWidget {
  const ReminderDatePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TaskEntity task = ref.watch(addTaskLocalProvider);
    final DateTime date = task.date;
    final int groupValue = task.reminderDate != null ? date.difference(task.reminderDate!).inMinutes : durationMinutes[0];

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomSheet: Container(
          height: 300.h,
          margin: EdgeInsets.symmetric(horizontal: 16.r, vertical: 17.r),
          child: Column(children: [
            AppTitleBottomSheet(
              name: "Nhắc nhở lúc",
              onPressed: () {
                ref.read(addTaskLocalProvider.notifier).updateTaskLocal(reminderDuration: Duration(minutes: groupValue));
                Navigator.pop(context);
              },
            ),
            ...durationMinutes
                .map(
                  (minutes) => RadioMenuButton<int>(
                      value: minutes,
                      groupValue: groupValue,
                      onChanged: (value) {
                        ref.read(addTaskLocalProvider.notifier).updateTaskLocal(reminderDuration: Duration(minutes: value ?? durationMinutes[0]));
                      },
                      child: Text("Trước ${minutes < 60 ? minutes.toString() : "${(minutes~/60)} giờ : ${minutes%60} phút"}")),
                )
                .toList(),
          ]),
        ),
    );
  }
}
