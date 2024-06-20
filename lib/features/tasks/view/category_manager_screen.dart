import 'package:exercies3/common/model/category_entity.dart';
import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_confirm.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/features/tasks/provider/categories_provider.dart';
import 'package:exercies3/features/tasks/view/widget/category_add_update_widget.dart';
import 'package:exercies3/features/tasks/view/widget/category_action_widget.dart';
import 'package:exercies3/features/tasks/view/item/category_veti_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryManagerScreen extends ConsumerWidget {
  const CategoryManagerScreen({super.key});

  void _handleAdd(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => const CategoryAddUpdateWidget(),
        isScrollControlled: true,
        useSafeArea: true);
  }

  void _handleUpdate(BuildContext context, CategoryEntity category) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => CategoryAddUpdateWidget(categoryUpdate: category),
        isScrollControlled: true,
        useSafeArea: true);
  }

  void _handleDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AppConfirm(
        title: "Tất cả tác vụ trong danh mục này sẽ bị xoá.",
        onConfirm: () {
          ref.read(categoriesAsyncProvider.notifier).delete(id);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesAsyncProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý Danh mục")),
      body: Padding(
        padding: EdgeInsets.only(left: 6.w, top: 5.h),
        child: Column(
          children: [
            categories.when(
              data: (data) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length + 1,
                    itemBuilder: (ctx, index) => index < data.length
                        ? CategoryVetiItem(
                            category: data[index],
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) => CategoryActionWidget(
                                  onTapUpdate: () =>
                                      _handleUpdate(context, data[index]),
                                  onTapDelete: () => _handleDelete(
                                      context, ref, data[index].id),
                                ),
                              );
                            },
                            onLongPress: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("ok")),
                              );
                            },
                          )
                        : ListTile(
                            onTap: () => _handleAdd(context),
                            leading: const AppIcon(path: ImageRes.icCreate),
                            title: const Text("Tạo mới"),
                          ),
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) {
                return Center(
                  child: Text(stackTrace.toString()),
                );
              },
            ),
            SizedBox(height: 20.h),
            const Text("Nhấn và kéo để sắp xếp lại"),
            SizedBox(
              height: 50.h,
            ),
          ],
        ),
      ),
    );
  }
}
