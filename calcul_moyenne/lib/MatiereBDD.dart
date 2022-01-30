import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Matiere.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Note.dart';

class MatiereBDD {

  MatiereBDD._();

  static final MatiereBDD instance = MatiereBDD._();
  static Database? _database;
  double moyenne = 0;


  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'notes_database4.db'),
      onCreate: (db, version) {
        print("CREATION");
        return db.execute(
          "CREATE TABLE matiere(id TEXT PRIMARY KEY, moyenne DOUBLE, coef DOUBLE)",
        );
      },
      version: 1,
    );
  }
  void insertMatiere(Matiere recipe) async {
    final Database? db = await database;

    await db?.insert(
      'matiere',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final List<Map<String, Object?>>? maps = await db?.query('matiere');
    List<Matiere> recipes = List.generate(maps!.length, (i) {
      return Matiere.fromMap(maps[i]);
    });


  }

  void updateMatiere(Matiere matiere) async {
    final Database? db = await database;
    await db?.update("matiere", matiere.toMap(),
        where: "id = ?", whereArgs: [matiere.id]);
  }

  void deleteMatiere(String matiere) async {
    final Database? db = await database;
    final List<Map<String, Object?>>? maps = await db?.query('matiere');
    List<Matiere> recipes = List.generate(maps!.length, (i) {
      return Matiere.fromMap(maps[i]);
    });

    // on supprime la matiere
    db?.delete("matiere", where: "id = ?", whereArgs: [matiere]);


    // on supprime aussi toutes les notes reliés à cette matière
    final List<Map<String, Object?>>? maps2 = await db?.query('note');
    List<Note> notes = List.generate(maps2!.length, (i) {
      return Note.fromMap(maps[i]);
    });
    db?.delete("note", where: "matiere = ?", whereArgs: [matiere]);
    print("delete");
  }

  Future<List<Matiere>> matieres() async {
    final Database? db = await database;
    final List<Map<String, Object?>>? maps = await db?.query('matiere');
    List<Matiere> recipes = List.generate(maps!.length, (i) {
      return Matiere.fromMap(maps[i]);
    });
    if (recipes.isEmpty) {
      print("vIDE");
      for (Matiere recipe in defaultRecipes) {
        insertMatiere(recipe);
      }
      recipes = defaultRecipes;
    }

    return recipes;
  }

  Future<String> MatiereExist(String matiere) async {
    final Database? db = await database;
    final List<Map<String, Object?>>? maps = await db?.rawQuery('SELECT * FROM matiere WHERE id=?', [matiere]);
    List<Matiere> recipes = List.generate(maps!.length, (i) {
      return Matiere.fromMap(maps[i]);
    });
    if (recipes.isEmpty) {
      return "no";
    }
    else{
      return "ok";
    }

  }


  final List<Matiere> defaultRecipes = [];

}