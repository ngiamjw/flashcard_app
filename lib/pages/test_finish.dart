import 'package:flashcard_app/pages/folder_page.dart';
import 'package:flashcard_app/pages/home_page.dart';
import 'package:flashcard_app/util/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TestFinish extends StatelessWidget {
  final double percentage;
  final int right;
  final int total;

  const TestFinish(
      {super.key,
      required this.percentage,
      required this.right,
      required this.total});

  List<PieChartSectionData> _getSections() {
    return [
      PieChartSectionData(
        color: Colors.green.shade400,
        value: percentage,
        title: '',
        radius: 50,
      ),
      PieChartSectionData(
          color: Colors.red.shade400,
          value: 100 - percentage,
          radius: 50,
          title: ''),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        drawer: MyDrawer(),
        body: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Center(
              child: SizedBox(
                width: 130,
                height: 130,
                child: PieChart(
                  PieChartData(
                    sections: _getSections(),
                    borderData: FlBorderData(show: false),
                    centerSpaceRadius: 120, // Adjust for the donut effect
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 150,
            ),
            Text(
              "$right / $total",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              child: Text(
                "back to folders",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FlashcardHomePage()));
              },
            )
          ],
        ));
  }
}
