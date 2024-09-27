import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  String labelText;
  IconButton? suffixIcon;
  TextInputType? keytype;
  Icon? prefixIcon;
  bool sec;
  final FormFieldValidator<String>? valdiator;

  CustomTextFormField(
      {required this.controller,
      required this.title,
      this.valdiator,
      required this.labelText,
      this.suffixIcon,
      this.sec = false,
      this.prefixIcon,
      this.keytype});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      validator: valdiator,
      obscureText: sec,
      keyboardType: keytype,
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: EdgeInsets.only(top: 30, bottom: 10),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(fontSize: 24),
        hintText: title,
      ),
    );
  }
}
