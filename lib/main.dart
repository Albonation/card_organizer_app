import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'database_helper.dart';
import 'models/card_item.dart';
import 'models/folder.dart';
import 'repositories/card_repository.dart';
import 'repositories/folder_repository.dart';
import 'screens/folders_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  //database helper test
  //await DatabaseHelper.instance.printDatabaseContents();

  //models and repositories test
  //_smokeTestRepositories();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Organizer App',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FoldersScreen(),
    );
  }
}

//a test to verify that the repositories and models are working correctly
Future<void> _smokeTestRepositories() async {
  await DatabaseHelper.instance.database; //ensure database is initialized

  final folderRepo = FolderRepository();
  final cardRepo = CardRepository();

  final folders = await folderRepo.getAllFolders();
  debugPrint('Repo folders: ${folders.length}');
  debugPrint('First folder model: ${folders.first}');

  for (final f in folders) {
    final count = await cardRepo.getCardCountByFolder(f.id!);
    debugPrint('  ${f.folderName} id=${f.id} count=$count');
  }

  final hearts = folders.firstWhere((f) => f.folderName == 'Hearts');
  final heartsCards = await cardRepo.getCardsByFolder(hearts.id!);
  debugPrint('Hearts cards: ${heartsCards.length}');
  debugPrint('Sample card model: ${heartsCards.first}');
  debugPrint('Sample card image path: ${heartsCards.first.imageUrl}');
}