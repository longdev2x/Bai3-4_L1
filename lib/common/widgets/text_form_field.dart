import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String? hintText;
  final bool? isPass;
  final String? initialValue;
  final String? Function(String? value)? validator;
  final Function(String? value)? onChanged;
  const TextFormFieldWidget({
    super.key,
    this.hintText = "",
    this.isPass = false,
    this.validator,
    this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      obscureText: isPass!,
      initialValue: initialValue,
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
