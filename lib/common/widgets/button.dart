import 'package:exercies3/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String? name;
  final Color? bgColor;
  final Color? textColor;
  final double? fontSize;
  final Function()? ontap;

  const ButtonWidget({
    super.key,
    this.ontap,
    this.height = 45,
    this.width = double.infinity,
    this.name = "",
    this.bgColor = AppColors.bgButton,
    this.textColor = Colors.white,
    this.fontSize = 19
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        alignment: Alignment.center,
        height: height!.h,
        width: width!.w,
        decoration: BoxDecoration(
          color: bgColor!,
          borderRadius: BorderRadius.circular(26)
        ),
        child: Text(
          name!,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: fontSize!.sp
          ),
        ),
      ),
    );
  }
}
