import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final String? hintText;
  final bool? isPass;
  final bool? autofocus;
  final String? initialValue;
  final String? Function(String? value)? validator;
  final Function(String? value)? onChanged;
  final TextEditingController? controller;
  const AppTextFormField({
    super.key,
    this.hintText = "",
    this.isPass = false,
    this.validator,
    this.onChanged,
    this.initialValue,
    this.autofocus = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      obscureText: isPass!,
      initialValue: initialValue,
      autofocus: autofocus ?? false,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: _customOutline(borderColor: Colors.blue),
        focusedBorder: _customOutline(),
        errorBorder: _customOutline(borderColor: Colors.red),
        focusedErrorBorder: _customOutline(borderColor: Colors.red),
        disabledBorder: _customOutline(),
      ),
    );
  }

  OutlineInputBorder _customOutline({Color borderColor = Colors.black}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: borderColor,
      ),
    );
  }
}
