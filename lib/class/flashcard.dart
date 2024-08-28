import 'package:flashcard_app/class/folder.dart';
import 'package:isar/isar.dart';

part 'flashcard.g.dart';

@Collection()
class Flashcard {
  Id id = Isar.autoIncrement; // Automatically incrementing ID

  late String question; // The flashcard question
  late String answer; // The flashcard answer

  final folder = IsarLink<Folder>(); // Link back to the folder (optional)
}
