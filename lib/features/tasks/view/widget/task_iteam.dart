import 'package:exercies3/common/model/task_entity.dart';
import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskItem extends StatelessWidget {
  final TaskEntity task;
  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Row(children: [
            Checkbox(value: task.isDone, onChanged: (isDone) {}),
            SizedBox(width: 5.w),
            Column(
              children: [
                Text(
                  task.mainTask,
                  style: TextStyle(fontSize: 24.sp),
                ),
                Row(
                  children: [
                    Text(task.date.toString()),
                    if (task.reminderDate != null)
                      const AppIcon(path: ImageRes.icAlarm),
                    if (task.additionalTasks != null &&
                        task.additionalTasks!.isNotEmpty)
                      const AppIcon(path: ImageRes.icSMS),
                    if (task.repeat!) const AppIcon(path: ImageRes.icRepeat)
                  ],
                ),
              ],
            ),
          ]),
          const Spacer(),
          AppIcon(
              path: ImageRes.icFlag,
              iconColor: task.isFlag! ? Colors.red : null),
        ],
      ),
    );
  }
}
