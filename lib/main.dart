import 'package:flashcard_app/database/flashcard_database.dart';
import 'package:flashcard_app/pages/home_page.dart';
import 'package:flashcard_app/pages/test_finish.dart';
import 'package:flashcard_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlashcardDatabase.initialise();
  runApp(MultiProvider(providers: [
    //habit provider
    ChangeNotifierProvider(create: (context) => FlashcardDatabase()),
    //theme provider
    ChangeNotifierProvider(create: (context) => ThemeProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlashcardHomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
