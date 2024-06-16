import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryModalBottom extends StatelessWidget {
  final Function() onTapUpdate;
  final Function() onTapDelete;
  final Function() onTapCancle;
  const CategoryModalBottom({super.key, required this.onTapUpdate, required this.onTapDelete, required this.onTapCancle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              border: const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.r, vertical: 10.r),
            child: Column(children: [
              ListTile(
                onTap: onTapUpdate,
                leading: const Icon(Icons.update),
                title: const Text("Chỉnh sửa"),
                trailing: const Icon(Icons.arrow_right_alt),
              ),
              ListTile(
                onTap: onTapDelete,
                leading: const Icon(Icons.delete),
                title: const Text("Xoá"),
              ),
            ]),
          ),
          TextButton(onPressed: onTapCancle, child: const Text("Huỷ"))
        ],
      ),
    );
  }
}
