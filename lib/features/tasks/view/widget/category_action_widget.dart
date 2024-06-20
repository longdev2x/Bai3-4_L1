import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryActionWidget extends StatelessWidget {
  final Function() onTapUpdate;
  final Function() onTapDelete;
  const CategoryActionWidget({
    super.key,
    required this.onTapUpdate,
    required this.onTapDelete,
  });

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
              border: const Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.r, vertical: 10.r),
            child: Column(children: [
              ListTile(
                onTap: onTapUpdate,
                leading: const AppIcon(path: ImageRes.icUpdate),
                title: const Text("Chỉnh sửa"),
                trailing: const AppIcon(path: ImageRes.icArrowRight),
              ),
              ListTile(
                onTap: onTapDelete,
                leading: const AppIcon(path: ImageRes.icDelete),
                title: const Text("Xoá"),
              ),
            ]),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Huỷ", style: TextStyle(fontSize: 16.sp),))
        ],
      ),
    );
  }
}
