import 'package:flashcard_app/class/flashcard.dart';
import 'package:flashcard_app/class/folder.dart';
import 'package:flashcard_app/database/flashcard_database.dart';
import 'package:flashcard_app/pages/create_flashcard.dart';
import 'package:flashcard_app/pages/test.dart';
import 'package:flashcard_app/pages/test_page.dart';
import 'package:flashcard_app/util/drawer.dart';
import 'package:flashcard_app/util/flashcard_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FolderPage extends StatefulWidget {
  final Folder folder;
  const FolderPage({super.key, required this.folder});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  @override
  void initState() {
    // Read existing habits on app startup
    Provider.of<FlashcardDatabase>(context, listen: false)
        .readFlashcards(widget.folder.id);
    super.initState();
  }

  int currentIndex = 0; // Member variable to maintain the current index

  void nextItem() {
    setState(() {
      List<Flashcard> flashcardlist =
          context.read<FlashcardDatabase>().currentFlashcard;
      if (currentIndex < flashcardlist.length - 1) {
        currentIndex += 1;
        print(currentIndex);
      }
    });
  }

  void previousItem() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Flashcard> flashcardlist =
        context.watch<FlashcardDatabase>().currentFlashcard;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TestPage(folder: widget.folder)));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        "Test",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ))
          ],
        ),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateFlashcardPage(
                          createOrEdit: true,
                          folder: widget.folder,
                          flashcard_id: 0,
                        )));
          },
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        body: flashcardlist.isEmpty
            ? Center(child: Text("Folder is empty"))
            : _buildFlashcardView(flashcardlist));
  }

  Widget _buildFlashcardView(List<Flashcard> flashcards) {
    return Column(
      children: [
        const SizedBox(height: 40),
        GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
                child: Text(
              widget.folder.name,
              style: TextStyle(fontSize: 25),
            ))),
        const SizedBox(height: 20),
        // Container(
        //   width: 200,
        //   height: 100,
        //   decoration: BoxDecoration(
        //     color: Colors.blueAccent,
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   child: Center(
        //     child: Text(
        //       flashcards[currentIndex].question,
        //       style: TextStyle(color: Colors.white, fontSize: 24),
        //     ),
        //   ),
        // ),
        FlashCardTile(
          flashcard: flashcards[currentIndex],
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(height: 20),
        // Counter with arrows
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left arrow
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: previousItem,
            ),
            // Counter text
            Text(
              '${currentIndex + 1} / ${flashcards.length}',
              style: TextStyle(fontSize: 22),
            ),
            // Right arrow
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: nextItem,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateFlashcardPage(
                              createOrEdit: false,
                              folder: widget.folder,
                              flashcard_id: flashcards[currentIndex].id,
                            )));
              },
              child: Text(
                'edit',
                style: TextStyle(fontWeight: FontWeight.w400),
              )),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: GestureDetector(
              onTap: () {
                context.read<FlashcardDatabase>().deleteFlashcard(
                    flashcards[currentIndex].id, widget.folder.id);
              },
              child: Text(
                'delete',
                style: TextStyle(fontWeight: FontWeight.w400),
              )),
        ),
      ],
    );
  }
}
