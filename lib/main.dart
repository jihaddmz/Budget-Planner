import 'dart:io';

import 'package:budget_planner/helper_sharedpreferences.dart';
import 'package:budget_planner/helper_sqlite.dart';
import 'package:budget_planner/screen_months.dart';
import 'package:budget_planner/singletons.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await createDatabase();
  HelperSharedPreferences.instance = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

Future<void> initDB() async { // this method is to copy the data of db sqlite file
  String databasePath = await getDatabasesPath();
  String newPath = join(databasePath, '/db_app.db');
  final exist = await databaseExists(newPath);
  if (!exist) {
    try {
      final dbPath = await getDownloadsDirectory();
      final path = join(dbPath!.path, '/db_app.db');
      File(path).copySync(newPath);
    } catch (_) {}
  }
}

Future<void> createDatabase() async {
  // initDB();

  Singleton.db = await openDatabase(
          // Set the path to the database. Note: Using the `join` function from the
          // `path` package is best practice to ensure the path is correctly
          // constructed for each platform.
          join(await getDatabasesPath(), 'db_app.db'),
          onCreate: (db, version) async {
    await HelperSqlite.createTables(db);
  }, onUpgrade: (db, oldVersion, newVersion) {
    db.execute("alter table tbl_months add column savings double default 0");
  }, version: 2)
      .catchError((error) {
    debugPrint("error $error");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Planner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: ScreenMonths(),
    );
  }
}
