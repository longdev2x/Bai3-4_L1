import 'package:exercies3/common/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryAddUpdate extends StatefulWidget {
  const CategoryAddUpdate({super.key});

  @override
  State<CategoryAddUpdate> createState() => _CategoryAddUpdateState();
}

class _CategoryAddUpdateState extends State<CategoryAddUpdate> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 16.r,
          right: 16.r,
          top: 10.r,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
            const Text("Tạo danh mục mới"),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.confirmation_num)),
          ],
        ),
        SizedBox(height: 10.h),
        AppTextFormField(
          hintText: "Vui lòng nhập danh mục",
          autofocus: true,
          controller: _controller,
        ),
        const Text("Biểu tượng"),
      ]),
    );
  }
}
