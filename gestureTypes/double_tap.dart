import 'package:flutter/material.dart';

Widget doubleTapFunc( //directly implementing gesture with a widget
  BuildContext context, 
  Color color, 
  void Function() onDoubleTap, 
  double width, 
  double height) 
{
  return GestureDetector(
    onDoubleTap: onDoubleTap,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Colors.white),
      ),
    ),
  );
}
