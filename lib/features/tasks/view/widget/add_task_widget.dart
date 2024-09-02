import 'package:exercies3/common/model/task_entity.dart';
import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_dialog.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/common/widgets/app_text_form_field.dart';
import 'package:exercies3/features/tasks/provider/categories_provider.dart';
import 'package:exercies3/features/tasks/provider/tasks_provider.dart';
import 'package:exercies3/features/tasks/view/widget/date_time_widget.dart';
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
  late final List<TextEditingController> _listController = [];

  String nameChosed = "Không có thể loại";

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    for (TextEditingController contro in _listController) {
      contro.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  void _addController() {
    setState(() {
      _listController.add(TextEditingController());
    });
  }

  void _removeController(int index) {
    _listController[index].clear();
    _listController[index].dispose();
    setState(() {
      _listController.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    TaskEntity task = ref.watch(taskLocalProvider);
    final notifier = ref.read(taskLocalProvider.notifier);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 15.r),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Column(children: [
        AppTextFormField(
          hintText: "Nhập nhiệm vụ mới tại đây",
          controller: _controller,
        ),
        SizedBox(height: 5.h),
        if (_listController.isNotEmpty)
          Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200.w),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _listController.length,
                    itemBuilder: (ctx, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _listController[index],
                              decoration: const InputDecoration(
                                  hintText: "Nhập nhiệm vụ phụ"),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          GestureDetector(
                            onTap: () {
                              _removeController(index);
                            },
                            child: const AppIcon(
                              path: ImageRes.icDelete,
                              iconColor: Colors.black,
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              SizedBox(height: 5.h),
              TextButton.icon(
                onPressed: () {
                  _addController();
                },
                icon: const Icon(Icons.add),
                label: const Text("Thêm nhiệm vụ phụ"),
              ),
            ],
          ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final fetchCategories = ref.watch(categoriesAsyncProvider);
                return fetchCategories.when(
                    data: (cates) {
                      if (task.categoryId != null &&
                          task.categoryId!.isNotEmpty) {
                        nameChosed = cates
                            .firstWhere((cate) =>
                                cate.id.compareTo(task.categoryId!) == 0)
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
                              notifier.updateTaskLocal(categoryId: value);
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
                      builder: (context) => const DateTimeWidget());
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
                      builder: (ctx) => ReminderDatePickerWidget(
                            onChange: (value) {
                              notifier.updateTaskLocal(
                                reminderDuration: Duration(minutes: value ?? 0),
                              );
                            },
                          ));
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: AppIcon(
                    path: ImageRes.icNotification,
                    iconColor: task.reminderDate != null ? Colors.purple : null,
                  ),
                )),
            GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (ctx) => RepeatWidget(
                            onChange: (value) {
                              notifier.updateTaskLocal(repeat: value);
                            },
                          ));
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: AppIcon(
                    path: ImageRes.icRepeat,
                    iconColor: task.repeat != null ? Colors.purple : null,
                  ),
                )),
            GestureDetector(
                onTap: () {
                  _addController();
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: AppIcon(
                    path: ImageRes.icSMS,
                    iconColor:
                        task.additionalTasks != null ? Colors.purple : null,
                  ),
                )),
            GestureDetector(
                onTap: () {
                  notifier.updateTaskLocal(isFlag: !task.isFlag);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: AppIcon(
                    path: ImageRes.icFlag,
                    iconColor: task.isFlag ? Colors.purple : null,
                  ),
                )),
            GestureDetector(
              onTap: () async {
                String mainTask = _controller.text;
                List<String> listAdditionTask =
                    _listController.map((e) => e.text).toList();
                if (mainTask.trim().isEmpty || mainTask.length < 3) {
                  AppDialog.showToast("Nhiệm vụ phải từ 3 ký tự");
                  return;
                }

                notifier.updateTaskLocal(mainTask: mainTask);

                listAdditionTask
                    .removeWhere((e) => e.trim().isEmpty || e.length < 3);
                if (listAdditionTask.isNotEmpty) {
                  notifier.updateTaskLocal(additionalTasks: listAdditionTask);
                }
                TaskEntity updateTask = ref.watch(taskLocalProvider);
                
                ref.read(tasksAsyncProvider.notifier).addTask(updateTask);
                Navigator.pop(context);
                ref.invalidate(taskLocalProvider);
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
