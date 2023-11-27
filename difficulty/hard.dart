import 'package:flutter/material.dart';
import 'package:gesture_app/ease_of_use/button.dart';
import 'package:gesture_app/gestureTypes/tap.dart';
import 'package:gesture_app/gestureTypes/hold.dart';
import 'package:gesture_app/gestureTypes/double_tap.dart';
import 'package:gesture_app/gestureTypes/swipe.dart';
import 'package:gesture_app/ease_of_use/textStyle.dart';
import 'package:gesture_app/history.dart';
import 'package:gesture_app/result.dart';
import 'dart:math';
import 'dart:async';

class Hard extends StatefulWidget {
  const Hard({Key? key, required this.time, required this.historyData})
      : super(key: key);
  final Duration time;
  final HistoryData historyData;

  @override
  State<Hard> createState() => _HardState();
}

class _HardState extends State<Hard> with TickerProviderStateMixin {
  final Random random = Random();
  final List<bool> _tapVisible = List.generate(6, (index) => false);
  final List<bool> _doubleTapVisible = List.generate(6, (index) => false);
  final List<bool> _holdVisible = List.generate(6, (index) => false);
  final List<bool> _swipeVisible = List.generate(6, (index) => false);
  late List<Timer> timers;
  late List<void Function()> scheduleButton;
  Map<int, DateTime> startTime = {};
  late Timer gameDuration;
  late Duration time;
  Duration holdTime = const Duration();
  var score =
      <Duration>[]; //remove all reaction speeds less than 150 milliseconds
  int deduct = 0;
  bool isPaused = false;

  @override
  void initState() {
    timers = List.generate(6, (index) => Timer(const Duration(), () {}));

    scheduleButton = [
      _scheduleButtonAppearance1,
      _scheduleButtonAppearance2,
      _scheduleButtonAppearance3,
      _scheduleButtonAppearance4,
      _scheduleButtonAppearance5,
      _scheduleButtonAppearance6,
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

  void stop() { //HUGE ISSUE THAT I WASN'T ABLE TO SOLVE: WHEN USER HOLDS DOWN SWIPED CONTAINER,
    setState(() {//AND GAME STOPS, ERRORS WILL OCCUR DUE TO THE ANIMATION STILL BEING PLAYED
      for (int i = 0; i < 6; i++) {
        _swipeVisible[i] = false;
      }
    });
    setState(() {
      isPaused = true;
      for (Timer time in timers) {
        time.cancel();
      }
      for (int i = 0; i < 6; i++) {
        _tapVisible[i] = false;
        _doubleTapVisible[i] = false;
        _holdVisible[i] = false;
        _swipeVisible[i] = false;
      }
      gameDuration.cancel();
      for (int i = score.length - 1; i >= 0; i--) {
        if (score[i] < const Duration(milliseconds: 150)) {
          score.removeAt(i);
          i--;
        }
      }
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Result(
        score: score,
        historyData: widget.historyData,
        deduct: deduct,
      );
    }));
  }

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

  void _swipe(int buttonNum) {
    score.add(DateTime.now().difference(startTime[buttonNum]!));
    if (!isPaused) {
      setState(() {
        _swipeVisible[buttonNum - 1] = false;
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
                      const Color.fromARGB(255, 242, 72, 34),
                      () => _incorrectPress(),
                      screenWidth * 0.5,
                      screenHeight * (1 / 3),
                    ),
                    if (_tapVisible[
                        0]) //displays gesture-wrapped container for tap
                      tapFunc(
                        context,
                        Colors.blueAccent,
                        () => _tap(
                            1), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                    if (_holdVisible[
                        0]) //displays gesture-wrapped container for hold
                      HoldFunc(
                        color: const Color.fromARGB(255, 242, 72, 34),
                        lifespan: holdTime,
                        onHold: () => _hold(1),
                        onRelease: () => _release(1),
                        cancel: () => _cancel(1),
                        width: screenWidth * 0.5,
                        height: screenHeight * (1 / 3),
                      ),
                    if (_doubleTapVisible[0])
                      doubleTapFunc(
                        context,
                        const Color.fromARGB(255, 31, 233, 233),
                        () => _doubleTap(
                            1), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                    if (_swipeVisible[0])
                      swipeFunc(
                        context,
                        const Color.fromARGB(255, 3, 19, 19),
                        () => _swipe(
                            1), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
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
                      const Color.fromARGB(255, 255, 199, 194),
                      () => _incorrectPress(),
                      screenWidth * 0.5,
                      screenHeight * (1 / 3),
                    ),
                    if (_tapVisible[
                        1]) //displays gesture-wrapped container for tap
                      tapFunc(
                        context,
                        Colors.blueAccent,
                        () => _tap(
                            2), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                    if (_holdVisible[
                        1]) //displays gesture-wrapped container for hold
                      HoldFunc(
                        color: const Color.fromARGB(255, 255, 199, 194),
                        lifespan: holdTime,
                        onHold: () => _hold(2),
                        onRelease: () => _release(2),
                        cancel: () => _cancel(2),
                        width: screenWidth * 0.5,
                        height: screenHeight * (1 / 3),
                      ),
                    if (_doubleTapVisible[1])
                      doubleTapFunc(
                        context,
                        const Color.fromARGB(255, 31, 233, 233),
                        () => _doubleTap(
                            2), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                    if (_swipeVisible[1])
                      swipeFunc(
                        context,
                        const Color.fromARGB(255, 3, 19, 19),
                        () => _swipe(
                            2), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
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
                      const Color.fromARGB(255, 255, 199, 194),
                      () => _incorrectPress(),
                      screenWidth * 0.5,
                      screenHeight * (1 / 3),
                    ),
                    if (_tapVisible[
                        2]) //displays gesture-wrapped container for tap
                      tapFunc(
                        context,
                        Colors.blueAccent,
                        () => _tap(
                            3), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                    if (_holdVisible[
                        2]) //displays gesture-wrapped container for hold. A lot more complicated than tap
                      HoldFunc(
                        color: const Color.fromARGB(255, 255, 199, 194),
                        lifespan: holdTime,
                        onHold: () => _hold(3),
                        onRelease: () => _release(3),
                        cancel: () => _cancel(3),
                        width: screenWidth * 0.5,
                        height: screenHeight * (1 / 3),
                      ),
                    if (_doubleTapVisible[2])
                      doubleTapFunc(
                        context,
                        const Color.fromARGB(255, 31, 233, 233),
                        () => _doubleTap(
                            3), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                    if (_swipeVisible[2])
                      swipeFunc(
                        context,
                        const Color.fromARGB(255, 3, 19, 19),
                        () => _swipe(
                            3), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                  ],
                ),
                Stack(
                  //Button 4
                  children: <Widget>[
                    button(
                      '',
                      const Color.fromARGB(255, 242, 72, 34),
                      () => _incorrectPress(),
                      screenWidth * 0.5,
                      screenHeight * (1 / 3),
                    ),
                    if (_tapVisible[
                        3]) //displays gesture-wrapped container for tap
                      tapFunc(
                        context,
                        Colors.blueAccent,
                        () => _tap(
                            4), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                    if (_holdVisible[
                        3]) //displays gesture-wrapped container for hold. A lot more complicated than tap
                      HoldFunc(
                        color: const Color.fromARGB(255, 242, 72, 34),
                        lifespan: holdTime,
                        onHold: () => _hold(4),
                        onRelease: () => _release(4),
                        cancel: () => _cancel(4),
                        width: screenWidth * 0.5,
                        height: screenHeight * (1 / 3),
                      ),
                    if (_doubleTapVisible[3])
                      doubleTapFunc(
                        context,
                        const Color.fromARGB(255, 31, 233, 233),
                        () => _doubleTap(
                            4), //passes double tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                    if (_swipeVisible[3])
                      swipeFunc(
                        context,
                        const Color.fromARGB(255, 3, 19, 19),
                        () => _swipe(
                            4), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Stack(
                  //Button 5
                  children: <Widget>[
                    button(
                      '',
                      const Color.fromARGB(255, 242, 72, 34),
                      () => _incorrectPress(),
                      screenWidth * 0.5,
                      screenHeight * (1 / 3),
                    ),
                    if (_tapVisible[
                        4]) //displays gesture-wrapped container for tap
                      tapFunc(
                        context,
                        Colors.blueAccent,
                        () => _tap(
                            5), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                    if (_holdVisible[
                        4]) //displays gesture-wrapped container for hold. A lot more complicated than tap
                      HoldFunc(
                        color: const Color.fromARGB(255, 242, 72, 34),
                        lifespan: holdTime,
                        onHold: () => _hold(5),
                        onRelease: () => _release(5),
                        cancel: () => _cancel(5),
                        width: screenWidth * 0.5,
                        height: screenHeight * (1 / 3),
                      ),
                    if (_doubleTapVisible[4])
                      doubleTapFunc(
                        context,
                        const Color.fromARGB(255, 31, 233, 233),
                        () => _doubleTap(
                            5), //passes double tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                    if (_swipeVisible[4])
                      swipeFunc(
                        context,
                        const Color.fromARGB(255, 3, 19, 19),
                        () => _swipe(
                            5), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                  ],
                ),
                Stack(
                  //Button 6
                  children: <Widget>[
                    button(
                      '',
                      const Color.fromARGB(255, 255, 199, 194),
                      () => _incorrectPress(),
                      screenWidth * 0.5,
                      screenHeight * (1 / 3),
                    ),
                    if (_tapVisible[
                        5]) //displays gesture-wrapped container for tap
                      tapFunc(
                        context,
                        Colors.blueAccent,
                        () => _tap(
                            6), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                    if (_holdVisible[
                        5]) //displays gesture-wrapped container for hold. A lot more complicated than tap
                      HoldFunc(
                        color: const Color.fromARGB(255, 255, 199, 194),
                        lifespan: holdTime,
                        onHold: () => _hold(6),
                        onRelease: () => _release(6),
                        cancel: () => _cancel(6),
                        width: screenWidth * 0.5,
                        height: screenHeight * (1 / 3),
                      ),
                    if (_doubleTapVisible[5])
                      doubleTapFunc(
                        context,
                        const Color.fromARGB(255, 31, 233, 233),
                        () => _doubleTap(
                            6), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
                      ),
                    if (_swipeVisible[5])
                      swipeFunc(
                        context,
                        const Color.fromARGB(255, 3, 19, 19),
                        () => _swipe(
                            6), //passes tap function (that does the backend) to tap class (which displays the widget itself)
                        screenWidth * 0.5,
                        screenHeight * (1 / 3),
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
    int temp = random.nextInt(4);
    if (!isPaused) {
      timers[0] = Timer(
          randomDuration(5),
          () => setState(() {
                if (temp == 0) {
                  _tapVisible[0] = true;
                } else if (temp == 1) {
                  _holdVisible[0] = true;
                } else if (temp == 2) {
                  _doubleTapVisible[0] = true;
                } else {
                  _swipeVisible[0] = true;
                }
                startTime[1] = DateTime.now();
              }));
    }
  }

  void _scheduleButtonAppearance2() {
    //randomely schedule and select button 2
    int temp = random.nextInt(4);
    if (!isPaused) {
      timers[1] = Timer(
          randomDuration(5),
          () => setState(() {
                if (temp == 0) {
                  _tapVisible[1] = true;
                } else if (temp == 1) {
                  _holdVisible[1] = true;
                } else if (temp == 2) {
                  _doubleTapVisible[1] = true;
                } else {
                  _swipeVisible[1] = true;
                }
                startTime[2] = DateTime.now();
              }));
    }
  }

  void _scheduleButtonAppearance3() {
    //randomely schedule and select button 2
    int temp = random.nextInt(4);
    if (!isPaused) {
      timers[2] = Timer(
          randomDuration(5),
          () => setState(() {
                if (temp == 0) {
                  _tapVisible[2] = true;
                } else if (temp == 1) {
                  _holdVisible[2] = true;
                } else if (temp == 2) {
                  _doubleTapVisible[2] = true;
                } else {
                  _swipeVisible[2] = true;
                }
                startTime[3] = DateTime.now();
              }));
    }
  }

  void _scheduleButtonAppearance4() {
    //randomely schedule and select button 2
    int temp = random.nextInt(4);
    if (!isPaused) {
      timers[3] = Timer(
          randomDuration(5),
          () => setState(() {
                if (temp == 0) {
                  _tapVisible[3] = true;
                } else if (temp == 1) {
                  _holdVisible[3] = true;
                } else if (temp == 2) {
                  _doubleTapVisible[3] = true;
                } else {
                  _swipeVisible[3] = true;
                }
                startTime[4] = DateTime.now();
              }));
    }
  }

  void _scheduleButtonAppearance5() {
    //randomely schedule and select button 2
    int temp = random.nextInt(4);
    if (!isPaused) {
      timers[4] = Timer(
          randomDuration(5),
          () => setState(() {
                if (temp == 0) {
                  _tapVisible[4] = true;
                } else if (temp == 1) {
                  _holdVisible[4] = true;
                } else if (temp == 2) {
                  _doubleTapVisible[4] = true;
                } else {
                  _swipeVisible[4] = true;
                }
                startTime[5] = DateTime.now();
              }));
    }
  }

  void _scheduleButtonAppearance6() {
    //randomely schedule and select button 2
    int temp = random.nextInt(4);
    if (!isPaused) {
      timers[5] = Timer(
          randomDuration(5),
          () => setState(() {
                if (temp == 0) {
                  _tapVisible[5] = true;
                } else if (temp == 1) {
                  _holdVisible[5] = true;
                } else if (temp == 2) {
                  _doubleTapVisible[5] = true;
                } else {
                  _swipeVisible[5] = true;
                }
                startTime[6] = DateTime.now();
              }));
    }
  }
}
