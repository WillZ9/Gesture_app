import 'package:flutter/material.dart';
import 'package:gesture_app/ease_of_use/button.dart';
import 'package:gesture_app/history.dart';
import 'package:gesture_app/play.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Reflex Trainer',
      home: MyHomePage(title: 'Reflex Trainer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HistoryData historyData = HistoryData(<double>[]);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 189, 227, 255),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          button('Play', Colors.blue, () => _navToPlay(context),
              screenWidth * 0.8, screenHeight * 0.15),
          button('History', Colors.blue, () => _navToHist(context),
              screenWidth * 0.8, screenHeight * 0.15),
        ],
      )),
    );
  }

  void _navToPlay(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Play(title: 'Play', historyData: historyData);
    }));
  }

  void _navToHist(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return History(historyData: historyData);
    }));
  }
}
