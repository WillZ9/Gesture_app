import 'package:flutter/material.dart';

Widget tapFunc( //directly implementing gesture with a widget
  BuildContext context, 
  Color color, 
  void Function() onTap, 
  double width, 
  double height) 
{
  return GestureDetector(
    onTap: onTap,
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
