import 'package:flashcard_app/class/flashcard.dart';
import 'package:flashcard_app/class/folder.dart';
import 'package:flashcard_app/database/flashcard_database.dart';
import 'package:flashcard_app/pages/test_finish.dart';
import 'package:flashcard_app/util/drawer.dart';
import 'package:flashcard_app/util/flashcard_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

class TestPage extends StatefulWidget {
  final Folder folder;
  const TestPage({super.key, required this.folder});

  @override
  State<TestPage> createState() => _TestPageState();
}

class Content {
  final String question;
  final String answer;

  Content({required this.question, required this.answer});
}

class _TestPageState extends State<TestPage> {
  List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<Flashcard> flashcardlist = [];
  int right = 0;

  Color _backgroundColor = Colors.white;

  void initState() {
    // Read existing habits on app startup
    Provider.of<FlashcardDatabase>(context, listen: false)
        .readFlashcards(widget.folder.id);
    flashcardlist = context.read<FlashcardDatabase>().currentFlashcard;
    flashcardlist.shuffle();
    for (int i = 0; i < flashcardlist.length; i++) {
      _swipeItems.add(SwipeItem(
        content: Content(
            question: flashcardlist[i].question,
            answer: flashcardlist[i].answer),
        likeAction: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Liked ${[i]}"),
            duration: Duration(milliseconds: 500),
          ));
          right += 1;
        },
        nopeAction: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Nope ${[i]}"),
            duration: Duration(milliseconds: 500),
          ));
        },
        onSlideUpdate: (details) async {
          setState(() {
            if (details == SlideRegion.inLikeRegion) {
              _backgroundColor = Colors.green.withOpacity(0.5);
            } else if (details == SlideRegion.inNopeRegion) {
              _backgroundColor = Colors.red.withOpacity(0.5);
            } else {
              _backgroundColor = Colors.white;
            }
          });
        },
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
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
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        drawer: MyDrawer(),
        body: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              height: 550,
              child: Center(
                child: SwipeCards(
                    matchEngine: _matchEngine,
                    onStackFinished: () {
                      double percentage = (right / flashcardlist.length) * 100;
                      context
                          .read<FlashcardDatabase>()
                          .editFolderPercentage(widget.folder.id, percentage);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TestFinish(
                                    percentage: percentage,
                                    right: right,
                                    total: flashcardlist.length,
                                  )));
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return FlashCardTile(
                          flashcard: flashcardlist[index],
                          backgroundColor: _backgroundColor);
                    }),
              ),
            ),
          ],
        ));
  }
}
