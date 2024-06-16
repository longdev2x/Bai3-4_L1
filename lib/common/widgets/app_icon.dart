import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppIcon extends StatelessWidget {
  final String path;
  final double? size;
  final Color? iconColor;
  const AppIcon({
    super.key,
    required this.path,
    this.size = 22,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size!.w,
      child: Image.asset(
        path,
        color: iconColor,
      ),
    );
  }
}
