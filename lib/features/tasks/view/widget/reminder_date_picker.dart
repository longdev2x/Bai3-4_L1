import 'package:exercies3/common/widgets/app_title_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderDatePicker extends ConsumerWidget {
  const ReminderDatePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<int> durationMinutes = [5, 15, 30, 60, 180, 1440];
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomSheet: Container(
          height: 300.h,
          margin: EdgeInsets.symmetric(horizontal: 16.r, vertical: 17.r),
          child: Column(children: [
            AppTitleBottomSheet(
              name: "Nhắc nhở lúc",
              onPressed: () {},
            ),
            ...durationMinutes
                .map(
                  (minutes) => RadioMenuButton<int>(
                      value: minutes,
                      groupValue: durationMinutes[3],
                      onChanged: (value) {
                        
                      },
                      child: Text("Trước ${minutes < 60 ? minutes.toString() : "${(minutes~/60)} giờ : ${minutes%60} phút"}")),
                )
                .toList(),
          ]),
        ),
    );
  }
}
