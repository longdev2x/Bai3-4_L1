import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTitle extends StatelessWidget {
  const AuthTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Sign In",
      style: TextStyle(fontSize: 38.sp, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}