import 'package:flashcard_app/class/flashcard.dart';
import 'package:isar/isar.dart';

part 'folder.g.dart';

@Collection()
class Folder {
  Id id = Isar.autoIncrement; // Automatically incrementing ID

  late String name;

  late double percentage; // Name of the folder

  final flashcards =
      IsarLinks<Flashcard>(); // Link to the Flashcards in this folder
}
