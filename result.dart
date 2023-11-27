import 'package:flutter/material.dart';
import 'package:gesture_app/ease_of_use/button.dart';
import 'package:gesture_app/history.dart';
import 'package:gesture_app/play.dart';

class Result extends StatelessWidget {
  Result(
      {Key? key,
      required this.score,
      required this.historyData,
      required this.deduct})
      : super(key: key);
  final HistoryData historyData;
  final int deduct;
  final List<Duration> score;

  double calcResult() {
    int totalMilliseconds = score.fold<int>(
        0, (previousValue, element) => previousValue + element.inMilliseconds);
    double averageMilliseconds = totalMilliseconds / score.length;
    return double.parse((averageMilliseconds / 1000.0)
        .toStringAsFixed(2)); // Convert to seconds
  }

  void _navToMenu(BuildContext context) {
    historyData.add(calcResult());
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Play(
        title: 'Play',
        historyData: historyData,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 189, 227, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.all(5)),
            Container(
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              width: screenWidth * 0.8,
              height: screenHeight * 0.3,
              child: Text(
                'Average Speed:\n${calcResult()} Seconds\n\nMessed Up:\n$deduct',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenHeight * 0.045,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            button(
              'Back to Menu',
              Colors.blue,
              () => _navToMenu(context),
              screenWidth * 0.5,
              screenHeight * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
