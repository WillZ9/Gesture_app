import 'package:flutter/material.dart';
import 'package:gesture_app/difficulty/easy.dart';
import 'package:gesture_app/difficulty/medium.dart';
import 'package:gesture_app/difficulty/hard.dart';
import 'package:gesture_app/ease_of_use/button.dart';
import 'package:gesture_app/ease_of_use/textStyle.dart';
import 'package:gesture_app/history.dart';

class Game extends StatefulWidget {
  const Game({super.key, required this.title, required this.historyData});
  final String title;
  final HistoryData historyData;

  @override
  State<Game> createState() => _GameDisplay();
}

class _GameDisplay extends State<Game> with TickerProviderStateMixin {
  var score = <Duration>[];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    if (widget.title == 'Easy') {
      return Scaffold(
        appBar: AppBar(backgroundColor: const Color.fromARGB(255, 11, 190, 71)),
        backgroundColor: const Color.fromARGB(255, 175, 244, 198),
        body: Center(
            child: Column(
          children: [
            textStyle('Time', screenHeight * 0.1),
            SizedBox(height: screenHeight * 0.02),
            button(
              '1:00',
              const Color.fromARGB(255, 11, 190, 71),
              () => _navToEasy(const Duration(minutes: 1)),
              screenWidth * 0.5,
              screenHeight * 0.1,
            ),
            SizedBox(height: screenHeight * 0.02),
            button(
              '2:00',
              const Color.fromARGB(255, 11, 190, 71),
              () => _navToEasy(const Duration(minutes: 2)),
              screenWidth * 0.5,
              screenHeight * 0.1,
            ),
            SizedBox(height: screenHeight * 0.02),
            button(
              '5:00',
              const Color.fromARGB(255, 11, 190, 71),
              () => _navToEasy(const Duration(minutes: 5)),
              screenWidth * 0.5,
              screenHeight * 0.1,
            ),
            SizedBox(height: screenHeight * 0.08),
            Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.3,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromARGB(255, 11, 190, 71),
                ),
                padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.05,
                    screenHeight * 0.05,
                    screenWidth * 0.05,
                    screenHeight * 0.05),
                child: textStyle(
                    'Dark blue: TAP\n\nGray: HOLD FOR ENTIRE DURATION', 25)),
          ],
        )),
      );
    } else if (widget.title == 'Medium') {
      return Scaffold(
        appBar:
            AppBar(backgroundColor: const Color.fromARGB(255, 255, 205, 42)),
        backgroundColor: const Color.fromARGB(255, 255, 232, 164),
        body: Center(
            child: Column(
          children: [
            textStyle('Time', screenHeight * 0.1),
            SizedBox(height: screenHeight * 0.02),
            button(
              '1:00',
              const Color.fromARGB(255, 255, 205, 42),
              () => _navToMedium(const Duration(minutes: 1)),
              screenWidth * 0.5,
              screenHeight * 0.1,
            ),
            SizedBox(height: screenHeight * 0.02),
            button(
              '2:00',
              const Color.fromARGB(255, 255, 205, 42),
              () => _navToMedium(const Duration(minutes: 2)),
              screenWidth * 0.5,
              screenHeight * 0.1,
            ),
            SizedBox(height: screenHeight * 0.02),
            button(
              '5:00',
              const Color.fromARGB(255, 255, 205, 42),
              () => _navToMedium(const Duration(minutes: 5)),
              screenWidth * 0.5,
              screenHeight * 0.1,
            ),
            SizedBox(height: screenHeight * 0.08),
            Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.3,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromARGB(255, 255, 205, 42),
                ),
                padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.05,
                    screenHeight * 0.05,
                    screenWidth * 0.05,
                    screenHeight * 0.05),
                child: textStyle(
                    'Dark blue: TAP\n\nLight Blue: DOUBLE TAP\n\nGray: HOLD FOR ENTIRE DURATION',
                    25)),
          ],
        )),
      );
    } else {
      return Scaffold(
        appBar: AppBar(backgroundColor: const Color.fromARGB(255, 242, 72, 34)),
        backgroundColor: const Color.fromARGB(255, 255, 199, 194),
        body: Center(
            child: Column(
          children: [
            textStyle('Time', screenHeight * 0.1),
            SizedBox(height: screenHeight * 0.02),
            button(
              '1:00',
              const Color.fromARGB(255, 242, 72, 34),
              () => _navToHard(const Duration(minutes: 1)),
              screenWidth * 0.5,
              screenHeight * 0.1,
            ),
            SizedBox(height: screenHeight * 0.02),
            button(
              '2:00',
              const Color.fromARGB(255, 242, 72, 34),
              () => _navToHard(const Duration(minutes: 2)),
              screenWidth * 0.5,
              screenHeight * 0.1,
            ),
            SizedBox(height: screenHeight * 0.02),
            button(
              '5:00',
              const Color.fromARGB(255, 242, 72, 34),
              () => _navToHard(const Duration(minutes: 5)),
              screenWidth * 0.5,
              screenHeight * 0.1,
            ),
            SizedBox(height: screenHeight * 0.08),
            Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.3,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromARGB(255, 242, 72, 34),
                ),
                padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.05,
                    screenHeight * 0.01,
                    screenWidth * 0.05,
                    screenHeight * 0.01),
                child: textStyle(
                    'Dark blue: TAP\n\nLight Blue: DOUBLE TAP\n\nGray: HOLD FOR ENTIRE DURATION\n\nNavy Blue: SWIPE',
                    25)),
          ],
        )),
      );
    }
  }

  void _navToEasy(Duration time) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Easy(time: time, historyData: widget.historyData);
    }));
  }

  void _navToMedium(Duration time) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Medium(time: time, historyData: widget.historyData);
    }));
  }

  void _navToHard(Duration time) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Hard(time: time, historyData: widget.historyData);
    }));
  }
}
