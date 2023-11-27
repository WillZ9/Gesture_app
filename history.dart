import 'package:flutter/material.dart';

class HistoryData {
  List<double> averageSpeedList;
  HistoryData(this.averageSpeedList);

  void add(double score) {
    averageSpeedList.add(score);
  }
  List<double> getHistory(){
    return averageSpeedList;
  }
}

class History extends StatelessWidget {
  const History({Key? key, required this.historyData}) : super(key: key);//didn't have time to implement history
  final HistoryData historyData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Container(
        color: Colors.grey,
        child: ListView.builder(
          itemCount: historyData.getHistory().length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${historyData.getHistory()[index]}'),
            );
          },
        ),
      ),
    );
  }
}
