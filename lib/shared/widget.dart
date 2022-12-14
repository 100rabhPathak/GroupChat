import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xffee7b64), width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
);
void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 10),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: "OK",
        textColor: Colors.white,
        onPressed: () {},
      )));
}
