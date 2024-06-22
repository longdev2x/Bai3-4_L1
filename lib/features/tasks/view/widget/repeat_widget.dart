import 'package:exercies3/common/widgets/app_title_bottom_sheet.dart';
import 'package:exercies3/features/tasks/provider/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          AppTitleBottomSheet(name: "Lặp lại", onPressed: () {
            Navigator.pop(context);
          }),
          ...repeatAccordings
              .map(
                (e) => RadioMenuButton<String>(
                    value: e,
                    groupValue: selectedValue,
                    onChanged: (value) {
                      ref.read(addTaskLocalProvider.notifier).updateTaskLocal(repeat: value);
                    },
                    child: Text("Theo $e")),
              )
              .toList(),
        ]),
      ),
    );
  }
}
