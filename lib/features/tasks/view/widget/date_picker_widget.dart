import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/common/widgets/app_title_bottom_sheet.dart';
import 'package:exercies3/features/tasks/provider/tasks_provider.dart';
import 'package:exercies3/features/tasks/view/widget/reminder_date_picker.dart';
import 'package:exercies3/features/tasks/view/widget/time_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DatePickerWidget extends ConsumerWidget {
  const DatePickerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime currentDateTime = ref.watch(addTaskLocalProvider).date;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
      child: Column(children: [
        AppTitleBottomSheet(name: "Ngày & Giờ", onPressed: () {}),
        SizedBox(height: 10.h),
        Card(
          child: CalendarDatePicker(
            onDateChanged: (value) {
              ref.read(addTaskLocalProvider.notifier).updateTaskLocal(selectedDate: value);
            },
            initialDate:  currentDateTime,
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 10),
            initialCalendarMode: DatePickerMode.day,
          ),
        ),
        SizedBox(height: 15.h),
        Card(
          child: Column(children: [
            ListTile(
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (ctx) => TimePickerWidget(
                  onTimeChange: (duration) {
                    ref.read(addTaskLocalProvider.notifier).updateTaskLocal(selectedTime: duration);
                  },
                  currentTimerDuration: Duration(hours: currentDateTime.hour, minutes: currentDateTime.minute),
                ),
              ),
              leading: const AppIcon(path: ImageRes.icAlarm),
              title: const Text('Thời gian'),
              trailing: Text("${currentDateTime.hour}:${currentDateTime.minute}", style: TextStyle(fontSize: 17.sp),),
            ),
            ListTile(
              onTap: () {
                showCupertinoModalPopup(context: context,builder: (ctx) => const ReminderDatePicker());
              },
              leading: const AppIcon(path: ImageRes.icNotification),
              title: const Text('Lời nhắc lúc'),
              trailing: Text('Không', style: TextStyle(fontSize: 17.sp),),
            ),
            ListTile(
              leading: const AppIcon(path: ImageRes.icRepeat),
              title: const Text('Lặp lại'),
              trailing: Text('Không', style: TextStyle(fontSize: 17.sp),),
            ),
          ]),
        ),
      ]),
    );
  }
}
