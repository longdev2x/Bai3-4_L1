import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/common/widgets/app_text_form_field.dart';
import 'package:exercies3/features/tasks/provider/categories_provider.dart';
import 'package:exercies3/features/tasks/provider/task_detail_provider.dart';
import 'package:exercies3/features/tasks/provider/tasks_provider.dart';
import 'package:exercies3/features/tasks/view/widget/date_time_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final String taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late final TextEditingController _controller;
  late final List<TextEditingController> _listController = [];

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

  void _addController(String additionalTask) {
    TextEditingController newController = TextEditingController();
    newController.text = additionalTask;
    setState(() {
      _listController.add(newController);
    });
  }

  void _removeController(TextEditingController controller) {
    controller.clear();
    controller.dispose();
    setState(() {
      _listController.remove(controller);
    });
  }

  void _saveAdditionalTasks(WidgetRef ref) {
    if (_listController.isEmpty) return;
    final List<String> adds =
        _listController.map((controller) => controller.text).toList();
    adds.removeWhere((add) => add.trim().isEmpty || add.length < 3);
    ref
        .read(taskDetailAsyncProvider(widget.taskId).notifier)
        .updateTask(additionalTasks: adds.isEmpty ? null : adds);
  }

  void _saveMainTask() {
    if (_controller.text.trim().isEmpty || _controller.text.length < 3) return;
    ref
        .read(taskDetailAsyncProvider(widget.taskId).notifier)
        .updateTask(mainTask: _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final task = ref.watch(taskDetailAsyncProvider(widget.taskId));
    final categories = ref.watch(categoriesAsyncProvider);

    return task.when(
      data: (task) {
        if (task == null) {
          return const Scaffold(
            body: Center(child: Text("Không có task này")),
          );
        }
        _controller.text = task.mainTask;
        if (_listController.isEmpty && task.additionalTasks != null) {
          for (String a in task.additionalTasks!) {
            _addController(a);
          }
        }
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            _saveAdditionalTasks(ref);
            _saveMainTask();
            // ignore: unused_result
            ref.refresh(tasksAsyncProvider);
          },
          child: Scaffold(
            appBar: AppBar(
              title: categories.when(
                  data: (categories) {
                    return DropdownButton<String>(
                      onChanged: (value) {
                        ref
                            .read(
                                taskDetailAsyncProvider(widget.taskId).notifier)
                            .updateTask(categoryId: value);
                      },
                      value: task.categoryId,
                      items: categories
                          .map((category) => DropdownMenuItem<String>(
                                value: category.id,
                                child: Text(category.name),
                              ))
                          .toList(),
                    );
                  },
                  error: (error, stackTrace) => const Text("Error"),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      )),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 10.r),
              child: Column(children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.r),
                    child: SingleChildScrollView(
                      child: Column(children: [
                        AppTextFieldNoborder(
                          controller: _controller,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          hintText: "Nhập nhiệm vụ chính",
                        ),
                        if (_listController.isNotEmpty)
                          Column(
                            children: [
                              ..._listController
                                  .map(
                                    (controller) => Row(
                                      children: [
                                        Expanded(
                                          child: AppTextFieldNoborder(
                                            controller: controller,
                                            hintText: "Nhập nhiệm vụ phụ",
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _removeController(controller);
                                            _saveAdditionalTasks(ref);
                                          },
                                          child: AppIcon(
                                            path: ImageRes.icDelete,
                                            size: 25.r,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        SizedBox(height: 30.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              _addController("");
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Thêm nhiệm phụ phụ"),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Card(
                  child: Column(children: [
                    ListTile(
                      onTap: () {
                        showModalBottomSheet(context: context, builder: (ctx) => const AddDateTimeWidget(), useSafeArea: true, isScrollControlled: true);
                      },
                      leading: const AppIcon(
                        path: ImageRes.icCalendar,
                      ),
                      title: const Text("Ngày đến hạn"),
                      trailing: Text(task.formatDate),
                    ),
                    ListTile(
                      onTap: () {
                        
                      },
                      leading: const AppIcon(
                        path: ImageRes.icCalendar,
                      ),
                      title: const Text("Thời gian"),
                      trailing: Text(task.formatDate),
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        );
      },
      error: (error, statkTrace) {
        if (kDebugMode) {
          print(statkTrace);
        }
        return const Scaffold(
          body: Center(child: Text("Some Thing Error")),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
