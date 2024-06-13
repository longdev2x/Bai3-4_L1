import 'package:exercies3/common/image_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTwoLightWidget extends StatelessWidget {
  const AuthTwoLightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            ImageRes.imgLight,
            height: 195.h,
            fit: BoxFit.fitHeight,
          ),
          Image.asset(
            ImageRes.imgLight,
            height: 150.h,
            fit: BoxFit.fitHeight,
          ),
        ],
      ),
    );
  }
}
