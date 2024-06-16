import 'package:flutter/material.dart';

class AppConfirm extends StatelessWidget {
  final String title;
  final Function() onConfirm;
  const AppConfirm({super.key, required this.title, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: [
        ElevatedButton(onPressed: () {
          Navigator.pop(context);
        }, child: const Text("Huỷ")),
        ElevatedButton(onPressed: onConfirm, child: const Text("Okay"))
      ],
    );
  }
}