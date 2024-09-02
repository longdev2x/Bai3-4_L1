import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskCategoryHoriItem extends StatelessWidget {
  final String name;
  final bool isChose;
  final Function() onPressed;
  const TaskCategoryHoriItem({
    super.key,
    required this.onPressed,
    required this.name,
    required this.isChose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor:
                isChose ? const WidgetStatePropertyAll(Colors.black) : null,
            foregroundColor:
                isChose ? const WidgetStatePropertyAll(Colors.white) : null,
          ),
          child: Text(name),
        ),
        SizedBox(width: 10.w,)
      ],
    );
  }
}
