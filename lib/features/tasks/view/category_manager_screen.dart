import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/features/tasks/provider/categories_provider.dart';
import 'package:exercies3/features/tasks/view/widget/category_add_update.dart';
import 'package:exercies3/features/tasks/view/widget/category_modal_bottom.dart';
import 'package:exercies3/features/tasks/view/widget/category_veti_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryManagerScreen extends ConsumerWidget {
  const CategoryManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesAsyncProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý Danh mục")),
      body: Container(
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
                                builder: (ctx) => CategoryModalBottom(
                                  onTapUpdate: () {
                                    Navigator.pop(context);
                                  },
                                  onTapDelete: () {
                                    ref
                                        .read(categoriesAsyncProvider.notifier)
                                        .delete(data[index].id);
                                    Navigator.pop(context);
                                  },
                                  onTapCancle: () {
                                    Navigator.pop(context);
                                  },
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
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) => const CategoryAddUpdate(),
                                isScrollControlled: true,
                                useSafeArea: true
                              );
                            },
                            leading: const AppIcon(path: ImageRes.icPersonal),
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
