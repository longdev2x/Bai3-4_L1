import 'package:exercies3/common/model/category_entity.dart';
import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:exercies3/common/widgets/app_text_form_field.dart';
import 'package:exercies3/features/tasks/provider/categories_provider.dart';
import 'package:exercies3/features/tasks/provider/icon_provider_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryAddUpdate extends ConsumerStatefulWidget {
  final CategoryEntity? categoryUpdate;
  const CategoryAddUpdate({super.key, this.categoryUpdate});

  @override
  ConsumerState<CategoryAddUpdate> createState() => _CategoryAddUpdateState();
}

class _CategoryAddUpdateState extends ConsumerState<CategoryAddUpdate> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    if (widget.categoryUpdate != null) {
      _controller.text = widget.categoryUpdate!.name;
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
    String icon = ref
        .watch(iconProviderFamily(widget.categoryUpdate?.icon ?? iconPaths[0]));
    return Container(
      padding:
          EdgeInsets.only(left: 16.r, right: 16.r, top: 10.r, bottom: 50.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const AppIcon(path: ImageRes.icClose)),
            Text(
              "Tạo danh mục mới",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  if (widget.categoryUpdate == null) {
                    ref.read(categoriesAsyncProvider.notifier).add(
                          _controller.text,
                          icon,
                        );
                    Navigator.pop(context);
                    return;
                  }
                  ref.read(categoriesAsyncProvider.notifier).updateCate(widget
                      .categoryUpdate!
                      .copyWith(name: _controller.text, icon: icon));
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: const AppIcon(path: ImageRes.icCheck)),
          ],
        ),
        SizedBox(height: 10.h),
        Form(
          key: formKey,
          child: AppTextFormField(
            hintText: "Vui lòng nhập danh mục",
            autofocus: true,
            validator: (value) {
              if (value == null || value.length < 3)
                return "Vui lòng nhập trên 3 ký tự";
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
                    .read(iconProviderFamily(
                            widget.categoryUpdate?.icon ?? iconPaths[0])
                        .notifier)
                    .updateIcon(iconPaths[index]);
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
