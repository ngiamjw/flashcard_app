import 'package:flashcard_app/class/flashcard.dart';
import 'package:flashcard_app/class/folder.dart';
import 'package:flashcard_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashCardTile extends StatefulWidget {
  final Color backgroundColor;
  final Flashcard flashcard;
  const FlashCardTile(
      {super.key, required this.flashcard, required this.backgroundColor});

  @override
  State<FlashCardTile> createState() => _FlashCardTileState();
}

class _FlashCardTileState extends State<FlashCardTile> {
  @override
  bool changeQA = true;
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Show flashcard answer
          setState(() {
            changeQA = !changeQA;
          });
          // showDialog(
          //   context: context,
          //   builder: (context) => AlertDialog(
          //     title: Text(widget.flashcard.question),
          //     content: Text(widget.flashcard.answer),
          //     actions: [
          //       TextButton(
          //         onPressed: () => Navigator.pop(context),
          //         child: Text('Close'),
          //       ),
          //     ],
          //   ),
          // );
        },
        child: changeQA
            ? Stack(children: [
                Container(
                  height: 200,
                  width: 400,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(
                    widget.flashcard.question,
                    style: TextStyle(fontSize: 30),
                  )),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Text(
                    'Question',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 12),
                  ),
                ),
              ])
            : Stack(children: [
                Container(
                  height: 200,
                  width: 400,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(widget.flashcard.answer,
                          style: TextStyle(fontSize: 30))),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Text(
                    'Answer',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 12),
                  ),
                ),
              ]));
  }
}
