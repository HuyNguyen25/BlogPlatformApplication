import 'package:flutter/material.dart';

final inputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  hintText:"example",
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black26, width: 1.5),
    borderRadius: BorderRadius.circular(15.0)
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
      borderRadius: BorderRadius.circular(15.0)
  ),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.5),
      borderRadius: BorderRadius.circular(15.0)
  ),
);

final popUpTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 20,
  color: Colors.black
);

