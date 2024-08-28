import 'package:flashcard_app/class/flashcard.dart';
import 'package:flashcard_app/class/folder.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class FlashcardDatabase extends ChangeNotifier {
  static late Isar isar;
  //SETUP

  //INITIALISE DATABASE
  static Future<void> initialise() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      FolderSchema,
      FlashcardSchema,
    ], directory: dir.path);
  }

  final List<Folder> currentFolders = [];

  //ADD FOLDER
  Future<void> addFolder(String FolderName) async {
    //create new habit
    final newFolder = Folder()
      ..name = FolderName
      ..percentage = -1;

    //save to db
    await isar.writeTxn(() => isar.folders.put(newFolder));
    // re-read from db
    readFolders();
  }

  //READ FOLDER
  Future<void> readFolders() async {
    List<Folder> fetchedFolders = await isar.folders.where().findAll();
    currentFolders.clear();
    currentFolders.addAll(fetchedFolders);
    //update UI
    notifyListeners();
  }

  //EDIT FOLDER
  Future<void> editFolder(int id, String newName) async {
    final folder = await isar.folders.get(id);
    if (folder != null) {
      await isar.writeTxn(() async {
        folder.name = newName;
        await isar.folders.put(folder);
      });
    }
    readFolders();
  }

  Future<void> editFolderPercentage(int id, double percentage) async {
    final folder = await isar.folders.get(id);
    if (folder != null) {
      await isar.writeTxn(() async {
        folder.percentage = percentage;
        await isar.folders.put(folder);
      });
    }
    readFolders();
  }

  //DELETE FOLDER
  Future<void> deleteFolder(int id) async {
    final folder = await isar.folders.get(id);
    if (folder != null) {
      await isar.writeTxn(() async {
        // Delete all flashcards in the folder
        await folder.flashcards.load(); // Load the linked flashcards
        for (var flashcard in folder.flashcards) {
          await isar.flashcards.delete(flashcard.id);
        }
        // Delete the folder itself
        await isar.folders.delete(id);
      });
    }
    readFolders(); // Update the folders list to reflect changes
  }

  //ADD FLASHCARD
  Future<void> addFlashcard(
      int folderId, String question, String answer) async {
    final folder = await isar.folders.get(folderId);
    if (folder != null) {
      final newFlashcard = Flashcard()
        ..question = question
        ..answer = answer
        ..folder.value = folder;

      await isar.writeTxn(() async {
        await isar.flashcards.put(newFlashcard);
        folder.flashcards.add(newFlashcard);
        await folder.flashcards.save();
      });
    }
    readFolders();
    readFlashcards(folderId); // Update the folders list to reflect changes
  }

  final List<Flashcard> currentFlashcard = [];

  //READ FLASHCARD
  // Future<List<Flashcard>> readFlashcards(int folderId) async {
  //   final folder = await isar.folders.get(folderId);
  //   if (folder != null) {
  //     // return folder.flashcards.toList();
  //     currentFlashcard.clear();
  //     currentFlashcard.addAll(folder.flashcards.toList());
  //   }
  //   return [];
  // }

  Future<void> readFlashcards(int folderId) async {
    final folder = await isar.folders.get(folderId);
    if (folder != null) {
      // return folder.flashcards.toList();
      currentFlashcard.clear();
      currentFlashcard.addAll(folder.flashcards.toList());
      notifyListeners();
    }
  }

  //EDIT FLASHCARD
  Future<void> editFlashcard(
      int id, String newQuestion, String newAnswer, int folderId) async {
    final flashcard = await isar.flashcards.get(id);
    if (flashcard != null) {
      await isar.writeTxn(() async {
        flashcard.question = newQuestion;
        flashcard.answer = newAnswer;
        await isar.flashcards.put(flashcard);
      });
    }
    readFolders();
    readFlashcards(folderId); // Update the folders list to reflect changes
  }

  //DELETE FLASHCARD
  Future<void> deleteFlashcard(int id, int folderId) async {
    await isar.writeTxn(() async {
      await isar.flashcards.delete(id);
    });
    readFolders();
    readFlashcards(folderId); // Update the folders list to reflect changes
  }

  //CREATE DRAWING POINT
}
