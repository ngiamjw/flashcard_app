import 'package:fl_chart/fl_chart.dart';
import 'package:flashcard_app/class/folder.dart';
import 'package:flashcard_app/pages/folder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FolderTile extends StatelessWidget {
  final Folder folder;
  Function(BuildContext)? editFolder;
  Function(BuildContext)? deleteFolder;
  // Function()? onTap;
  FolderTile({
    super.key,
    required this.folder,
    required this.editFolder,
    required this.deleteFolder,
  });

  List<PieChartSectionData> _getSections() {
    if (folder.percentage == -1) {
      return [
        PieChartSectionData(
            color: Colors.grey, value: 100, radius: 7, title: ''),
      ];
    }
    return [
      PieChartSectionData(
          color: Colors.green.shade400,
          value: folder.percentage,
          radius: 7,
          title: ''),
      PieChartSectionData(
          color: Colors.red.shade400,
          value: 100 - folder.percentage,
          radius: 7,
          title: ''),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FolderPage(
                      folder: folder,
                    )));
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          child: Slidable(
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: editFolder,
                    backgroundColor: Colors.grey,
                    icon: Icons.edit,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  SlidableAction(
                    onPressed: deleteFolder,
                    backgroundColor: Colors.red,
                    icon: Icons.delete,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
              child: Container(
                  // height: 200,
                  // width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding: const EdgeInsets.all(20),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        folder.name,
                        style: TextStyle(
                          color: Colors.black, // Adjust text color as needed
                          fontSize: 20, // Adjust font size as needed
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: PieChart(
                          PieChartData(
                            sections: _getSections(),
                            borderData: FlBorderData(show: false),
                            centerSpaceRadius:
                                10, // Adjust for the donut effect
                          ),
                        ),
                      ),
                    ],
                  )))),
    );
  }
}
