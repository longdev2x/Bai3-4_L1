import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/features/tasks/provider/add_task_local_provider.dart';
import 'package:exercies3/features/tasks/provider/categories_provider.dart';
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
    final addTaskLocal = ref.watch(addTaskLocalProvider);

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
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: const AppIcon(
                    path: ImageRes.icAlarm,
                    iconColor: Colors.purple,
                  ),
                )),
            GestureDetector(
                onTap: () {},
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
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: AppIcon(
                    path: ImageRes.icRepeat,
                    iconColor: addTaskLocal.repeat ? Colors.purple : null,
                  ),
                )),
            GestureDetector(
                onTap: () {},
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
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: AppIcon(
                    path: ImageRes.icFlag,
                    iconColor: addTaskLocal.isFlag ? Colors.purple : null,
                  ),
                )),
            GestureDetector(
              onTap: () {},
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
