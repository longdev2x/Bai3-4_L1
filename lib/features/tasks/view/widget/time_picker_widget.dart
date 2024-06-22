import 'package:exercies3/common/widgets/app_title_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimePickerWidget extends StatelessWidget {
  final Function(Duration duration) onTimeChange;
  final Duration currentTimerDuration;
  const TimePickerWidget({super.key, required this.onTimeChange, required this.currentTimerDuration});

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
              AppTitleBottomSheet(name: "Cài đặt thời gian", onPressed: () {
                Navigator.pop(context);
              }),
              SizedBox(height: 10.w),
              SizedBox(
                height: 200.h,
                child: Expanded(
                  child: CupertinoTimerPicker(
                    onTimerDurationChanged: onTimeChange,
                    initialTimerDuration: currentTimerDuration,
                    mode: CupertinoTimerPickerMode.hm,
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}