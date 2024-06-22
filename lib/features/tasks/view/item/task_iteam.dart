import 'package:exercies3/common/model/task_entity.dart';
import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_dialog.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/features/tasks/provider/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskItem extends ConsumerWidget {
  final TaskEntity task;
  const TaskItem({super.key, required this.task});

  void _handlerCheckbox(WidgetRef ref, bool? isDone) {
    ref.read(tasksAsyncProvider.notifier).updateTask(task.id, isDone: isDone);
  }

  void _handlerFlag(WidgetRef ref, bool? isFlag) {
    ref.read(tasksAsyncProvider.notifier).updateTask(task.id, isFlag: isFlag);
  }

  void _handlerDelete(WidgetRef ref, String id) {
    ref.read(tasksAsyncProvider.notifier).deleteTask(id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Slidable(
          key: ValueKey(task.id),
          endActionPane: ActionPane(
              extentRatio: 0.5,
              motion: const ScrollMotion(),
              children: [
                CustomSlidableAction(
                  onPressed: (ctx) {
                    AppDialog.showToast("Have soon");
                  },
                  backgroundColor: Colors.black,
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(12.r)),
                  child: Container(
                    height: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    child: AppIcon(
                        path: ImageRes.icShare,
                        size: 25.r,
                        iconColor: Colors.white),
                  ),
                ),
                CustomSlidableAction(
                  onPressed: (ctx) => _handlerDelete(ref, task.id),
                  backgroundColor: const Color.fromRGBO(204, 85, 0, 1),
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(12.r)),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 15.h),
                    child: AppIcon(
                      path: ImageRes.icDelete,
                      size: 25.r,
                      iconColor: Colors.white,
                    ),
                  ),
                ),
              ]),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Row(children: [
                  Checkbox(
                      value: task.isDone,
                      onChanged: (isDone) => _handlerCheckbox(ref, isDone)),
                  SizedBox(width: 5.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.mainTask,
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 5.w),
                            child: Text(
                              task.formatDate,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 120, 14, 6),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (task.reminderDate != null)
                            Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: const AppIcon(path: ImageRes.icAlarm),
                            ),
                          if (task.additionalTasks != null &&
                              task.additionalTasks!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: const AppIcon(path: ImageRes.icSMS),
                            ),
                          if (task.repeat != null)
                            Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: const AppIcon(path: ImageRes.icRepeat),
                            )
                        ],
                      ),
                    ],
                  ),
                ]),
                const Spacer(),
                IconButton(
                  onPressed: () => _handlerFlag(ref, !task.isFlag),
                  icon: AppIcon(
                      path: ImageRes.icFlag,
                      iconColor: task.isFlag ? Colors.black : null),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
