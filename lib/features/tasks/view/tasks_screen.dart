import 'package:exercies3/common/model/task_entity.dart';
import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/features/tasks/provider/categories_provider.dart';
import 'package:exercies3/features/tasks/provider/tasks_provider.dart';
import 'package:exercies3/features/tasks/view/category_manager_screen.dart';
import 'package:exercies3/features/tasks/view/widget/add_task_widget.dart';
import 'package:exercies3/features/tasks/view/item/task_iteam.dart';
import 'package:exercies3/features/tasks/view/widget/tasks_app_bar_widget.dart';
import 'package:exercies3/features/tasks/view/widget/tasks_drawer_widget.dart';
import 'package:exercies3/features/tasks/view/item/tasks_category_hori_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {

  void _updateIndex(WidgetRef ref, int index) =>
      ref.read(horiIndexProvider.notifier).state = index;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesAsyncProvider);
    final int indexChose = ref.watch(horiIndexProvider);
    final AsyncValue<List<TaskEntity>> tasks = ref.watch(tasksAsyncProvider);
    return Scaffold(
      appBar: tasksAppBarWidget(),
      drawer: const TaskDrawerWidget(),
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
                  child: SlidableAutoCloseBehavior(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (ctx, index) {
                            return TaskItem(task: data[index]);
                          })));
            },
            error: (error, stackTrace) {
              return Expanded(child: Center(child: Text("Error-$stackTrace")));
            },
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: (ctx) => const AddTaskWidget());
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.all(12.r),
                margin: EdgeInsets.only(bottom: 10.h),
                height: 50.h,
                width: 50.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: const Color.fromRGBO(10, 147, 254, 1)),
                child: const AppIcon(
                    path: ImageRes.icPlus, iconColor: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
