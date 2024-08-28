import 'package:flashcard_app/class/flashcard.dart';
import 'package:flashcard_app/class/folder.dart';
import 'package:flashcard_app/database/flashcard_database.dart';
import 'package:flashcard_app/pages/create_flashcard.dart';
import 'package:flashcard_app/pages/folder_page.dart';
import 'package:flashcard_app/util/drawer.dart';
import 'package:flashcard_app/util/flashcard_tile.dart';
import 'package:flashcard_app/util/folder_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashcardHomePage extends StatefulWidget {
  @override
  State<FlashcardHomePage> createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage> {
  final TextEditingController mycontroller = TextEditingController();
  @override
  void initState() {
    // Read existing habits on app startup
    Provider.of<FlashcardDatabase>(context, listen: false).readFolders();
    super.initState();
  }

  void editFolder(Folder folder) {
    mycontroller.text = folder.name;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                content: TextField(
                  controller: mycontroller,
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      String newFolderName = mycontroller.text;

                      // Save to db using isar
                      context
                          .read<FlashcardDatabase>()
                          .editFolder(folder.id, newFolderName);

                      Navigator.pop(context);

                      mycontroller.clear();
                    },
                    child: const Text("Save"),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      mycontroller.clear();
                    },
                    child: const Text("Cancel"),
                  )
                ]));
  }

  void deleteFolder(Folder folder) {
    context.read<FlashcardDatabase>().deleteFolder(folder.id);
  }

  void createNewFolder() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                content: TextField(
                  controller: mycontroller,
                  decoration: InputDecoration(hintText: "Create a new Folder"),
                ),
                actions: [
                  MaterialButton(
                    onPressed: () async {
                      String text = mycontroller.text;

                      context.read<FlashcardDatabase>().addFolder(text);

                      // Save to db using isar
                      Navigator.pop(context);

                      mycontroller.clear();
                    },
                    child: const Text("Save"),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      mycontroller.clear();
                    },
                    child: const Text("Cancel"),
                  )
                ]));
  }

  // void folderOnTap(Folder folder) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => FolderPage(
  //                 folder: folder,
  //               )));
  // }

  Widget build(BuildContext context) {
    List<Folder> currentFolders =
        context.watch<FlashcardDatabase>().currentFolders;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewFolder,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: currentFolders.isEmpty
          ? Center(child: Text('No folders yet'))
          : ListView.builder(
              itemCount: currentFolders.length,
              itemBuilder: (context, index) {
                return FolderTile(
                  folder: currentFolders[index],
                  editFolder: (value) => editFolder(currentFolders[index]),
                  deleteFolder: (value) => deleteFolder(currentFolders[index]),
                );
              },
            ),
    );
  }
}
