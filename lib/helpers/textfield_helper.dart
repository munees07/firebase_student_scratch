import 'package:flutter/material.dart';

TextFormField textFieldWidget(
    {required TextEditingController controller, required String text}) {
  return TextFormField(
    // style: const TextStyle(color: Colors.white),
    controller: controller,
    decoration: InputDecoration(
      hintText: text,
      // hintStyle: const TextStyle(color: Colors.white)
    ),
  );
}
