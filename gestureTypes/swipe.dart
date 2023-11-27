import 'package:flutter/material.dart';
import 'package:swipe_widget/swipe_widget.dart';


Widget swipeFunc( //directly implementing gesture with a widget
  BuildContext context, 
  Color color, 
  void Function() onSwipe, 
  double width, 
  double height) 
{
  return SwipeWidget(
    onSwipe: onSwipe,
    dragStrenght: 0.5,
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
