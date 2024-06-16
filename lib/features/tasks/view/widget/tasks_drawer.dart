import 'package:exercies3/common/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskDrawer extends StatelessWidget {
  const TaskDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 310.w,
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.only(top: 60.h, left: 10.w),
            child: Text(
              "Todo with Long",
              style: TextStyle(
                  fontSize: 35.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.bgButton),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.star),
            title: const Text("Start Task"),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.one_k),
            title: const Text("Thói quen"),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.category),
            title: const Text("Thể loại"),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.mode),
            title: const Text("Chủ đề"),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.u_turn_right),
            title: const Text("Tiện ích"),
          ),
        ],
      ),
    );
  }
}
