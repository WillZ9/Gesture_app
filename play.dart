import 'package:flutter/material.dart';
import 'package:gesture_app/ease_of_use/button.dart';
import 'package:gesture_app/game.dart';
import 'package:gesture_app/main.dart';
import 'package:gesture_app/history.dart';

class Play extends StatelessWidget {
  const Play({Key? key, required this.title, required this.historyData})
      : super(key: key);
  final String title;
  final HistoryData historyData;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 189, 227, 255),
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          button('Home', Colors.blue, () => _navToHome(context),
              screenWidth * 0.5, screenHeight * 0.1),
          button(
              'Easy',
              const Color.fromARGB(255, 175, 244, 198),
              () => _navToGameE(context),
              screenWidth * 0.8,
              screenHeight * 0.1),
          button(
              'Medium',
              const Color.fromARGB(255, 255, 232, 164),
              () => _navToGameM(context),
              screenWidth * 0.8,
              screenHeight * 0.1),
          button(
              'Hard',
              const Color.fromARGB(255, 255, 199, 194),
              () => _navToGameH(context),
              screenWidth * 0.8,
              screenHeight * 0.1),
        ],
      )),
    );
  }

  void _navToGameE(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Game(title: 'Easy', historyData: historyData);
    }));
  }

  void _navToGameM(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Game(title: 'Medium', historyData: historyData);
    }));
  }

  void _navToGameH(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Game(title: 'Hard', historyData: historyData);
    }));
  }

  void _navToHome(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const MyApp();
    }));
  }
}
