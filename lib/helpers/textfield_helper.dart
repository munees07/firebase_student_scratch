import 'package:flutter/material.dart';

TextFormField textFieldWidget(
    {required TextEditingController controller, required String text}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(hintText: text),
  );
}
