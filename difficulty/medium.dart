import 'package:flutter/material.dart';
import 'package:gesture_app/ease_of_use/button.dart';
import 'package:gesture_app/gestureTypes/tap.dart';
import 'package:gesture_app/gestureTypes/hold.dart';
import 'package:gesture_app/gestureTypes/double_tap.dart';
import 'package:gesture_app/ease_of_use/textStyle.dart';
import 'package:gesture_app/history.dart';
import 'package:gesture_app/result.dart';
import 'dart:math';
import 'dart:async';

class Medium extends StatefulWidget {
  const Medium({Key? key, required this.time, required this.historyData})
      : super(key: key);
  final Duration time;
  final HistoryData historyData;

  @override
  State<Medium> createState() => _MediumState();
}

class _MediumState extends State<Medium> with TickerProviderStateMixin {
  final Random random = Random();
  final List<bool> _tapVisible = List.generate(4, (index) => false);
  final List<bool> _doubleTapVisible = List.generate(4, (index) => false);
  final List<bool> _holdVisible = List.generate(4, (index) => false);
  late Timer gameDuration;
  late List<Timer> timers;
  late List<void Function()> scheduleButton;
  late Duration time;
  Duration holdTime = const Duration();
  Map<int, DateTime> startTime = {};
  var score =
      <Duration>[]; //remove all reaction speeds less than 150 milliseconds
  int deduct = 0;
  bool isPaused = false;

  @override
  void initState() {
    timers = List.generate(4, (index) => Timer(const Duration(), () {}));

    scheduleButton = [
      _scheduleButtonAppearance1,
      _scheduleButtonAppearance2,
      _scheduleButtonAppearance3,
      _scheduleButtonAppearance4,
    ];
    for (var function in scheduleButton) {
      function();
    }

    time = widget.time;
    gameDuration = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      updateTimer(timer);
    });

    holdTime = Duration(milliseconds: random.nextInt(500) + 2000);

    super.initState();
  }

  @override
  void dispose() {
    gameDuration.cancel();
    for (Timer time in timers) {
      time.cancel();
    }
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
        for (int i = 0; i < 4; i++) {
          _tapVisible[i] = false;
          _holdVisible[i] = false;
          _doubleTapVisible[i] = false;
        }
        for (Timer time in timers) {
          time.cancel();
        }
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
            deduct: deduct,
            historyData: widget.historyData,
          );
        }));
      });

  void _tap(int buttonNum) {
    //backend processing for tap. calculates and adds raw time of player reactoin and schedules next button appearance
    score.add(DateTime.now().difference(startTime[buttonNum]!));
    if (!isPaused) {
      setState(() {
        _tapVisible[buttonNum - 1] = false;
        scheduleButton[buttonNum - 1]();
      });
    }
  }

  void _doubleTap(int buttonNum) {
    //backend processing for tap. calculates and adds raw time of player reactoin and schedules next button appearance
    score.add(DateTime.now().difference(startTime[buttonNum]!));
    if (!isPaused) {
      setState(() {
        _doubleTapVisible[buttonNum - 1] = false;
        scheduleButton[buttonNum - 1]();
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
        _holdVisible[buttonNum - 1] = false;
        scheduleButton[buttonNum - 1]();
      });
    }
  }

  void _cancel(int buttonNum) {
    deduct++;
    if (!isPaused) {
      setState(() {
        _holdVisible[buttonNum - 1] = false;
        scheduleButton[buttonNum - 1]();
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
            Row(
              children: [
                Stack(
                  //Button 1
                  children: <Widget>[
                    button(
                      '',
                      const Color.fromARGB(255, 255, 205, 42),
                      () => _incorrectPress(),
                      screenWidth * 0.5,
                      screenHeight * 0.5,
                    ),
                    if (_tapVisible[
                        0]) //displays gesture-wrapped container for tap
                      tapFunc(
                        context,
                        Colors.blueAccent,
                        () => _tap(
                            1), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * 0.5,
                      ),
                    if (_holdVisible[
                        0]) //displays gesture-wrapped container for hold
                      HoldFunc(
                        color: const Color.fromARGB(255, 255, 205, 42),
                        lifespan: holdTime,
                        onHold: () => _hold(1),
                        onRelease: () => _release(1),
                        cancel: () => _cancel(1),
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.5,
                      ),
                    if (_doubleTapVisible[0])
                      doubleTapFunc(
                        context,
                        const Color.fromARGB(255, 31, 233, 233),
                        () => _doubleTap(
                            1), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * 0.5,
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
                  //Button 2
                  children: <Widget>[
                    button(
                      '',
                      const Color.fromARGB(255, 255, 232, 164),
                      () => _incorrectPress(),
                      screenWidth * 0.5,
                      screenHeight * 0.5,
                    ),
                    if (_tapVisible[
                        1]) //displays gesture-wrapped container for tap
                      tapFunc(
                        context,
                        Colors.blueAccent,
                        () => _tap(
                            2), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * 0.5,
                      ),
                    if (_holdVisible[
                        1]) //displays gesture-wrapped container for hold
                      HoldFunc(
                        color: const Color.fromARGB(255, 255, 232, 164),
                        lifespan: holdTime,
                        onHold: () => _hold(2),
                        onRelease: () => _release(2),
                        cancel: () => _cancel(2),
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.5,
                      ),
                    if (_doubleTapVisible[1])
                      doubleTapFunc(
                        context,
                        const Color.fromARGB(255, 31, 233, 233),
                        () => _doubleTap(
                            2), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * 0.5,
                      ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Stack(
                  //Button 3
                  children: <Widget>[
                    button(
                      '',
                      const Color.fromARGB(255, 255, 232, 164),
                      () => _incorrectPress(),
                      screenWidth * 0.5,
                      screenHeight * 0.5,
                    ),
                    if (_tapVisible[
                        2]) //displays gesture-wrapped container for tap
                      tapFunc(
                        context,
                        Colors.blueAccent,
                        () => _tap(
                            3), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * 0.5,
                      ),
                    if (_holdVisible[
                        2]) //displays gesture-wrapped container for hold. A lot more complicated than tap
                      HoldFunc(
                        color: const Color.fromARGB(255, 255, 232, 164),
                        lifespan: holdTime,
                        onHold: () => _hold(3),
                        onRelease: () => _release(3),
                        cancel: () => _cancel(3),
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.5,
                      ),
                    if (_doubleTapVisible[2])
                      doubleTapFunc(
                        context,
                        const Color.fromARGB(255, 31, 233, 233),
                        () => _doubleTap(
                            3), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * 0.5,
                      ),
                  ],
                ),
                Stack(
                  //Buttton 4
                  children: <Widget>[
                    button(
                      '',
                      const Color.fromARGB(255, 255, 205, 42),
                      () => _incorrectPress(),
                      screenWidth * 0.5,
                      screenHeight * 0.5,
                    ),
                    if (_tapVisible[
                        3]) //displays gesture-wrapped container for tap
                      tapFunc(
                        context,
                        Colors.blueAccent,
                        () => _tap(
                            4), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * 0.5,
                      ),
                    if (_holdVisible[
                        3]) //displays gesture-wrapped container for hold. A lot more complicated than tap
                      HoldFunc(
                        color: const Color.fromARGB(255, 255, 205, 42),
                        lifespan: holdTime,
                        onHold: () => _hold(4),
                        onRelease: () => _release(4),
                        cancel: () => _cancel(4),
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.5,
                      ),
                    if (_doubleTapVisible[3])
                      doubleTapFunc(
                        context,
                        const Color.fromARGB(255, 31, 233, 233),
                        () => _doubleTap(
                            4), //passes double tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * 0.5,
                      ),
                  ],
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
    int temp = random.nextInt(3);
    if (!isPaused) {
      timers[0] = Timer(
          randomDuration(5),
          () => setState(() {
                if (temp == 0) {
                  _tapVisible[0] = true;
                } else if (temp == 1) {
                  _holdVisible[0] = true;
                } else {
                  _doubleTapVisible[0] = true;
                }
                startTime[1] = DateTime.now();
              }));
    }
  }

  void _scheduleButtonAppearance2() {
    //randomely schedule and select button 2
    int temp = random.nextInt(3);
    if (!isPaused) {
      timers[1] = Timer(
          randomDuration(5),
          () => setState(() {
                if (temp == 0) {
                  _tapVisible[1] = true;
                } else if (temp == 1) {
                  _holdVisible[1] = true;
                } else {
                  _doubleTapVisible[1] = true;
                }
                startTime[2] = DateTime.now();
              }));
    }
  }

  void _scheduleButtonAppearance3() {
    //randomely schedule and select button 2
    int temp = random.nextInt(3);
    if (!isPaused) {
      timers[2] = Timer(
          randomDuration(5),
          () => setState(() {
                if (temp == 0) {
                  _tapVisible[2] = true;
                } else if (temp == 1) {
                  _holdVisible[2] = true;
                } else {
                  _doubleTapVisible[2] = true;
                }
                startTime[3] = DateTime.now();
              }));
    }
  }

  void _scheduleButtonAppearance4() {
    //randomely schedule and select button 2
    int temp = random.nextInt(3);
    if (!isPaused) {
      timers[3] = Timer(
          randomDuration(5),
          () => setState(() {
                if (temp == 0) {
                  _tapVisible[3] = true;
                } else if (temp == 1) {
                  _holdVisible[3] = true;
                } else {
                  _doubleTapVisible[3] = true;
                }
                startTime[4] = DateTime.now();
              }));
    }
  }
}
