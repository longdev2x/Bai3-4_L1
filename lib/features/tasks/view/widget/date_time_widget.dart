import 'package:exercies3/common/model/task_entity.dart';
import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/common/widgets/app_title_bottom_sheet.dart';
import 'package:exercies3/features/tasks/provider/task_detail_provider.dart';
import 'package:exercies3/features/tasks/provider/tasks_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateTimeWidget extends ConsumerWidget {
  final String? taskId;
  const DateTimeWidget({super.key, this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TaskEntity? task;
    if (taskId == null) {
      task = ref.watch(taskLocalProvider);
    } else {
      task = ref.watch(taskDetailAsyncProvider(taskId!)).valueOrNull;
    }

    final addNotifier = ref.read(taskLocalProvider.notifier);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
      child: Column(children: [
        AppTitleBottomSheet(
            name: "Ngày & Giờ",
            onPressed: taskId != null
                ? () {
                    if (task == null) return;
                    ref
                        .read(taskDetailAsyncProvider(taskId!).notifier)
                        .updateTask(
                            selectedDate: task.date,
                            selectedTime: Duration(
                                hours: task.date.hour,
                                minutes: task.date.minute),
                            reminderTime: task.reminderDate,
                            repeat: task.repeat);
                    Navigator.pop(context);
                  }
                : () {
                    Navigator.pop(context);
                  }),
        SizedBox(height: 10.h),
        DatePickerWidget(
          taskId: taskId,
          onDateChanged: (value) {
            taskId == null
                ? addNotifier.updateTaskLocal(selectedDate: value)
                : ref
                    .read(taskDetailAsyncProvider(taskId!).notifier)
                    .updateTask(selectedDate: value);
          },
        ),
        SizedBox(height: 15.h),
        Card(
          child: Column(children: [
            ListTile(
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (ctx) => TimePickerWidget(
                  taskId: taskId,
                  onTimeChange: (duration) {
                    taskId == null
                        ? addNotifier.updateTaskLocal(selectedTime: duration)
                        : ref
                            .read(taskDetailAsyncProvider(taskId!).notifier)
                            .updateTask(selectedTime: duration);
                  },
                ),
              ),
              leading: const AppIcon(path: ImageRes.icAlarm),
              title: const Text('Thời gian'),
              trailing: Text(
                "${task?.date.hour}h:${task?.date.minute}p",
                style: TextStyle(fontSize: 17.sp),
              ),
            ),
            ListTile(
              onTap: () => showCupertinoModalPopup(
                  context: context,
                  builder: (ctx) => ReminderDatePickerWidget(
                      taskId: taskId,
                      onChange: (value) {
                        taskId == null
                            ? addNotifier.updateTaskLocal(
                                reminderDuration: Duration(
                                    minutes: value ?? durationMinutes[0]))
                            : ref
                                .read(taskDetailAsyncProvider(taskId!).notifier)
                                .updateTask(
                                    reminderTime: task?.date.subtract(Duration(
                                        minutes: value ?? durationMinutes[0])));
                      })),
              leading: const AppIcon(path: ImageRes.icNotification),
              title: const Text('Lời nhắc lúc'),
              trailing: Text(
                task?.reminderDate != null
                    ? "${task?.reminderDate?.hour}h:${task?.reminderDate?.minute}p"
                    : 'Không',
                style: TextStyle(fontSize: 17.sp),
              ),
            ),
            ListTile(
              onTap: () => showCupertinoModalPopup(
                  context: context,
                  builder: (ctx) => RepeatWidget(
                        taskId: taskId,
                        onChange: (value) {
                          taskId == null
                              ? addNotifier.updateTaskLocal(repeat: value)
                              : ref
                                  .read(
                                      taskDetailAsyncProvider(taskId!).notifier)
                                  .updateTask(repeat: value);
                        },
                      )),
              leading: const AppIcon(path: ImageRes.icRepeat),
              title: const Text('Lặp lại'),
              trailing: Text(
                task?.repeat != null ? "Hàng ${task?.repeat!}" : 'Không',
                style: TextStyle(fontSize: 17.sp),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class DatePickerWidget extends ConsumerWidget {
  final String? taskId;
  final Function(DateTime) onDateChanged;
  const DatePickerWidget({
    super.key,
    this.taskId,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TaskEntity? task;
    if (taskId == null) {
      task = ref.watch(taskLocalProvider);
    } else {
      task = ref.watch(taskDetailAsyncProvider(taskId!)).valueOrNull;
    }

    return Card(
      child: CalendarDatePicker(
        onDateChanged: onDateChanged,
        initialDate: task?.date ?? DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 3650)),
        lastDate: DateTime(DateTime.now().year + 10),
        initialCalendarMode: DatePickerMode.day,
      ),
    );
  }
}

class TimePickerWidget extends ConsumerWidget {
  final String? taskId;
  final Function(Duration duration) onTimeChange;

  const TimePickerWidget({
    super.key,
    this.taskId,
    required this.onTimeChange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TaskEntity? task;
    if (taskId == null) {
      task = ref.watch(taskLocalProvider);
    } else {
      task = ref.watch(taskDetailAsyncProvider(taskId!)).valueOrNull;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        height: 330.h,
        color: Colors.white,
        child: Column(
          children: [
            AppTitleBottomSheet(
                name: "Cài đặt thời gian",
                onPressed: () {
                  Navigator.pop(context);
                }),
            SizedBox(height: 10.w),
            SizedBox(
              height: 200.h,
              child: CupertinoTimerPicker(
                onTimerDurationChanged: onTimeChange,
                initialTimerDuration: Duration(
                    hours: task?.date.hour ?? DateTime.now().hour,
                    minutes: task?.date.minute ?? DateTime.now().minute),
                mode: CupertinoTimerPickerMode.hm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReminderDatePickerWidget extends ConsumerWidget {
  final String? taskId;
  final Function(int? value) onChange;
  const ReminderDatePickerWidget(
      {super.key, this.taskId, required this.onChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TaskEntity? task;
    if (taskId == null) {
      task = ref.watch(taskLocalProvider);
    } else {
      task = ref.watch(taskDetailAsyncProvider(taskId!)).valueOrNull;
    }

    final DateTime date = task?.date ?? DateTime.now();
    final int groupValue = task?.reminderDate != null
        ? date
            .difference(task?.reminderDate ??
                DateTime.now().subtract(const Duration(minutes: 5)))
            .inMinutes
        : durationMinutes[0];

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomSheet: Container(
        height: 300.h,
        margin: EdgeInsets.symmetric(horizontal: 16.r, vertical: 17.r),
        child: Column(children: [
          AppTitleBottomSheet(
            name: "Nhắc nhở lúc",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ...durationMinutes
              .map(
                (minutes) => RadioMenuButton<int>(
                    value: minutes,
                    groupValue: groupValue,
                    onChanged: onChange,
                    child: Text(
                        "Trước ${minutes < 60 ? minutes.toString() : "${(minutes ~/ 60)} giờ : ${minutes % 60} phút"}")),
              )
              .toList(),
        ]),
      ),
    );
  }
}

class RepeatWidget extends ConsumerWidget {
  final String? taskId;
  final Function(String? value) onChange;
  const RepeatWidget({super.key, this.taskId, required this.onChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TaskEntity? task;
    if (taskId == null) {
      task = ref.watch(taskLocalProvider);
    } else {
      task = ref.watch(taskDetailAsyncProvider(taskId!)).valueOrNull;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomSheet: Container(
        height: 300.h,
        padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 17.r),
        child: Column(children: [
          AppTitleBottomSheet(
              name: "Lặp lại",
              onPressed: () {
                Navigator.pop(context);
              }),
          ...repeatAccordings.map(
            (e) {
              return RadioMenuButton<String>(
                  value: e,
                  groupValue: task?.repeat,
                  onChanged: onChange,
                  child: Text("Theo $e"));
            },
          ).toList(),
        ]),
      ),
    );
  }
}
