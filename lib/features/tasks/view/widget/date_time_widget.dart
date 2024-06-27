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
  final TaskEntity initTask;
  final String? taskIdDetailFamily;
  const DateTimeWidget(
      {super.key, required this.initTask, this.taskIdDetailFamily});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TaskEntity task = ref.watch(taskLocalProviderFamily(initTask));
    final notifier = ref.read(taskLocalProviderFamily(initTask).notifier);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
      child: Column(children: [
        AppTitleBottomSheet(
            name: "Ngày & Giờ",
            onPressed: taskIdDetailFamily != null
                ? () {
                    ref
                        .read(taskDetailAsyncProvider(taskIdDetailFamily!)
                            .notifier)
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
          initTask: initTask,
          onDateChanged: (value) {
            notifier.updateTaskLocal(selectedDate: value);
          },
        ),
        SizedBox(height: 15.h),
        Card(
          child: Column(children: [
            ListTile(
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (ctx) => TimePickerWidget(
                  initTask: initTask,
                  onTimeChange: (duration) {
                    notifier.updateTaskLocal(selectedTime: duration);
                  },
                ),
              ),
              leading: const AppIcon(path: ImageRes.icAlarm),
              title: const Text('Thời gian'),
              trailing: Text(
                "${task.date.hour}h:${task.date.minute}p",
                style: TextStyle(fontSize: 17.sp),
              ),
            ),
            ListTile(
              onTap: () => showCupertinoModalPopup(
                  context: context,
                  builder: (ctx) => ReminderDatePickerWidget(
                      initTask: initTask,
                      onChange: (value) {
                        notifier.updateTaskLocal(
                            reminderDuration:
                                Duration(minutes: value ?? durationMinutes[0]));
                      })),
              leading: const AppIcon(path: ImageRes.icNotification),
              title: const Text('Lời nhắc lúc'),
              trailing: Text(
                task.reminderDate != null
                    ? "${task.reminderDate?.hour}h:${task.reminderDate?.minute}p"
                    : 'Không',
                style: TextStyle(fontSize: 17.sp),
              ),
            ),
            ListTile(
              onTap: () => showCupertinoModalPopup(
                  context: context,
                  builder: (ctx) => RepeatWidget(
                        initTask: initTask,
                        onChange: (value) {
                          notifier.updateTaskLocal(repeat: value);
                        },
                      )),
              leading: const AppIcon(path: ImageRes.icRepeat),
              title: const Text('Lặp lại'),
              trailing: Text(
                task.repeat != null ? "Hàng ${task.repeat!}" : 'Không',
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
  final TaskEntity initTask;
  final Function(DateTime) onDateChanged;
  const DatePickerWidget({
    super.key,
    required this.initTask,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TaskEntity task = ref.watch(taskLocalProviderFamily(initTask));
    return Card(
      child: CalendarDatePicker(
        onDateChanged: onDateChanged,
        initialDate: task.date,
        firstDate: DateTime.now().subtract(const Duration(days: 3650)),
        lastDate: DateTime(DateTime.now().year + 10),
        initialCalendarMode: DatePickerMode.day,
      ),
    );
  }
}

class TimePickerWidget extends ConsumerWidget {
  final TaskEntity initTask;
  final Function(Duration duration) onTimeChange;
  const TimePickerWidget({
    super.key,
    required this.initTask,
    required this.onTimeChange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TaskEntity task = ref.watch(taskLocalProviderFamily(initTask));
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
                initialTimerDuration:
                    Duration(hours: task.date.hour, minutes: task.date.minute),
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
  final TaskEntity initTask;
  final Function(int? value) onChange;
  const ReminderDatePickerWidget(
      {super.key, required this.initTask, required this.onChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TaskEntity task = ref.watch(taskLocalProviderFamily(initTask));

    final DateTime date = task.date;
    final int groupValue = task.reminderDate != null
        ? date.difference(task.reminderDate!).inMinutes
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
  final TaskEntity initTask;
  final Function(String? value) onChange;
  const RepeatWidget(
      {super.key, required this.initTask, required this.onChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TaskEntity task = ref.watch(taskLocalProviderFamily(initTask));
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
          ...repeatAccordings
              .map(
                (e) => RadioMenuButton<String>(
                    value: e,
                    groupValue: task.repeat,
                    onChanged: onChange,
                    child: Text("Theo $e")),
              )
              .toList(),
        ]),
      ),
    );
  }
}
