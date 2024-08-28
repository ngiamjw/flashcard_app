import 'package:flashcard_app/class/folder.dart';
import 'package:flashcard_app/pages/folder_page.dart';
import 'package:flashcard_app/pages/home_page.dart';
import 'package:flashcard_app/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    'assets/images/flashcard_logo.png', // Replace with your logo asset
                    height: 70,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'FlashMaster',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Text(
                'Folders',
                style: TextStyle(fontSize: 20),
              ),
              title: Icon(
                Icons.folder,
                size: 30,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FlashcardHomePage()));
                // Add navigation logic to the folder page here
              },
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Text(
                "Dark",
                style: TextStyle(fontSize: 20),
              ),
              title: CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                onChanged: (value) =>
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme(),
              ),
            )
          ],
        ));
  }
}
