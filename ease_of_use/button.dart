import 'package:flutter/material.dart';

Widget button( //buttons to be used in code
    String buttonText, Color buttonColor, void Function()? buttonPressed, double width, double height) {
  return Container(
    width: width,
    height: height,
    padding: const EdgeInsets.all(0),
    child: ElevatedButton(
      onPressed: buttonPressed,
      style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          backgroundColor: buttonColor),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 27, color: Colors.white),
      ),
    ),
  );
}
