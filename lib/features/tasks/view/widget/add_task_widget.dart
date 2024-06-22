import 'package:exercies3/common/model/task_entity.dart';
import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_dialog.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/features/tasks/provider/categories_provider.dart';
import 'package:exercies3/features/tasks/provider/tasks_provider.dart';
import 'package:exercies3/features/tasks/view/widget/date_picker_widget.dart';
import 'package:exercies3/features/tasks/view/widget/reminder_date_picker.dart';
import 'package:exercies3/features/tasks/view/widget/repeat_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddTaskWidget extends ConsumerStatefulWidget {
  const AddTaskWidget({super.key});

  @override
  ConsumerState<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends ConsumerState<AddTaskWidget> {
  late final TextEditingController _controller;
  String nameChosed = "Không có thể loại";

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TaskEntity addTaskLocal = ref.watch(addTaskLocalProvider);
    final int totalAdd = ref.watch(totalAdditionTaskProvider);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 15.r),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Column(children: [
        TextField(
          decoration: const InputDecoration(
            hintText: "Nhập nhiệm vụ mới tại đây",
          ),
          controller: _controller,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final fetchCategories = ref.watch(categoriesAsyncProvider);
                return fetchCategories.when(
                    data: (cates) {
                      if (addTaskLocal.categoryId != null &&
                          addTaskLocal.categoryId!.isNotEmpty) {
                        nameChosed = cates
                            .firstWhere((cate) =>
                                cate.id.compareTo(addTaskLocal.categoryId!) ==
                                0)
                            .name;
                      } else {
                        nameChosed = "Không có thể loại";
                      }

                      return Container(
                        constraints: BoxConstraints(maxWidth: 130.w),
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 9.w),
                        margin: EdgeInsets.only(right: 15.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Colors.amber),
                        child: PopupMenuButton<String>(
                            onSelected: (value) {
                              ref
                                  .read(addTaskLocalProvider.notifier)
                                  .updateTaskLocal(categoryId: value);
                            },
                            position: PopupMenuPosition.under,
                            itemBuilder: (context) => [
                                  const PopupMenuItem(
                                      value: "",
                                      child: Text("Không có thể loại")),
                                  ...cates
                                      .map((category) => PopupMenuItem(
                                            value: category.id,
                                            child: Text(category.name),
                                          ))
                                      .toList()
                                ],
                            child: Text(
                              nameChosed,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                      );
                    },
                    error: (error, stackTrace) =>
                        Center(child: Text(stackTrace.toString())),
                    loading: () => const CircularProgressIndicator());
              },
            ),
            GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (context) => const DatePickerWidget());
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: const AppIcon(
                    path: ImageRes.icAlarm,
                    iconColor: Colors.purple,
                  ),
                )),
            GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (ctx) => const ReminderDatePicker());
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: AppIcon(
                    path: ImageRes.icNotification,
                    iconColor: addTaskLocal.reminderDate != null
                        ? Colors.purple
                        : null,
                  ),
                )),
            GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(context: context, builder: (ctx) => const RepeatWidget());
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: AppIcon(
                    path: ImageRes.icRepeat,
                    iconColor:
                        addTaskLocal.repeat != null ? Colors.purple : null,
                  ),
                )),
            GestureDetector(
                onTap: () {
                  ref.read(totalAdditionTaskProvider.notifier).state + 1;
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: AppIcon(
                    path: ImageRes.icSMS,
                    iconColor: addTaskLocal.additionalTasks != null
                        ? Colors.purple
                        : null,
                  ),
                )),
            GestureDetector(
                onTap: () {
                  ref
                      .read(addTaskLocalProvider.notifier)
                      .updateTaskLocal(isFlag: !addTaskLocal.isFlag);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: AppIcon(
                    path: ImageRes.icFlag,
                    iconColor: addTaskLocal.isFlag ? Colors.purple : null,
                  ),
                )),
            GestureDetector(
              onTap: () {
                String mainTask = _controller.text;
                if(mainTask.trim().isEmpty || mainTask.length < 3) {
                  AppDialog.showToast("Nhiệm vụ phải từ 3 ký tự");
                  return;
                }
                ref.read(addTaskLocalProvider.notifier).updateTaskLocal(mainTask: mainTask);
                ref.read(tasksAsyncProvider.notifier).addTask();
                Navigator.pop(context);
              },
              child: AppIcon(
                path: ImageRes.icDone,
                size: 40.r,
                iconColor: Colors.purple,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
