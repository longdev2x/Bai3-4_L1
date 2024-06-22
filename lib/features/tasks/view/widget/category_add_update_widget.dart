import 'package:exercies3/common/model/category_entity.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/common/widgets/app_text_form_field.dart';
import 'package:exercies3/common/widgets/app_title_bottom_sheet.dart';
import 'package:exercies3/features/tasks/provider/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryAddUpdateWidget extends ConsumerStatefulWidget {
  final CategoryEntity? categoryUpdate;
  const CategoryAddUpdateWidget({super.key, this.categoryUpdate});

  @override
  ConsumerState<CategoryAddUpdateWidget> createState() =>
      _CategoryAddUpdateWidgetState();
}

class _CategoryAddUpdateWidgetState
    extends ConsumerState<CategoryAddUpdateWidget> {
  CategoryEntity? category;
  final GlobalKey<FormState> formKey = GlobalKey();
  late final TextEditingController _controller;

  @override
  void initState() {
    category = widget.categoryUpdate;
    _controller = TextEditingController();
    if (category != null) {
      _controller.text = category!.name;
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String icon = ref.watch(iconProviderFamily(category?.icon ?? iconPaths[0]));
    return Container(
      padding:
          EdgeInsets.only(left: 16.r, right: 16.r, top: 10.r, bottom: 50.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppTitleBottomSheet(
            name: "Tạo danh mục mới",
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              if (category == null) {
                ref.read(categoriesAsyncProvider.notifier).add(
                      _controller.text,
                      icon,
                    );
                Navigator.pop(context);
                return;
              }
              ref.read(categoriesAsyncProvider.notifier).updateCate(
                  id: category!.id, name: _controller.text, icon: icon);
              Navigator.pop(context);
              Navigator.pop(context);
            }),
        SizedBox(height: 10.h),
        Form(
          key: formKey,
          child: AppTextFormField(
            hintText: "Vui lòng nhập danh mục",
            autofocus: true,
            validator: (value) {
              if (value == null || value.length < 3) return "Vui lòng nhập trên 3 ký tự";
              return null;
            },
            controller: _controller,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "Biểu tượng",
          style: TextStyle(fontSize: 14.sp),
        ),
        SizedBox(height: 6.h),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 30.w,
              mainAxisSpacing: 10.w,
            ),
            itemCount: iconPaths.length,
            itemBuilder: (ctx, index) => GestureDetector(
              onTap: () {
                ref
                    .read(iconProviderFamily(category?.icon ?? iconPaths[0])
                        .notifier).state = iconPaths[index];
              },
              child: AppIcon(
                path: iconPaths[index],
                iconColor: icon == iconPaths[index] ? Colors.purple : null,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
