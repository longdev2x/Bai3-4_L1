import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTitleBottomSheet extends StatelessWidget {
  final String name;
  final Function() onPressed;
  const AppTitleBottomSheet({super.key, required this.name, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const AppIcon(path: ImageRes.icClose)),
        Text(
          name,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        IconButton(
            onPressed: onPressed, icon: const AppIcon(path: ImageRes.icCheck)),
      ],
    );
  }
}
