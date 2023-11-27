import 'package:flutter/material.dart';
import 'package:gesture_app/ease_of_use/button.dart';
import 'package:gesture_app/gestureTypes/tap.dart';
import 'package:gesture_app/gestureTypes/hold.dart';
import 'package:gesture_app/ease_of_use/textStyle.dart';
import 'package:gesture_app/history.dart';
import 'package:gesture_app/result.dart';
import 'dart:math';
import 'dart:async';

class Easy extends StatefulWidget {
  const Easy({Key? key, required this.time, required this.historyData})
      : super(key: key);
  final Duration time;
  final HistoryData historyData;

  @override
  State<Easy> createState() => _EasyState();
}

class _EasyState extends State<Easy> with TickerProviderStateMixin {
  final Random random = Random();
  bool _tap1Visible = false;
  bool _tap2Visible = false;
  bool _hold1Visible = false;
  bool _hold2Visible = false;
  Map<int, DateTime> startTime = {};
  late Timer gameDuration;
  late Timer timer1;
  late Timer timer2;
  late Duration time;
  Duration holdTime = const Duration();
  var score = <Duration>[]; //remove all reaction speeds less than 0.05 seconds
  int deduct = 0;
  bool isPaused = false;

  @override
  void initState() {
    time = widget.time;
    gameDuration = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      updateTimer(timer);
    });
    if (!isPaused) {
      holdTime = Duration(milliseconds: random.nextInt(500) + 2000);
      _scheduleButtonAppearance1();
      _scheduleButtonAppearance2();
    }
    super.initState();
  }

  @override
  void dispose() {
    gameDuration.cancel();
    timer1.cancel();
    timer2.cancel();
    super.dispose();
  }

  void updateTimer(Timer timer) async {
    setState(() {
      if (time.inSeconds > 0) {
        time = time - const Duration(seconds: 1);
      } else {
        stop();
        timer.cancel();
        // Stop the timer when countdown reaches 0
      }
    });
  }

  void stop() => setState(() {
        isPaused = true;
        _tap1Visible = false;
        _tap2Visible = false;
        _hold1Visible = false;
        _hold2Visible = false;
        timer1.cancel();
        timer2.cancel();
        gameDuration.cancel();
        for (int i = score.length - 1; i >= 0; i--) {
          if (score[i] < const Duration(milliseconds: 150)) {
            score.removeAt(i);
            i--;
          }
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Result(
            score: score,
            historyData: widget.historyData,
            deduct: deduct,
          );
        }));
      });

  void _tap(int buttonNum) {
    //backend processing for tap. calculates and adds raw time of player reactoin and schedules next button appearance
    score.add(DateTime.now().difference(startTime[buttonNum]!));
    if (!isPaused) {
      setState(() {
        if (buttonNum == 1) {
          _tap1Visible = false;
          _scheduleButtonAppearance1();
        } else {
          _tap2Visible = false;
          _scheduleButtonAppearance2();
        }
      });
    }
  }

  void _hold(int buttonNum) {
    //backend processing for hold.
    score.add(DateTime.now().difference(startTime[buttonNum]!));
  }

  void _release(int buttonNum) {
    holdTime = Duration(milliseconds: random.nextInt(500) + 2000);
    if (!isPaused) {
      setState(() {
        if (buttonNum == 1) {
          _hold1Visible = false;
          _scheduleButtonAppearance1();
        } else {
          _hold2Visible = false;
          _scheduleButtonAppearance2();
        }
      });
    }
  }

  void _cancel(int buttonNum) {
    deduct++;
    if (!isPaused) {
      setState(() {
        if (buttonNum == 1) {
          _hold1Visible = false;
          _scheduleButtonAppearance1();
        } else {
          _hold2Visible = false;
          _scheduleButtonAppearance2();
        }
      });
    }
  }

  void _incorrectPress() => deduct++;

  Duration randomDuration(int min) =>
      Duration(seconds: random.nextInt(min) + 2);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                button(
                  '',
                  const Color.fromARGB(255, 175, 244, 198),
                  () => _incorrectPress(),
                  screenWidth,
                  screenHeight * 0.5,
                ),
                if (_tap1Visible) //displays gesture-wrapped container for tap
                  tapFunc(
                    context,
                    Colors.blueAccent,
                    () => _tap(
                        1), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                    screenWidth,
                    screenHeight * 0.5,
                  ),
                if (_hold1Visible) //displays gesture-wrapped container for hold
                  HoldFunc(
                    color: const Color.fromARGB(255, 175, 244, 198),
                    lifespan: holdTime,
                    onHold: () => _hold(1),
                    onRelease: () => _release(1),
                    cancel: () => _cancel(1),
                    width: screenWidth,
                    height: screenHeight * 0.5,
                  ),
                Positioned(
                  top: screenHeight * 0.02,
                  left: screenWidth * 0.02,
                  child: IgnorePointer(
                    child: textStyle(
                        '${time.inMinutes}:${(time.inSeconds % 60).toString().padLeft(2, '0')}',
                        screenHeight * 0.1),
                  ),
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                button(
                  '',
                  const Color.fromARGB(255, 11, 190, 71),
                  () => _incorrectPress(),
                  screenWidth,
                  screenHeight * 0.5,
                ),
                if (_tap2Visible) //displays gesture-wrapped container for tap
                  tapFunc(
                    context,
                    Colors.blueAccent,
                    () => _tap(
                        2), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                    screenWidth,
                    screenHeight * 0.5,
                  ),
                if (_hold2Visible) //displays gesture-wrapped container for hold. A lot more complicated than tap
                  HoldFunc(
                    color: const Color.fromARGB(255, 11, 190, 71),
                    lifespan: holdTime,
                    onHold: () => _hold(2),
                    onRelease: () => _release(2),
                    cancel: () => _cancel(2),
                    width: screenWidth,
                    height: screenHeight * 0.5,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _scheduleButtonAppearance1() {
    //randomely schedule and select button 1
    if (!isPaused) {
      timer1 = Timer(
          randomDuration(5),
          () => setState(() {
                if (random.nextInt(2) == 0) {
                  _tap1Visible = true;
                } else {
                  _hold1Visible = true;
                }
                startTime[1] = DateTime.now();
              }));
    }
  }

  void _scheduleButtonAppearance2() {
    //randomely schedule and select button 2
    if (!isPaused) {
      timer2 = Timer(
          randomDuration(5),
          () => setState(() {
                if (random.nextInt(2) == 0) {
                  _tap2Visible = true;
                } else {
                  _hold2Visible = true;
                }
                startTime[2] = DateTime.now();
              }));
    }
  }
}
