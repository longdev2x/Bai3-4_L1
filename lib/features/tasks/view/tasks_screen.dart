import 'package:exercies3/common/model/category_entity.dart';
import 'package:exercies3/common/model/task_entity.dart';
import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/features/tasks/provider/categories_provider.dart';
import 'package:exercies3/features/tasks/provider/hori_index_provider.dart';
import 'package:exercies3/features/tasks/provider/tasks_provider.dart';
import 'package:exercies3/features/tasks/view/category_manager_screen.dart';
import 'package:exercies3/features/tasks/view/widget/task_iteam.dart';
import 'package:exercies3/features/tasks/view/widget/tasks_app_bar.dart';
import 'package:exercies3/features/tasks/view/widget/tasks_drawer.dart';
import 'package:exercies3/features/tasks/view/widget/tasks_category_hori_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  void _updateIndex(WidgetRef ref, int index) =>
      ref.read(horiIndexProvider.notifier).update(index);

  void _addTask(WidgetRef ref, List<CategoryEntity> categories) {
    CategoryEntity category = categories[2];
    showModalBottomSheet(
        context: ref.context,
        builder: (ctx) => Container(
              padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 15.r),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
              ),
              child: Column(children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Nhập nhiệm vụ mới tại đây",
                  ),
                  controller: _controller,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(category.name),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const AppIcon(path: ImageRes.icAlarm)),
                    IconButton(
                        onPressed: () {},
                        icon: const AppIcon(path: ImageRes.icNotification)),
                    IconButton(
                        onPressed: () {},
                        icon: const AppIcon(path: ImageRes.icRepeat)),
                    IconButton(
                        onPressed: () {},
                        icon: const AppIcon(path: ImageRes.icSMS)),
                    IconButton(
                        onPressed: () {},
                        icon: const AppIcon(path: ImageRes.icFlag)),
                    IconButton(
                      onPressed: () {
                        ref.read(tasksAsyncProvider.notifier).addTask(
                              TaskEntity(
                                  mainTask: "Test Thu 1",
                                  date: DateTime.now(),
                                  additionalTasks: ["Ok"],
                                  categoryId: category.id,
                                  isDone: false,
                                  reminderDate: DateTime.now(),
                                  isFlag: true,
                                  repeat: true),
                            );
                      },
                      icon: AppIcon(
                        path: ImageRes.icDone,
                        size: 27.r,
                        iconColor: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ]),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesAsyncProvider);
    final int indexChose = ref.watch(horiIndexProvider);
    final AsyncValue<List<TaskEntity>> tasks = ref.watch(tasksAsyncProvider);
    return Scaffold(
      appBar: tasksAppBar(),
      drawer: const TaskDrawer(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.r),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.only(top: 5.h, bottom: 10.h),
            height: 50.h,
            child: Row(
              children: [
                categories.when(
                  data: (data) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: data.length + 1,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) {
                            if (index == 0) {
                              return TaskCategoryHoriItem(
                                  onPressed: () => _updateIndex(ref, index),
                                  name: "Tất cả",
                                  isChose: indexChose == 0);
                            }
                            return TaskCategoryHoriItem(
                                onPressed: () => _updateIndex(ref, index),
                                name: data[index - 1].name,
                                isChose: indexChose == index);
                          }),
                    );
                  },
                  error: (error, stackTrace) => Text(stackTrace.toString()),
                  loading: () => Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) => ElevatedButton(
                          onPressed: () {},
                          child: const CircularProgressIndicator()),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const CategoryManagerScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.add_box,
                    size: 25.r,
                  ),
                ),
              ],
            ),
          ),
          tasks.when(
            data: (data) {
              return Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, index) {
                    print("Ok data - ${data[index].toJson()}");
                    print(data[index].id);
                    print(data[index].mainTask);
                    print(data[index].additionalTasks?[0]);
                    print(data[index].date);
                    print(data[index].reminderDate);
                    print(data[index].isDone);
                    print(data[index].isFlag);
                    return TaskItem(task: data[index]);
                  },
                ),
              );
            },
            error: (error, stackTrace) {
              print("error- $error");
              print("statce- $stackTrace");
              return Expanded(
                  child: Container(
                child: Text("Error-$stackTrace"),
              ));
            },
            loading: () => const CircularProgressIndicator(),
          ),
          ElevatedButton(
              onPressed: () => _addTask(ref, categories.value!),
              child: const Text("Add")),
        ]),
      ),
    );
  }
}
