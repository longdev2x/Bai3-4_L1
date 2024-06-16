import 'package:exercies3/features/tasks/provider/categories_provider.dart';
import 'package:exercies3/features/tasks/provider/hori_index_provider.dart';
import 'package:exercies3/features/tasks/view/category_manager_screen.dart';
import 'package:exercies3/features/tasks/view/widget/tasks_app_bar.dart';
import 'package:exercies3/features/tasks/view/widget/tasks_drawer.dart';
import 'package:exercies3/features/tasks/view/widget/tasks_category_hori_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskCategories = ref.watch(categoriesAsyncProvider);

    final int indexChose = ref.watch(horiIndexProvider);
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
                taskCategories.when(
                  data: (data) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) => TaskCategoryHoriItem(
                            onPressed: () {
                              ref
                                  .read(horiIndexProvider.notifier)
                                  .update(index);
                            },
                            name: data[index].name,
                            isChose: indexChose == index),
                      ),
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
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (ctx, index) => SizedBox(
                child: Text(
                  index.toString(),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
