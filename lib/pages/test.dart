import 'package:flashcard_app/class/flashcard.dart';
import 'package:flashcard_app/class/folder.dart';
import 'package:flashcard_app/database/flashcard_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Test extends StatefulWidget {
  final Folder folder;
  const Test({super.key, required this.folder});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List<Flashcard> flashcardlist = [];
  void initState() {
    // Read existing habits on app startup
    Provider.of<FlashcardDatabase>(context, listen: false)
        .readFlashcards(widget.folder.id);
    flashcardlist = context.read<FlashcardDatabase>().currentFlashcard;
    flashcardlist.shuffle();
    super.initState();
    print(flashcardlist.length);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
