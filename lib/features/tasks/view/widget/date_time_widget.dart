import 'package:exercies3/common/model/task_entity.dart';
import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/common/widgets/app_title_bottom_sheet.dart';
import 'package:exercies3/features/tasks/provider/tasks_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddDateTimeWidget extends ConsumerWidget {
  const AddDateTimeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TaskEntity task = ref.watch(addTaskLocalProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
      child: Column(children: [
        AppTitleBottomSheet(
            name: "Ngày & Giờ",
            onPressed: () {
              Navigator.pop(context);
            }),
        SizedBox(height: 10.h),
        DatePickerWidget(
            onDateChanged: (value) {
              ref
                  .read(addTaskLocalProvider.notifier)
                  .updateTaskLocal(selectedDate: value);
            },
            initialDate: task.date),
        SizedBox(height: 15.h),
        Card(
          child: Column(children: [
            ListTile(
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (ctx) => TimePickerWidget(
                  onTimeChange: (duration) {
                    ref
                        .read(addTaskLocalProvider.notifier)
                        .updateTaskLocal(selectedTime: duration);
                  },
                  currentTimerDuration: Duration(
                      hours: task.date.hour, minutes: task.date.minute),
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
                  builder: (ctx) => const ReminderDatePickerWidget()),
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
                  context: context, builder: (ctx) => const RepeatWidget()),
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

class DatePickerWidget extends StatelessWidget {
  final Function(DateTime) onDateChanged;
  final DateTime initialDate;
  const DatePickerWidget(
      {super.key, required this.onDateChanged, required this.initialDate});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CalendarDatePicker(
        onDateChanged: onDateChanged,
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 10),
        initialCalendarMode: DatePickerMode.day,
      ),
    );
  }
}

class TimePickerWidget extends StatelessWidget {
  final Function(Duration duration) onTimeChange;
  final Duration currentTimerDuration;
  const TimePickerWidget(
      {super.key,
      required this.onTimeChange,
      required this.currentTimerDuration});

  @override
  Widget build(BuildContext context) {
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
                initialTimerDuration: currentTimerDuration,
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
  const ReminderDatePickerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TaskEntity task = ref.watch(addTaskLocalProvider);
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
              ref.read(addTaskLocalProvider.notifier).updateTaskLocal(
                  reminderDuration: Duration(minutes: groupValue));
              Navigator.pop(context);
            },
          ),
          ...durationMinutes
              .map(
                (minutes) => RadioMenuButton<int>(
                    value: minutes,
                    groupValue: groupValue,
                    onChanged: (value) {
                      ref.read(addTaskLocalProvider.notifier).updateTaskLocal(
                          reminderDuration:
                              Duration(minutes: value ?? durationMinutes[0]));
                    },
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
  const RepeatWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? selectedValue = ref.watch(addTaskLocalProvider).repeat;

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
                    groupValue: selectedValue,
                    onChanged: (value) {
                      ref
                          .read(addTaskLocalProvider.notifier)
                          .updateTaskLocal(repeat: value);
                    },
                    child: Text("Theo $e")),
              )
              .toList(),
        ]),
      ),
    );
  }
}
