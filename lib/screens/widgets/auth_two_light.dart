import 'package:exercies3/common/image_res.dart';
import 'package:exercies3/common/widgets/app_slide_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTwoLightWidget extends StatefulWidget {
  const AuthTwoLightWidget({super.key});

  @override
  State<AuthTwoLightWidget> createState() => _AuthTwoLightWidgetState();
}

class _AuthTwoLightWidgetState extends State<AuthTwoLightWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSlideTransiton(
            isRepeat: true,
            child: Image.asset(
              ImageRes.imgLight,
              height: 195.h,
              fit: BoxFit.fitHeight,
            ),
          ),
          AppSlideTransiton(
            isRepeat: true,
            curve: Curves.bounceInOut,
            child: Image.asset(
              ImageRes.imgLight,
              height: 150.h,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }
}
