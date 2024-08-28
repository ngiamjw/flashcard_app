import 'package:flashcard_app/class/flashcard.dart';
import 'package:flashcard_app/class/folder.dart';
import 'package:flashcard_app/database/flashcard_database.dart';
import 'package:flashcard_app/pages/folder_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateFlashcardPage extends StatefulWidget {
  final bool createOrEdit;
  final Folder folder;
  final int flashcard_id;
  const CreateFlashcardPage(
      {super.key,
      required this.folder,
      required this.createOrEdit,
      required this.flashcard_id});
  @override
  _CreateFlashcardPageState createState() => _CreateFlashcardPageState();
}

class _CreateFlashcardPageState extends State<CreateFlashcardPage> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  bool questionOranswer = true;

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void changeQA() {
    setState(() {
      questionOranswer = !questionOranswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Create Flashcard'),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: questionOranswer
              ? Column(
                  children: [
                    Center(
                      child: Text("question"),
                    ),
                    Container(
                      height: 200,
                      width: 400,
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: TextField(
                          cursorColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          controller: _questionController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: changeQA,
                          child: Text(
                            'Next',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Center(
                      child: Text("answer"),
                    ),
                    Container(
                      height: 200,
                      width: 400,
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: TextField(
                          cursorColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          controller: _answerController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: changeQA,
                          child: Text(
                            'Back',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (widget.createOrEdit) {
                              context.read<FlashcardDatabase>().addFlashcard(
                                  widget.folder.id,
                                  _questionController.text,
                                  _answerController.text);
                              Navigator.pop(context);
                            } else {
                              context.read<FlashcardDatabase>().editFlashcard(
                                  widget.flashcard_id,
                                  _questionController.text,
                                  _answerController.text,
                                  widget.folder.id);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
    );
  }
}
